WITH players AS (
    SELECT 
        player_id,
        player_tag,
        player_country
    FROM silver.dim_players 
),
usd_earnings AS (
    SELECT 
        player_id,
        usd_value,
        event_id
    FROM silver.fct_earnings
),
events AS (
    SELECT 
        event_id,
        event_fullname,
        event_shortname,
        start_year,
        start_month,
        is_big
    FROM silver.dim_events
),
event_earnings AS (
    SELECT 
        usd.player_id,
        e.start_year,
        e.start_month,
        e.is_big,
        usd.usd_value
    FROM usd_earnings AS usd
        LEFT JOIN events AS e
        ON usd.event_id = e.event_id
),
condensed_earnings AS (
    SELECT 
        player_id, 
        start_year, 
        start_month, 
        is_big, 
        SUM(usd_value) AS monthly_total
    FROM event_earnings
    GROUP BY player_id, start_year, start_month, is_big
),
total_earnings AS (
    SELECT
        p.player_tag,
        p.player_country,
        c.start_year,
        c.start_month,
        c.is_big, 
        c.monthly_total
    FROM condensed_earnings as c
        JOIN players as p
        ON c.player_id = p.player_id
    ORDER BY start_year, start_month, is_big
)

SELECT * FROM total_earnings