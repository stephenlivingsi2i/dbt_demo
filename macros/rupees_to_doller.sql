{% macro rupees_to_dollars(column_name, scale=2) %}
    ({{ column_name }} / 74.39)::numeric(16, {{ scale }})
{% endmacro %}
