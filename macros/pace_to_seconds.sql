{% macro pace_to_seconds(column_name) %}

case
    when {{ column_name }} is null
        or {{ column_name }} in ('', '--')
        then null

    else
        (
            split_part({{ column_name }}, ':', 1)::integer * 60 +
            split_part({{ column_name }}, ':', 2)::integer
        )
end

{% endmacro %}