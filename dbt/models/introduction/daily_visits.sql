SELECT 
    DATE(date_time) AS dt
    , count(distinct concat(post_visid_high, post_visid_low, visit_num)) AS visits
FROM 
    {{ ref('clickstream_clean') }}
WHERE 
    post_page_url IS NOT NULL
    AND post_pagename IS NOT NULL
GROUP BY 
    dt
ORDER BY
    dt ASC