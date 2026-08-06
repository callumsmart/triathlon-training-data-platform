select *
from {{ ref('stg_athlete_profile') }}

where race_date <= current_date