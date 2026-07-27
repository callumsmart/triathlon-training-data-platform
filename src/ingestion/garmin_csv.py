from pathlib import Path

import duckdb
import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[2]
INPUT_FILE = PROJECT_ROOT / "data" / "raw" / "garmin_activities.csv"
DATABASE_FILE = PROJECT_ROOT / "data" / "triathlon.duckdb"


def load_garmin_activities(file_path: Path) -> pd.DataFrame:
    """Load Garmin activity data from CSV."""

    return pd.read_csv(
    file_path,
    thousands=",",
)


def load_to_duckdb(df: pd.DataFrame, database_path: Path) -> None:
    """Load Garmin activity data into the raw DuckDB table."""

    connection = duckdb.connect(database_path)

    connection.execute(
        """
        CREATE OR REPLACE TABLE raw_garmin_activities AS
        SELECT * FROM df
        """
    )

    connection.close()


if __name__ == "__main__":
    activities = load_garmin_activities(INPUT_FILE)

    print(f"Loaded {len(activities)} activities from Garmin CSV")
    print(f"Columns: {len(activities.columns)}")

    load_to_duckdb(activities, DATABASE_FILE)

    print(f"Saved data to {DATABASE_FILE}")