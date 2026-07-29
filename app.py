from pathlib import Path

import duckdb
import pandas as pd
import streamlit as st


PROJECT_ROOT = Path(__file__).resolve().parent
DATABASE_FILE = PROJECT_ROOT / "data" / "triathlon.duckdb"


st.set_page_config(
    page_title="Triathlon Training Dashboard",
    layout="wide",
)


@st.cache_data
def load_weekly_summary():
    connection = duckdb.connect(DATABASE_FILE, read_only=True)

    data = connection.execute(
        """
        SELECT *
        FROM mart_weekly_training_summary
        ORDER BY training_week
        """
    ).fetchdf()

    connection.close()

    return data


@st.cache_data
def load_sport_activities(sport):
    connection = duckdb.connect(DATABASE_FILE, read_only=True)

    table_name = f"fct_{sport}_activities"

    data = connection.execute(
        f"""
        SELECT *
        FROM {table_name}
        ORDER BY activity_date
        """
    ).fetchdf()

    connection.close()

    return data


st.title("Triathlon Training Dashboard")


# ============================================================
# WEEKLY TRAINING OVERVIEW
# ============================================================

st.header("Training Overview")

weekly_summary = load_weekly_summary()

col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric(
        "Total Sessions",
        int(weekly_summary["total_sessions"].sum()),
    )

with col2:
    st.metric(
        "Running Distance",
        f"{weekly_summary['running_distance_km'].sum():.1f} km",
    )

with col3:
    st.metric(
        "Cycling Distance",
        f"{weekly_summary['cycling_distance_km'].sum():.1f} km",
    )

with col4:
    st.metric(
        "Swimming Distance",
        f"{weekly_summary['swimming_distance_km'].sum():.1f} km",
    )


st.subheader("Weekly Distance")

distance_data = weekly_summary[
    [
        "training_week",
        "running_distance_km",
        "cycling_distance_km",
        "swimming_distance_km",
    ]
].copy()

distance_data = distance_data.set_index("training_week")

st.line_chart(distance_data)


st.subheader("Weekly Training Hours")

hours_data = weekly_summary[
    [
        "training_week",
        "total_training_hours",
    ]
].copy()

hours_data = hours_data.set_index("training_week")

st.bar_chart(hours_data)


# ============================================================
# SPORT ANALYSIS
# ============================================================

st.header("Sport Analysis")

sport = st.selectbox(
    "Select a sport",
    [
        "running",
        "cycling",
        "swimming",
    ],
)

activities = load_sport_activities(sport)


if sport == "running":

    st.subheader("Running Performance")

    col1, col2, col3 = st.columns(3)

    with col1:
        st.metric(
            "Total Distance",
            f"{activities['distance_km'].sum():.1f} km",
        )

    with col2:
        st.metric(
            "Average Pace",
            f"{activities['avg_pace_seconds_per_km'].mean() / 60:.2f} min/km",
        )

    with col3:
        st.metric(
            "Average Heart Rate",
            f"{activities['avg_heart_rate'].mean():.0f} bpm",
        )


    st.subheader("Running Pace Over Time")

    pace_data = activities[
        [
            "activity_date",
            "avg_pace_seconds_per_km",
        ]
    ].copy()

    pace_data = pace_data.set_index("activity_date")

    st.line_chart(pace_data)


    st.subheader("Running Distance Over Time")

    distance_data = activities[
        [
            "activity_date",
            "distance_km",
        ]
    ].copy()

    distance_data = distance_data.set_index("activity_date")

    st.bar_chart(distance_data)


elif sport == "swimming":

    st.subheader("Swimming Performance")

    col1, col2, col3 = st.columns(3)

    with col1:
        st.metric(
            "Total Distance",
            f"{activities['distance_km'].sum():.1f} km",
        )

    with col2:
        st.metric(
            "Average Pace",
            f"{activities['avg_pace_seconds_per_100m'].mean() / 60:.2f} min/100m",
        )

    with col3:
        st.metric(
            "Average Swolf",
            f"{activities['avg_swolf'].mean():.0f}",
        )


    st.subheader("Swimming Pace Over Time")

    pace_data = activities[
        [
            "activity_date",
            "avg_pace_seconds_per_100m",
        ]
    ].copy()

    pace_data = pace_data.set_index("activity_date")

    st.line_chart(pace_data)


    st.subheader("Swimming Distance Over Time")

    distance_data = activities[
        [
            "activity_date",
            "distance_km",
        ]
    ].copy()

    distance_data = distance_data.set_index("activity_date")

    st.bar_chart(distance_data)


elif sport == "cycling":

    st.subheader("Cycling Performance")

    col1, col2, col3 = st.columns(3)

    with col1:
        st.metric(
            "Total Distance",
            f"{activities['distance_km'].sum():.1f} km",
        )

    with col2:
        st.metric(
            "Average Heart Rate",
            f"{activities['avg_heart_rate'].mean():.0f} bpm",
        )

    with col3:
        st.metric(
            "Total Elevation Gain",
            f"{activities['total_ascent'].sum():.0f} m",
        )


    st.subheader("Cycling Distance Over Time")

    distance_data = activities[
        [
            "activity_date",
            "distance_km",
        ]
    ].copy()

    distance_data = distance_data.set_index("activity_date")

    st.bar_chart(distance_data)


    st.subheader("Cycling Heart Rate Over Time")

    heart_rate_data = activities[
        [
            "activity_date",
            "avg_heart_rate",
        ]
    ].copy()

    heart_rate_data = heart_rate_data.set_index("activity_date")

    st.line_chart(heart_rate_data)


# ============================================================
# RAW ACTIVITY DATA
# ============================================================

st.header("Activity Data")

st.dataframe(
    activities.sort_values(
        "activity_date",
        ascending=False,
    ),
    use_container_width=True,
)