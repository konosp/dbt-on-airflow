WITH home_page_data AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY count(t1.post_page_url) DESC) as order_d
        , t1.post_page_url
        , t1.{{ var('url_path') }}
        , count(t1.post_page_url) as page_views
    FROM
        {{ ref('clickstream_clean') }} AS t1
    INNER JOIN
        {{ ref('seg_visit_home') }} AS segment
    ON 
        t1.post_visid_high = segment.post_visid_high
        AND t1.post_visid_low = segment.post_visid_low
        AND t1.visit_num = segment.visit_num
        AND t1.visit_start_time_gmt = segment.visit_start_time_gmt
    WHERE
        post_page_url IS NOT NULL
        AND post_pagename IS NOT NULL
    GROUP BY
        t1.post_page_url
        , t1.{{ var('url_path') }}
    ORDER BY
        page_views desc
    LIMIT 10

)
, non_home_page_data AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY count(t1.post_page_url) DESC) as order_d
        , t1.post_page_url
        , t1.{{ var('url_path') }}
        , count(t1.post_page_url) as page_views
    FROM
        {{ ref('clickstream_clean') }} AS t1
    LEFT OUTER JOIN
        {{ ref('seg_visit_home') }} AS segment
    ON 
        t1.post_visid_high = segment.post_visid_high
        AND t1.post_visid_low = segment.post_visid_low
        AND t1.visit_num = segment.visit_num
        AND t1.visit_start_time_gmt = segment.visit_start_time_gmt
    WHERE
        post_page_url IS NOT NULL
        AND post_pagename IS NOT NULL
        AND (
            segment.post_visid_high IS NULL
            OR segment.post_visid_low IS NULL
            OR segment.visit_num IS NULL
            OR segment.visit_start_time_gmt IS NULL
        )
    GROUP BY
        t1.post_page_url
        , t1.{{ var('url_path') }}
    ORDER BY
        page_views desc
    LIMIT 10
)

SELECT 
    home_page_data.order_d
    , home_page_data.{{ var('url_path') }} as pages_1
    , home_page_data.page_views AS page_views_1
    , non_home_page_data.{{ var('url_path') }} as pages_2
    , non_home_page_data.page_views AS page_views_2
FROM
    home_page_data
INNER JOIN
    non_home_page_data
ON 
    home_page_data.order_d = non_home_page_data.order_d
ORDER BY
    home_page_data.order_d ASC