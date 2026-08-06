select

    athlete_id,

    constraint_type,

    constraint_description

from {{ ref('constraints') }}