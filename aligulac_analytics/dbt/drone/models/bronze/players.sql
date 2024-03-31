SELECT
    id AS player_id,
    tag AS player_tag,
    country AS player_country,
    race AS player_race
FROM {{ source('aligulac', 'players') }}
ORDER BY id