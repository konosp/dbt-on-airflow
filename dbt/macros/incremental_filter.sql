{% macro incremental_filter() %}

    {% if is_incremental() %}

    -- this filter will only be applied on an incremental run
        {{ log("This is an incremental run", info=True) }}

        {% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
            -- AND date_time > (select max(date_time) from {{ this }})
            AND date_time >= '{{ var("start_date") }}' AND date_time < '{{ var("end_date") }}'
        {% endif %}

    {% endif %}

{% endmacro %}