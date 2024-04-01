SELECT 
    event_id,
    event_fullname,
    event_shortname,
    event_category,
    event_earliest AS event_start,
    EXTRACT(year FROM event_earliest) AS start_year,
    EXTRACT(month FROM event_earliest) AS start_month,
    event_type,
    is_big
FROM bronze.events
ORDER BY idx