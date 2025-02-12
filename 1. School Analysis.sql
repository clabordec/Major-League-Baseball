-- In each decade, how many schools were there that produced MLB players?
WITH number_of_schools AS (
	SELECT FLOOR(yearID / 10) * 10 AS decade,
		   schoolID
	FROM schools s
)
SELECT decade, COUNT(DISTINCT schoolID) AS num_schools
FROM number_of_schools
GROUP BY decade
ORDER BY decade;


-- What are the names of the top 5 schools that produced the most players?
SELECT name_full, COUNT(DISTINCT p.playerID) AS num_players
FROM school_details sd
JOIN schools s
ON sd.schoolID = s.schoolID
JOIN players p
ON s.playerID = p.playerID
GROUP BY name_full
ORDER BY num_players DESC
LIMIT 5;


-- For each decade, what were the names of the top 3 schools that produced the most players?
SELECT decade, school_names, num_players
FROM (
	WITH top_three_schools AS (
		SELECT FLOOR(s.yearID / 10) * 10 AS decade,
			   name_full AS school_names,
			   p.playerID
		FROM school_details sd
		JOIN schools s
		ON sd.schoolID = s.schoolID
		JOIN players p
		ON s.playerID = p.playerID
	)
	SELECT decade, school_names, COUNT(DISTINCT playerID) AS num_players,
		   ROW_NUMBER() OVER(PARTITION BY decade ORDER BY COUNT(DISTINCT playerID) DESC) AS rnk
	FROM top_three_schools
	GROUP BY decade, school_names
) top_3_schools
WHERE rnk <= 3
ORDER BY decade desc, rnk;
