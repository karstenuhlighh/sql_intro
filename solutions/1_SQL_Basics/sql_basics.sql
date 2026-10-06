SET SCHEMA 'introduction'; 

-- Exercise 1
-- WHERE

-- Explore all tables       
SELECT * FROM record;
SELECT * FROM gender;
SELECT * FROM age_bucket;

-- Get all cases for women
SELECT * 
FROM record 
WHERE id_gender = 2;

-- Get all cases for men between 20 AND 50 (age_bucket)
SELECT 
	* 
FROM 
	record 
WHERE 
	id_gender = 1 
	AND id_age_bucket BETWEEN 4 AND 6;

-- Exercise 2
-- JOINING TABLES

-- Get all cases for women (including gender names)
SELECT 
	r.id, 
	r.record_date, 
	g.name AS gender_name,  
	r.cases
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
WHERE 
	r.id_gender = 2 ;

-- Get all cases for women (including gender names AND age_bucket names)
SELECT 
	r.id, 
	r.record_date, 
	g.name AS gender_name, 
	ab."range" AS age_bucket_name,  
	r.cases 
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN 
	age_bucket ab ON r.id_age_bucket = ab.id 
WHERE 
	r.id_gender = 2;

-- Get all cases for men between 20 AND 50 including gender names AND age_bucket names
SELECT 
	r.id, 
	r.record_date, 
	g.name AS gender_name, 
	ab."range" AS age_bucket_name,
	r.cases 
FROM 
	record r 
Inner JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN
	age_bucket ab ON r.id_age_bucket = ab.id 
WHERE 
	r.id_gender = 1 
	AND r.id_age_bucket between 4 AND 6;

-- Exercise 3
-- Order BY

-- Get all cases for women ORDER them BY age_GROUPs ASCending
SELECT 
	r.id, 
	r.record_date, 
	g.name AS gender_name, 
	ab."range" AS age_bucket_name,
	r.cases 
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN 
	age_bucket ab ON r.id_age_bucket = ab.id 
WHERE 
	r.id_gender = 2 
ORDER BY 
	r.id_age_bucket ASC 

-- ... AND also BY date (extra)
SELECT 
	r.id, 
	r.record_date, 
	g.name AS gender_name, 
	ab."range" AS age_bucket_name,  
	r.cases FROM record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN 
	age_bucket ab ON r.id_age_bucket = ab.id 
WHERE 
	r.id_gender = 2 
ORDER BY 
	r.record_date ASC, 
	r.id_age_bucket ASC;

-- all cases for men between 20 AND 50, ORDER them BY record_date DESCending
SELECT 
	r.id,
	r.record_date,
	g.name AS gender_name,
	ab."range" AS age_bucket_name,
	r.cases 
FROM 
	record r 
Inner JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN 
	age_bucket ab ON r.id_age_bucket = ab.id 
WHERE 
	r.id_gender = 1 AND r.id_age_bucket between 4 AND 6
ORDER BY 
	r.record_date DESC;


-- Exercise 4
-- MATHEMATICAL FUNCTIONS

-- get average number of cases for women
SELECT 
	avg(r.cases) AS average_number_of_cases,
	g.name AS gender 
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
WHERE 
	g.name='female'
GROUP BY 
	g.name;

-- get maximum number of cases for men
SELECT 
	max(r.cases) AS average_number_of_cases,
	g.name AS gender 
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
WHERE 
	g.name='male'
GROUP BY
	g.name
ORDER BY 
	1 DESC;

-- Exercise 5
-- GROUP BY

-- get sum of cases per gender per age GROUP
SELECT 
	sum(r.cases) AS total_number_of_cases,
	g.name AS gender,
	ab."range" AS age_group 
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN 
	age_bucket ab ON ab.id = r.id_age_bucket
GROUP BY 
	g.name,
	ab.range
ORDER BY 
	3 ASC,
	2 DESC;

-- AND a bit nicer looking
SELECT 
	g.name AS gender,
	ab."range" AS age_group,
	round(avg(r.cases),0) AS average_number_of_cases
FROM 
	record r 
INNER JOIN 
	gender g ON g.id = r.id_gender
INNER JOIN 
	age_bucket ab ON ab.id = r.id_age_bucket
GROUP BY 
	g.name,
	ab.range
ORDER BY
	2 ASC,
	1 DESC;

-- Exercise 6
-- HAVING
 
-- Get all the dates with more then 80,000 combined cases
SELECT 
	r.record_date,
	sum(r.cases) AS sum_of_cases
FROM 
	record r
GROUP BY 
	r.record_date 
HAVING 
	sum(r.cases)>80000
ORDER BY 
	2 DESC;
