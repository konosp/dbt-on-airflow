{{ config( partition_by='DATE(date_time)' , materialized='incremental') }}

SELECT 
    *
FROM 
    {{ ref('clickstream_full') }} as t1
WHERE 
    exclude_hit != '0'
    OR hit_source IN ('5','7','8','9')

    {{ incremental_filter() }}