SELECT
    event_id,
    player_id,
    earnings.earnings AS usd_value,
    currency,
    placement
FROM {{ source('aligulac', 'earnings')}}
ORDER BY event_id, placement