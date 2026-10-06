set schema 'petsowners';
SELECT * FROM owners;

-- 1. How many pets, how many owners?
SELECT COUNT(*) FROM pets p;
SELECT COUNT(*) FROM owners o;

-- 2. what are the most AND least common petnames? 
-- most common
SELECT name,
 COUNT(petid)
FROM pets p 
GROUP BY  "name" 
ORDER BY COUNT(petid) DESC 
LIMIT 1;
-- least common
SELECT name,
 COUNT(petid)
FROM pets p 
GROUP BY  "name" 
ORDER BY COUNT(petid) 
LIMIT 1;
-- least common, more general using subquery (replace MIN with MAX for most common)
SELECT name, COUNT(petid) AS name_count
FROM pets
GROUP BY name
HAVING COUNT(petid) = (
    SELECT MIN(name_count)
    FROM (
        SELECT COUNT(petid) AS name_count
        FROM pets
        GROUP BY name
    ) AS subquery
);


-- 3. what kind of pets do we have?
SELECT DISTINCT kind FROM pets;

-- 4. what is the gender balance across pets AND species?
SELECT gender, COUNT(gender) FROM pets GROUP BY gender;
SELECT kind, gender, COUNT(gender) FROM pets GROUP BY gender, kind ORDER BY kind; 

-- 5. what is the average age of the pets?
SELECT avg(age) as avg_age FROM pets;

-- 6. how many owners have more than ONe pet?
select COUNT(t.ownerid) from (SELECT ownerid, COUNT(petid) as COUNT FROM pets p GROUP BY ownerid HAVING COUNT(petid) > 1) t;
	
-- 7. do the owners that have more than ONe pet have the same kind of pet.
SELECT ownerid, array_agg(distinct kind) as COUNT FROM pets p GROUP BY ownerid HAVING COUNT(petid) > 1 ;
-- answer: no. stacy has a cat AND two dogs

-- 8. do owners name their pets like owners?
select * from (select o."name" owner_name, p."name" pet_name from pets p 
INNER JOIN owners o ON p.ownerid = o.ownerid) t WHERE t.owner_name = t.pet_name;
-- answer: yes, bruce

-- 9. Extract the informatiON of petnames AND owners side-BY-side!
SELECT o.name as owner_name, p.name as pet_name, p.ownerid FROM pets p 
	full JOIN owners o ON o.ownerid = p.ownerid ORDER BY p.ownerid ; 

-- 10. what are the cities with the largest amount of pets?
SELECT o.city, count(*) num_pets
FROM owners o 
FULL JOIN pets p 
ON o.ownerid = p.ownerid 
GROUP BY o.city 
ORDER BY num_pets DESC;

-- Let's look at some of the procedures those pets had.

-- 1. Match procedure history to procedure details!
SELECT * FROM procedurehistory p 
LEFT JOIN proceduredetails p2 
ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode ;

-- 2. What pets did't get rabies vaccination?
SELECT t.petid from (
SELECT * FROM procedurehistory p 
LEFT JOIN proceduredetails p2 
ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode) t
GROUP BY t.petid
HAVING 'Rabies' != ALL(array_agg(t.description)) ;

-- alternative solution
/*SELECT distinct p.petid 
FROM procedurehistory p
LEFT JOIN (
SELECT DISTINCT t.petid FROM (
	SELECT * FROM procedurehistory p 
	LEFT JOIN proceduredetails p2 
	ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode
	) t WHERE t.description = 'Rabies'
) t2
ON p.petid = t2.petid
WHERE t2.petid is null;*/

-- 3. what is the most prevalent type of surgery?
SELECT t.description, count(t.description) 
FROM (
SELECT p.proceduretype, p2.description FROM procedurehistory p 
LEFT JOIN proceduredetails p2 
ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode
WHERE p2.proceduretype = 'GENERAL SURGERIES'
) t GROUP BY t.description 
ORDER BY COUNT(t.description) DESC LIMIT 1;


-- 4. how much did owners spend ON their pets?
SELECT t2.ownerid, sum(t2.price) spending
FROM (
SELECT p0.ownerid, p0.petid, t.price 
FROM pets p0
INNER JOIN (
SELECT p.petid, p2.price FROM procedurehistory p 
LEFT JOIN proceduredetails p2 
ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode
) t
ON t.petid = p0.petid
) t2
GROUP BY t2.ownerid
ORDER BY spending DESC ;

-- alternative answer:
-- all petids with prices in p history
/*SELECT p.petid, p2.price FROM procedurehistory p 
LEFT JOIN proceduredetails p2 
ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode;

-- all ownerids, petids with prices
SELECT p0.ownerid, p0.petid, t.price 
FROM pets p0
INNER JOIN (
SELECT p.petid, p2.price FROM procedurehistory p 
LEFT JOIN proceduredetails p2 
ON p.proceduretype = p2.proceduretype AND p.proceduresubcode = p2.proceduresubcode
) t
ON t.petid = p0.petid ;*/