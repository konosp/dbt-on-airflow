{{ config( partition_by='DATE(date_time)' ,  materialized='incremental' ) }}

SELECT DISTINCT
    post_visid_high
    , post_visid_low
    , visit_num
    , visit_start_time_gmt
    , {{ var('url_path') }} 
FROM
    {{ ref('clickstream_clean') }}
WHERE
    post_page_url IS NOT NULL
    AND post_pagename IS NOT NULL
    AND {{ var('url_path') }} = '/'