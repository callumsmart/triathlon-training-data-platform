with risks as (

    select *

    from {{ ref('mart_training_risk_flags') }}

),

readiness as (

    select *

    from {{ ref('mart_training_readiness') }}

)

select

    risks.athlete_id,


    /*
    Swim recommendation
    */

    case

        when risks.swimming_risk is not null

        then 'Prioritise swimming consistency with two swim sessions next week'

        else 'Maintain current swimming frequency'

    end as swim_recommendation,


    /*
    Bike recommendation
    */

    case

        when risks.cycling_risk is not null

        then 'Increase cycling frequency to improve bike endurance before race'

        else 'Maintain cycling volume'

    end as bike_recommendation,


    /*
    Run recommendation
    */

    case

        when readiness.current_phase = 'build'

        then 'Continue progressive running volume while avoiding consecutive hard run days'

        else 'Maintain current running structure'

    end as run_recommendation,


    /*
    Volume recommendation
    */

    case

        when risks.volume_risk is not null

        then 'Reduce training load slightly and allow recovery'

        else 'Continue gradual progression'

    end as volume_recommendation,


    /*
    Overall recommendation
    */

    case

        when risks.swimming_risk is not null
             and risks.cycling_risk is not null

        then 'Prioritise triathlon balance by increasing swim and bike consistency'

        when risks.swimming_risk is not null

        then 'Focus on improving swim consistency'

        when risks.cycling_risk is not null

        then 'Focus on improving bike consistency'

        else 'Training is balanced. Continue current progression'

    end as overall_recommendation


from risks

left join readiness

using (athlete_id)