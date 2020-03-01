SELECT 
    DATE(date_time) AS dt
    , count(post_page_url) AS page_views
FROM 
    {{ ref('clickstream_clean') }}
WHERE 
    post_page_url IS NOT NULL
    AND post_pagename IS NOT NULL
GROUP BY 
    dt
ORDER BY
    dt ASC