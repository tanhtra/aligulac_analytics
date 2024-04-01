WITH matches AS (
    SELECT
        match_year,
        match_month,
        match_expansion,
        is_offline,
        event_id
    FROM silver.dim_matches
),
match_counts AS (
    SELECT 
        match_year,
        match_month,
        match_expansion,
        is_offline, 
        COUNT(*) AS match_count
    FROM matches
    GROUP BY match_year, match_month, match_expansion, is_offline
    ORDER BY match_year, match_month
)

SELECT * FROM match_counts