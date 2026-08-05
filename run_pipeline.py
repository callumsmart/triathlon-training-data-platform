import subprocess


def run_step(description, command):
    print(f"\n{'=' * 60}")
    print(description)
    print(f"{'=' * 60}\n")

    subprocess.run(command, check=True)


def main():
    run_step(
        "INGEST GARMIN DATA",
        ["python", "src/ingestion/garmin_csv.py"],
    )

    run_step(
        "BUILD DBT MODELS",
        ["dbt", "build"],
    )

    print("\nPipeline completed successfully.")


if __name__ == "__main__":
    main()