SELECT
    step1.post_visid_high
    , step1.post_visid_low 
    , step1.visit_num
    , step1.visit_start_time_gmt
    , step1.{{ var('url_path') }} AS step1_url
    , step2.{{ var('url_path') }} AS step2_url
FROM
    {{ ref('seg_visit_home') }} AS step1
INNER JOIN
    {{ ref('seg_visit_order_complete') }} AS step2
ON
    step1.post_visid_high = step2.post_visid_high
    AND step1.post_visid_low = step2.post_visid_low
    AND step1.visit_num = step2.visit_num
    AND step1.visit_start_time_gmt = step2.visit_start_time_gmt