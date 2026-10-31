-- IPL Analytics: SQL queries (SQLite)

-- 1. Har season ka champion
SELECT season, winner AS champion, date
FROM matches
WHERE match_type = 'Final'
ORDER BY season;

-- 2. Sabse zyada IPL titles
SELECT winner AS team, COUNT(*) AS titles
FROM matches
WHERE match_type = 'Final'
GROUP BY winner
ORDER BY titles DESC;

-- 3. Sabse zyada Player of the Match
SELECT player_of_match AS player, COUNT(*) AS awards
FROM matches
WHERE player_of_match != 'None'
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;

-- 4. Har season ka top run-scorer (window function + CTE)
WITH season_runs AS (
    SELECT m.season, d.batter, SUM(d.batsman_runs) AS runs
    FROM deliveries d
    JOIN matches m ON d.match_id = m.id
    GROUP BY m.season, d.batter
),
ranked AS (
    SELECT season, batter, runs,
           RANK() OVER (PARTITION BY season ORDER BY runs DESC) AS rnk
    FROM season_runs
)
SELECT season, batter, runs
FROM ranked
WHERE rnk = 1
ORDER BY season;
