WITH matches AS (
    SELECT 
        match_id,
        match_year,
        match_month,
        is_offline
    FROM silver.dim_matches
    WHERE match_year >= 2021
),
scores AS (
    SELECT *
    FROM silver.fct_scores
),
players AS (
    SELECT *
    FROM silver.dim_players
),
match_scores AS (
    SELECT 
        s.match_id,
        m.match_year,
        m.match_month,
        m.is_offline,
        s.player_id,
        s.race,
        s.score
    FROM scores AS s
        JOIN matches AS m
        ON s.match_id = m.match_id
),
player_match_scores AS (
    SELECT 
        ms.match_id,
        ms.match_year,
        ms.match_month,
        ms.player_id,
        p.player_tag,
        p.player_country,
        ms.race,
        ms.score,
        ms.is_offline
    FROM match_scores AS ms
        LEFT JOIN players AS p
        ON ms.player_id = p.player_id
),
flipside AS (
    SELECT 
        sc.match_id,
        sc.match_year,
        sc.match_month,
        sc.player_id AS player_primary,
        sc.player_tag AS player_primary_tag,
        sc.player_country AS player_primary_country,
        sc.race AS player_primary_race,
        sc.score AS player_primary_score,
        s.player_id AS player_secondary,
        p.player_tag AS player_secondary_tag,
        p.player_country AS player_secondary_country,
        s.race AS player_secondary_race,
        s.score AS player_secondary_score,
        sc.is_offline
    FROM player_match_scores AS sc
        LEFT JOIN scores AS s
            ON sc.match_id = s.match_id 
            AND sc.player_id != s.player_id
        LEFT JOIN players AS p
            ON s.player_id = p.player_id
),
add_ratio AS (
    SELECT match_id, player_primary, player_secondary,
        player_primary_score - player_secondary_score AS ratio,
    FROM flipside
),
add_calculations AS (
    SELECT 
        match_id, player_primary, player_secondary, ratio,    
        CASE
            WHEN ratio > 0 THEN 'W'
            WHEN ratio = 0 THEN 'D'
            WHEN ratio < 0 THEN 'L'
        END AS match_result
    FROM add_ratio
),
merged_calculations AS (
    SELECT 
        f.match_id,
        f.match_year,
        f.match_month,
        f.player_primary,
        f.player_primary_tag,
        f.player_primary_country,
        f.player_primary_race,
        f.player_primary_score,
        f.player_secondary,
        f.player_secondary_tag,
        f.player_secondary_country,
        f.player_secondary_race,
        f.player_secondary_score,
        f.is_offline,
        c.ratio,
        c.match_result

    FROM flipside AS f
        LEFT JOIN add_calculations AS c
        ON f.match_id = c.match_id
        AND f.player_primary = c.player_primary
        AND f.player_secondary = c.player_secondary
    ORDER BY match_year, match_month, match_id
)

SELECT * FROM merged_calculations
