from pathlib import Path

import duckdb


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATABASE_FILE = PROJECT_ROOT / "data" / "triathlon.duckdb"


def main():
    connection = duckdb.connect(DATABASE_FILE)

    print("\nACTIVITIES BY TYPE")
    print("------------------")

    activity_counts = connection.execute(
        """
        SELECT
            "Activity Type",
            COUNT(*) AS activity_count
        FROM raw_garmin_activities
        GROUP BY "Activity Type"
        ORDER BY activity_count DESC
        """
    ).fetchdf()

    print(activity_counts.to_string(index=False))

    print("\nDATE RANGE")
    print("----------")

    date_range = connection.execute(
        """
        SELECT
            MIN("Date") AS earliest_activity,
            MAX("Date") AS latest_activity
        FROM raw_garmin_activities
        """
    ).fetchdf()

    print(date_range.to_string(index=False))

    print("\nSAMPLE ACTIVITIES")
    print("-----------------")

    sample = connection.execute(
        """
        SELECT
            "Activity Type",
            "Date",
            "Title",
            "Distance",
            "Time",
            "Avg HR"
        FROM raw_garmin_activities
        ORDER BY "Date" DESC
        LIMIT 10
        """
    ).fetchdf()

    print(sample.to_string(index=False))

    connection.close()


if __name__ == "__main__":
    main()