# Triathlon Training Data Platform

A personal data engineering and analytics engineering project that ingests training data, transforms it using dbt, and produces insights across running, swimming and cycling.

## Planned Architecture

Strava API → Python ingestion → DuckDB → dbt → Data quality tests → Analytical models → Training intelligence