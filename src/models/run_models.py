from pathlib import Path

import duckdb


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATABASE_FILE = PROJECT_ROOT / "data" / "triathlon.duckdb"
MODELS_DIRECTORY = PROJECT_ROOT / "src" / "models"


def main():
    connection = duckdb.connect(DATABASE_FILE)

    model_files = [
        "fct_running_activities.sql",
        "fct_cycling_activities.sql",
        "fct_swimming_activities.sql",
        "int_training_sessions.sql",
        "mart_weekly_training_summary.sql",
    ]

    for model_file in model_files:
        model_path = MODELS_DIRECTORY / model_file

        model_sql = model_path.read_text()

        table_name = model_file.replace(".sql", "")

        connection.execute(
            f"""
            CREATE OR REPLACE TABLE {table_name} AS
            {model_sql}
            """
        )

        row_count = connection.execute(
            f"""
            SELECT COUNT(*)
            FROM {table_name}
            """
        ).fetchone()[0]

        print(
            f"Created {table_name} "
            f"with {row_count} rows"
        )

    connection.close()


if __name__ == "__main__":
    main()