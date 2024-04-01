SELECT 
    match_id,
    event_id,
    match_date,
    EXTRACT(year FROM match_date) AS match_year,
    EXTRACT(month FROM match_date) AS match_month,
    match_event_type,
    match_expansion,
    is_offline
FROM bronze.matches