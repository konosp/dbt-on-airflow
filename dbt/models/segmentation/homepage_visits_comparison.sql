WITH home_page_data AS (
    SELECT 
        concat(
            t1.post_visid_high
            , t1.post_visid_low
            , t1.visit_num
            , t1.visit_start_time_gmt
        ) AS visit_id
    FROM
        {{ ref('clickstream_clean') }} AS t1
    INNER JOIN
        {{ ref('seg_visit_home') }} AS segment
    ON 
        t1.post_visid_high = segment.post_visid_high
        AND t1.post_visid_low = segment.post_visid_low
        AND t1.visit_num = segment.visit_num
        AND t1.visit_start_time_gmt = segment.visit_start_time_gmt
)
, non_home_page_data AS (
    SELECT 
        concat(
            t1.post_visid_high
            , t1.post_visid_low
            , t1.visit_num
            , t1.visit_start_time_gmt
        ) AS visit_id
    FROM
        {{ ref('clickstream_clean') }} AS t1
    LEFT OUTER JOIN
        {{ ref('seg_visit_home') }} AS segment
    ON 
        t1.post_visid_high = segment.post_visid_high
        AND t1.post_visid_low = segment.post_visid_low
        AND t1.visit_num = segment.visit_num
        AND t1.visit_start_time_gmt = segment.visit_start_time_gmt
)

SELECT 
(
    SELECT 
        count(distinct visit_id) as home_page_visits
    FROM
        home_page_data
) as home_page_visits,
(
    SELECT 
        count(distinct visit_id) as non_home_page_visits
    FROM
        non_home_page_data
) as non_home_page_visits