from pathlib import Path
import hashlib
import re

import duckdb
import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATABASE_FILE = PROJECT_ROOT / "data" / "triathlon.duckdb"


def standardise_column_name(column_name: str) -> str:
    """Convert Garmin column names to snake_case."""

    column_name = column_name.lower()

    column_name = re.sub(
        r"[®™]",
        "",
        column_name,
    )

    column_name = re.sub(
        r"[^a-z0-9]+",
        "_",
        column_name,
    )

    return column_name.strip("_")


def standardise_sport(
    activity_type: str,
) -> str:
    """Map Garmin activity types into broad sport categories."""

    if activity_type == "Running":
        return "running"

    if activity_type in [
        "Pool Swim",
        "Open Water Swimming",
    ]:
        return "swimming"

    if activity_type == "Cycling":
        return "cycling"

    return "other"


def convert_distance_to_km(
    distance: float,
    activity_type: str,
) -> float:
    """Convert Garmin distance values to kilometres."""

    if pd.isna(distance):
        return None

    if activity_type in [
        "Pool Swim",
        "Open Water Swimming",
    ]:
        return distance / 1000

    return distance


def convert_duration_to_seconds(
    duration,
) -> int:
    """Convert HH:MM:SS duration into seconds."""

    if pd.isna(duration):
        return None

    duration = str(duration).strip()

    if duration in [
        "--",
        "",
        "nan",
        "NaT",
    ]:
        return None

    time_parts = duration.split(":")

    if len(time_parts) != 3:
        return None

    try:
        hours = int(time_parts[0])
        minutes = int(time_parts[1])
        seconds = int(
            float(time_parts[2])
        )

    except ValueError:
        return None

    return (
        hours * 3600
        + minutes * 60
        + seconds
    )


def convert_pace_to_seconds(
    pace,
) -> float:
    """Convert MM:SS pace into total seconds."""

    if pd.isna(pace):
        return None

    pace = str(pace).strip()

    if pace in [
        "--",
        "",
        "nan",
        "NaT",
    ]:
        return None

    pace_parts = pace.split(":")

    if len(pace_parts) != 2:
        return None

    try:
        minutes = int(pace_parts[0])
        seconds = float(pace_parts[1])

    except ValueError:
        return None

    return (
        minutes * 60
        + seconds
    )


def create_activity_id(
    row: pd.Series,
) -> str:
    """Create a deterministic SHA-256 identifier."""

    raw_id = (
        f"{row['activity_type']}_"
        f"{row['activity_date']}_"
        f"{row['title']}_"
        f"{row['duration_seconds']}"
    )

    return hashlib.sha256(
        raw_id.encode("utf-8")
    ).hexdigest()


def main():
    connection = duckdb.connect(
        DATABASE_FILE
    )

    activities = connection.execute(
        """
        SELECT *
        FROM raw_garmin_activities
        """
    ).fetchdf()

    # Standardise all Garmin column names
    activities.columns = [
        standardise_column_name(
            column
        )
        for column in activities.columns
    ]

    # Convert Garmin missing values to NULL
    activities = activities.replace(
        "--",
        pd.NA,
    )

    # Rename columns to clean analytical names
    activities = activities.rename(
        columns={
            "date": "activity_date",
            "time": "duration",
            "avg_hr": "avg_heart_rate",
            "max_hr": "max_heart_rate",
            "aerobic_te": (
                "aerobic_training_effect"
            ),
            "normalized_power_np": (
                "normalized_power"
            ),
            "avg_stride_length": (
                "avg_stride_length_m"
            ),
            "avg_ground_contact_time": (
                "avg_ground_contact_time_ms"
            ),
            "avg_swim_cadence": (
                "avg_swim_cadence"
            ),
            "max_swim_cadence": (
                "max_swim_cadence"
            ),
        }
    )

    # Convert date
    activities["activity_date"] = (
        pd.to_datetime(
            activities["activity_date"]
        )
    )

    # Convert numeric columns
    numeric_columns = [
        "distance",
        "calories",
        "avg_heart_rate",
        "max_heart_rate",
        "aerobic_training_effect",
        "total_ascent",
        "total_descent",
        "avg_power",
        "max_power",
        "normalized_power",
        "training_stress_score",
        "total_strokes",
        "avg_swolf",
        "avg_stroke_rate",
        "number_of_laps",
        "avg_stride_length_m",
        "avg_vertical_ratio",
        "avg_vertical_oscillation",
        "avg_ground_contact_time_ms",
        "avg_swim_cadence",
        "max_swim_cadence",
        "steps",
        "total_reps",
        "total_sets",
        "body_battery_drain",
        "min_temp",
        "max_temp",
        "avg_resp",
        "min_resp",
        "max_resp",
        "min_elevation",
        "max_elevation",
    ]

    for column in numeric_columns:
        if column in activities.columns:
            activities[column] = pd.to_numeric(
                activities[column],
                errors="coerce",
            )

    # Create standardised sport category
    activities["sport_category"] = (
        activities["activity_type"].apply(
            standardise_sport
        )
    )

    # Convert distance to kilometres
    activities["distance_km"] = (
        activities.apply(
            lambda row: convert_distance_to_km(
                row["distance"],
                row["activity_type"],
            ),
            axis=1,
        )
    )

    # Convert durations
    activities["duration_seconds"] = (
        activities["duration"].apply(
            convert_duration_to_seconds
        )
    )

    activities["moving_time_seconds"] = (
        activities["moving_time"].apply(
            convert_duration_to_seconds
        )
    )

    activities["elapsed_time_seconds"] = (
        activities["elapsed_time"].apply(
            convert_duration_to_seconds
        )
    )

    # Convert running pace
    activities[
        "avg_pace_seconds_per_km"
    ] = activities.apply(
        lambda row: (
            convert_pace_to_seconds(
                row["avg_pace"]
            )
            if row["sport_category"]
            == "running"
            else None
        ),
        axis=1,
    )

    # Convert swimming pace
    activities[
        "avg_pace_seconds_per_100m"
    ] = activities.apply(
        lambda row: (
            convert_pace_to_seconds(
                row["avg_pace"]
            )
            if row["sport_category"]
            == "swimming"
            else None
        ),
        axis=1,
    )

    # Convert running GAP
    activities[
        "avg_gap_seconds_per_km"
    ] = activities.apply(
        lambda row: (
            convert_pace_to_seconds(
                row["avg_gap"]
            )
            if row["sport_category"]
            == "running"
            else None
        ),
        axis=1,
    )

    # Generate deterministic activity IDs
    activities["activity_id"] = (
        activities.apply(
            create_activity_id,
            axis=1,
        )
    )

    # Create staging table
    connection.execute(
        """
        CREATE OR REPLACE TABLE
        stg_activities AS
        SELECT *
        FROM activities
        """
    )

    connection.close()

    print(
        f"Created stg_activities with "
        f"{len(activities)} activities"
    )


if __name__ == "__main__":
    main()