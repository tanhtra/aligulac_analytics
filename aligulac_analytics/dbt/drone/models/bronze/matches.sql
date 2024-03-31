SELECT 
    id AS match_id,
    date AS match_date,
    pla_id AS player_a_id,
    plb_id AS player_b_id,
    sca AS score_a,
    scb AS score_b,
    event AS match_event_type,
    eventobj_id AS event_id,
    game AS match_expansion,
    offline AS is_offline
FROM {{ source('aligulac', 'matches')}}
ORDER BY date, id, eventobj_id