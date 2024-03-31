SELECT 
    id AS event_id,
    fullname AS event_fullname,
    name AS event_shortname,
    category AS event_category,
    type AS event_type,
    parent_id AS parent_event_id,
    closed AS is_completed,
    big AS is_big,
    earliest AS event_earliest,
    latest AS event_latest,
    idx
FROM {{ source('aligulac', 'events')}}
ORDER BY idx, event_id