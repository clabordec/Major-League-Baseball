/*
	For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years).
    Sort from longest career to shortest career.
*/
SELECT nameGiven,
       TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), debut) AS starting_age,
       TIMESTAMPDIFF(YEAR, CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), finalGame) AS ending_age,
       TIMESTAMPDIFF(YEAR, debut, finalGame) AS career_length
FROM players
ORDER BY career_length DESC;

-- View all records within the players table
SELECT * FROM players;


-- What team did each player played on for their starting and ending years?
SELECT nameGiven,
       s.yearID AS starting_year,
       s.teamID AS starting_team,
       e.yearID AS ending_year,
       e.teamID AS ending_team
FROM players p
JOIN salaries s
ON p.playerID = s.playerID
AND YEAR(p.debut) = s.yearID
JOIN salaries e
ON p.playerID = e.playerID
AND YEAR(p.finalGame) = e.yearID;

-- View all records within the players table
SELECT * FROM players;
-- View all records within the salaries table
SELECT * FROM salaries;


-- How many players started and ended on the same team and also played for over a decade?
SELECT nameGiven,
       s.yearID AS starting_year,
       s.teamID AS starting_team,
       e.yearID AS ending_year,
       e.teamID AS ending_team
FROM players p
JOIN salaries s
ON p.playerID = s.playerID
AND YEAR(p.debut) = s.yearID
JOIN salaries e
ON p.playerID = e.playerID
AND YEAR(p.finalGame) = e.yearID
WHERE s.teamID = e.teamID
AND e.yearID - s.yearID > 10;
