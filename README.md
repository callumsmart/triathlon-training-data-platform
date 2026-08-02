# Triathlon Training Data Platform

An analytics engineering project that transforms Garmin training data into analytics-ready datasets using Python, DuckDB and dbt.

The goal of this project is to build a small-scale data platform for analysing endurance training across running, cycling and swimming activities.

## Architecture

Garmin CSV Export  
↓  
Raw data layer (DuckDB)  
↓  
dbt staging models  
↓  
Sport-specific fact tables  
↓  
Training session model  
↓  
Analytics marts  

## Tech Stack

- Python - data ingestion and pipeline orchestration
- DuckDB - analytical database
- dbt Core - SQL transformations, testing and documentation
- SQL - data modelling
- Git/GitHub - version control

## dbt Models

### Staging

`stg_activities`

- Cleans raw Garmin exports
- Standardises column names
- Creates activity identifiers
- Categorises activities into running, cycling and swimming
- Converts distance and duration fields into analytics-ready formats

### Fact Models

`fct_running_activities`

Running-specific metrics including:
- Distance
- Pace
- Heart rate
- Running dynamics

`fct_cycling_activities`

Cycling-specific metrics including:
- Distance
- Power
- Training Stress Score
- Elevation

`fct_swimming_activities`

Swimming-specific metrics including:
- Distance
- Stroke metrics
- SWOLF
- Laps

### Intermediate

`int_training_sessions`

Combines all sports into a unified training activity table.

### Marts

`mart_weekly_training_summary`

Provides weekly training insights including:
- Training volume
- Distance by sport
- Training hours
- Heart rate trends
- Aerobic training load

## Running the Project

Install dependencies:

```bash
pip install -r requirements.txt