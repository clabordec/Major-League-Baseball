-- Return the top 20% of teams in terms of average annual spending
WITH team_total_spend AS (
	SELECT yearID, teamID, SUM(salary) AS total_spend
	FROM salaries
	GROUP BY yearID, teamID
),
team_avg_spend AS (
	SELECT teamID, AVG(total_spend) AS avg_spend
	FROM team_total_spend
	GROUP BY teamID
),
team_top_20 AS (
	SELECT teamID, ROUND(avg_spend / 1000000, 1) AS avg_spend_millions,
	       NTILE(5) OVER(ORDER BY avg_spend DESC) AS top_20_pct
	FROM team_avg_spend
)
SELECT teamID, avg_spend_millions
FROM team_top_20 
WHERE top_20_pct = 1;


-- For each team, show the cumulative sum of spending over the years
WITH cumulative_sum_cte AS (
	SELECT yearID, teamID, SUM(salary) total_spending
	FROM salaries
	GROUP BY yearID, teamID
	ORDER BY yearID, total_spending DESC
)
SELECT teamID, yearID, ROUND(SUM(total_spending / 1000000) OVER(PARTITION BY teamID ORDER BY yearID), 1) AS cumulative_sum
FROM cumulative_sum_cte;


-- Return the first year each team's cumulative spending surpassed 1 billion
WITH total_spend_cte AS (
	SELECT yearID, teamID, SUM(salary) total_spending
	FROM salaries
	GROUP BY yearID, teamID
),
cumulative_sum_cte AS (
	SELECT teamID, yearID, SUM(total_spending) OVER(PARTITION BY teamID ORDER BY yearID) AS cumulative_sum
	FROM total_spend_cte
),
first_years AS (
	SELECT teamID, yearID, cumulative_sum,
		   ROW_NUMBER() OVER(PARTITION BY teamID ORDER BY cumulative_sum) AS rnk
	FROM cumulative_sum_cte 
	WHERE cumulative_sum > 1000000000
)
SELECT teamID, yearID, ROUND(cumulative_sum / 1000000000, 2) AS cumulative_sum_billions
FROM first_years
WHERE rnk = 1;