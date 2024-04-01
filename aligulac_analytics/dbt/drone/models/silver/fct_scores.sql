WITH player_a AS (
    SELECT
        match_id,
        player_a_id AS player_id,
        race_a AS race,
        score_a AS score
    FROM bronze.matches
),
player_b AS (
        SELECT
        match_id,
        player_b_id AS player_id,
        race_b AS race,
        score_b AS score
    FROM bronze.matches
),
player_ab AS (
    SELECT * FROM player_a
    UNION ALL
    SELECT * FROM player_b
)

SELECT *
FROM player_ab