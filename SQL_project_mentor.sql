-- SQL Mini project 10/10
-- SQL Mentor User Performance

DROP TABLE IF EXISTS user_submissions;
CREATE TABLE user_submissions(
	id			INT	PRIMARY KEY,
	user_id		BIGINT,	
	question_id	INT,	
	points		INT,	
	submitted_at TIMESTAMP WITH TIME ZONE,	
	username	VARCHAR(30)
);
--DATABASE EXPLORATION

SELECT * FROM user_submissions;
SELECT DISTINCT(id) FROM user_submissions ORDER BY 1;
SELECT DISTINCT(user_id) FROM user_submissions ORDER BY 1;
SELECT DISTINCT(question_id) FROM user_submissions ORDER BY 1;
SELECT DISTINCT(points) FROM user_submissions ORDER BY 1;
SELECT DISTINCT(submitted_at) FROM user_submissions ORDER BY 1;
SELECT DISTINCT(username) FROM user_submissions ORDER BY 1;

SELECT
	user_id,
	username,
	COUNT(question_id) AS no_of_question_done
FROM user_submissions
GROUP BY 1,2;

-- 1. List All Distinct Users and Their Stats
	-- Description: Return the user name, total submissions, and total points earned by each user.
	-- Expected Output: A list of users with their submission count and total points.
SELECT
	username,
	COUNT(submitted_at) AS total_submssion,
	SUM(points) AS total_points
FROM user_submissions
GROUP BY 1
ORDER BY 2,3;

-- 2. Calculate the Daily Average Points for Each User
	-- Description: For each day, calculate the average points earned by each user.
	-- Expected Output: A report showing the average points per user for each day.
SELECT
	EXTRACT(DAY FROM submitted_at) AS days,
	username,
	AVG(points) AS avg_point
FROM user_submissions
GROUP BY 1,2;

-- 3. Find the Top 3 Users with the Most Correct Submissions for Each Day
	-- Description: Identify the top 3 users with the most correct submissions for each day.
	-- Expected Output: A list of users and their correct submissions, ranked daily.

SELECT
	*
FROM
(SELECT
	EXTRACT(DAY FROM submitted_at) AS days,
	username,
	COUNT(points) AS points,
	RANK() OVER(PARTITION BY EXTRACT(DAY FROM submitted_at) ORDER BY COUNT(points) DESC) AS ranking
FROM user_submissions
WHERE points>0
GROUP BY 1,2)
WHERE ranking BETWEEN 1 AND 3;

-- 4. Find the Top 5 Users with the Highest Number of Incorrect Submissions
	-- Description: Identify the top 5 users with the highest number of incorrect submissions.
	-- Expected Output: A list of users with the count of incorrect submissions.
SELECT
	username,
	COUNT(points) AS no_of_attempt
FROM user_submissions
WHERE points<0
GROUP BY 1
ORDER BY no_of_attempt DESC
LIMIT 5;

-- 5. Find the Top 10 Performers for Each Week
	-- Description: Identify the top 10 users with the highest total points earned each week.
	-- Expected Output: A report showing the top 10 users ranked by total points per week.
SELECT
	*
FROM(SELECT
	EXTRACT(WEEK FROM submitted_at) AS weeks,
	username,
	SUM(points) AS total_points,
	RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) AS ranking
FROM user_submissions
GROUP BY 1,2)
WHERE ranking BETWEEN 1 AND 10;

-- END OF PROJECT


	














