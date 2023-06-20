USE Project2;
SELECT * FROM hr_dataset;

-- Analyze the data
-- 1. How many people of each gender are in the data?
SELECT gender, count(*) AS total_data
FROM hr_dataset
WHERE termdate IS NULL
GROUP BY gender
ORDER BY count(*) DESC;

-- 2. How many people of each race/ethnic type are in the data?
SELECT race AS Race_or_Ethnic, count(*) AS total_data
FROM hr_dataset
WHERE termdate IS NULL
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is age distribution of employees on data?
SELECT age_group, gender, count(*) AS total
FROM (
    SELECT 
        CASE
            WHEN age >= 21 AND age <= 24 THEN '21-24'
            WHEN age >= 25 AND age <= 34 THEN '25-34'
            WHEN age >= 35 AND age <= 44 THEN '35-44'
            WHEN age >= 45 AND age <= 54 THEN '45-54'
            ELSE '55+'
        END AS age_group, gender
    FROM hr_dataset
    WHERE termdate IS NULL
) AS subquery
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters vs remote locations?
SELECT location, count(*) AS total
FROM hr_dataset
WHERE termdate IS NULL
GROUP BY location

-- 5. What is the average length of service for employees who have been terminated?
SELECT round(avg(datediff(day, hire_date, termdate)) / 365, 0) AS average_length
FROM hr_dataset
WHERE termdate <= getdate() AND termdate IS NOT NULL

-- 6. How does gender distribution vary across departments and job titles?
SELECT department, gender, count(*) as total
FROM hr_dataset
WHERE termdate IS NULL
GROUP BY department, gender
ORDER BY department, gender

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS total_emp
FROM hr_dataset
WHERE termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle ASC

-- 8. What department has the highest turnover rate?
SELECT department, total_count, terminated_count, round(cast(terminated_count AS float)/cast(total_count AS float), 2) AS termination_rate
FROM (
	SELECT department, count(*) AS total_count,
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= getdate() THEN 1 ELSE 0 END) AS terminated_count
	FROM hr_dataset
	GROUP BY department
) AS subquery
ORDER BY termination_rate DESC

-- 9. What is distribution of employees across locations by state?
SELECT location_state, count(*) AS total
FROM hr_dataset
WHERE termdate IS NULL
GROUP BY location_state
ORDER BY count(*) DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year, hires, terminations, hires-terminations AS net_change, round(cast((hires - terminations) AS float)/cast(hires AS Float) * 100, 2) AS net_changepercent
FROM (
	SELECT YEAR(hire_date) AS year, count(*) AS hires,
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= getdate() THEN 1 ELSE 0 END) AS terminations
	FROM hr_dataset
	GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, round(avg(datediff(day, hire_date, termdate)/365), 0) AS average_tenure
FROM hr_dataset
WHERE termdate IS NOT NULL AND termdate <= getdate()
GROUP BY department
