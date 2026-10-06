# At the Vet

You are assisting a vet clinic in making sense of their data. Their data is in two tables. And they need you tu perform the following analytics:

> Alle Lösungen nutzen den Schema-Präfix `petsowners.` und laufen deshalb unabhängig vom eingestellten Standard-Schema. Ergebnisse geprüft gegen die Kurs-Datenbank am 06.10.2026.

1. How many pets, how many owners? Hint: use [COUNT()](https://www.postgresql.org/docs/8.2/functions-aggregate.html)

```sql
SELECT COUNT(*) AS number_of_pets FROM petsowners.pets;
SELECT COUNT(*) AS number_of_owners FROM petsowners.owners;
```
Ergebnis: **100 Haustiere, 89 Besitzer.**

2. What are the most and least common pet names? Hint: use [ORDER BY](https://www.postgresql.org/docs/8.1/queries-order.html)

```sql
-- häufigster Name
SELECT name, COUNT(*) AS count
FROM petsowners.pets
GROUP BY name
ORDER BY count DESC
LIMIT 1;

-- seltenster Name
SELECT name, COUNT(*) AS count
FROM petsowners.pets
GROUP BY name
ORDER BY count ASC
LIMIT 1;
```
Ergebnis: Häufigster Name ist **Biscuit (8x)**, danach Cookie (6x). 34 Namen kommen nur einmal vor. Welcher davon beim seltensten oben steht, ist ohne weitere Sortierung zufällig.

3. What kind of pets do we have? Hint: use [DISTINCT](https://www.postgresql.org/docs/9.5/sql-select.html)

```sql
SELECT DISTINCT kind
FROM petsowners.pets;
```
Ergebnis: **Cat, Dog, Parrot.**

4. What is the gender balance across pets and species? Hint: use [GROUP BY](https://www.postgresql.org/docs/9.4/tutorial-agg.html)

```sql
-- über alle Haustiere
SELECT gender, COUNT(*) AS count
FROM petsowners.pets
GROUP BY gender;

-- je Tierart
SELECT kind, gender, COUNT(*) AS count
FROM petsowners.pets
GROUP BY kind, gender
ORDER BY kind, gender;
```
Ergebnis: 59 männlich, 41 weiblich. Je Art: Cat 19 m / 12 w, Dog 35 m / 22 w, Parrot 5 m / 7 w.

5. What is the average age of the pets? Hint: use [AVG()](https://www.postgresql.org/docs/9.4/tutorial-agg.html)

```sql
SELECT AVG(age) AS average_age
FROM petsowners.pets;
```
Ergebnis: **6,93 Jahre.**

6. How many owners have more than one pet? Hint: use [GROUP BY HAVING](https://www.postgresql.org/docs/9.4/tutorial-agg.html)

```sql
-- Liste der Besitzer mit mehr als einem Haustier
SELECT ownerid, COUNT(*) AS number_of_pets
FROM petsowners.pets
GROUP BY ownerid
HAVING COUNT(*) > 1;

-- nur die Anzahl
SELECT COUNT(*) AS owners_with_more_than_one_pet
FROM (
    SELECT ownerid
    FROM petsowners.pets
    GROUP BY ownerid
    HAVING COUNT(*) > 1
) AS multi_pet_owners;
```
Ergebnis: **8 Besitzer.**

7. Do the owners that have more than one pet have the same kind of pet. Hint: use [ARRAY_AGG](https://www.postgresqltutorial.com/postgresql-aggregate-functions/postgresql-array_agg/)

```sql
SELECT ARRAY_AGG(kind) AS pet_list, ownerid
FROM petsowners.pets
GROUP BY ownerid
HAVING COUNT(*) > 1;
```
Ergebnis: Nicht immer. 4 der 8 Besitzer haben nur eine Art (z. B. 5508: drei Katzen), 4 haben gemischte Arten (z. B. 8133: Hund, Hund, Katze).

8. Do owners name their pets like owners? Hint: use [INNER JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html)

```sql
SELECT p.name AS pet_name, o.name AS owner_name, o.surname, p.kind
FROM petsowners.pets AS p
INNER JOIN petsowners.owners AS o
    ON p.ownerid = o.ownerid
   AND p.name = o.name;
```
Ergebnis: Genau einer. **Bruce Dunne** hat einen Hund namens **Bruce**.

9. Extract the information of pet names and owners side-by-side! Hint: use [FULL JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html)

```sql
SELECT p.name AS pet_name, p.kind, o.name AS owner_name, o.surname
FROM petsowners.pets AS p
FULL JOIN petsowners.owners AS o
    ON p.ownerid = o.ownerid;
```
Ergebnis: 100 Zeilen. Jedes Haustier hat einen Besitzer und jeder Besitzer mindestens ein Haustier, deshalb gibt es hier keine Zeilen mit NULL.

10. What are the cities with the largest amount (top 3) of pets? Hint: use [INNER JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html)

```sql
SELECT o.city, COUNT(*) AS number_of_pets
FROM petsowners.pets AS p
INNER JOIN petsowners.owners AS o
    ON p.ownerid = o.ownerid
GROUP BY o.city
ORDER BY number_of_pets DESC
LIMIT 3;
```
Ergebnis: **Southfield (18), Grand Rapids (10), Detroit (8).**

### Let's look at some of the procedures those pets had.

1. Combine the tables with the procedure history and the procedure details. You might have to join tables based on more than one column...

```sql
SELECT *
FROM petsowners.procedurehistory AS h
LEFT JOIN petsowners.proceduredetails AS d
    ON h.proceduretype = d.proceduretype
   AND h.proceduresubcode = d.proceduresubcode;
```
Ergebnis: 2.284 Zeilen. Der Schlüssel besteht aus **zwei Spalten** (Typ + Subcode), deshalb zwei Bedingungen im `ON`. Alle Behandlungen finden ihre Details.

2. What pets did't get rabies vaccination? Hint: use [LEFT JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html), use [ARRAY_AGG()](https://www.postgresql.org/docs/8.2/functions-aggregate.html) and use [ALL()](https://www.postgresql.org/docs/9.1/functions-comparisons.html)

```sql
SELECT h.petid
FROM petsowners.procedurehistory AS h
LEFT JOIN petsowners.proceduredetails AS d
    ON h.proceduretype = d.proceduretype
   AND h.proceduresubcode = d.proceduresubcode
GROUP BY h.petid
HAVING 'Rabies' <> ALL (ARRAY_AGG(d.description))
ORDER BY h.petid;
```
Ergebnis: 891 Haustiere (A0-1431, A0-1450, A0-1972, ...). `ARRAY_AGG` sammelt pro Tier alle Behandlungen, `<> ALL` prüft, dass "Rabies" in keiner davon vorkommt.
Hinweis: Die Behandlungshistorie enthält viel mehr Tiere als die Tabelle `pets`. 66 der 100 Tiere aus `pets` haben überhaupt keine Behandlung und tauchen hier deshalb nicht auf.

3. What is the most prevalent type of surgery?

```sql
SELECT d.description, COUNT(*) AS count
FROM petsowners.procedurehistory AS h
INNER JOIN petsowners.proceduredetails AS d
    ON h.proceduretype = d.proceduretype
   AND h.proceduresubcode = d.proceduresubcode
WHERE h.proceduretype = 'GENERAL SURGERIES'
GROUP BY d.description
ORDER BY count DESC
LIMIT 1;
```
Ergebnis: **Declaw (91x).**

4. Which owner spent the most on their pet and how much was it? Hint: use [SUM()](https://www.postgresql.org/docs/8.2/functions-aggregate.html)

```sql
SELECT o.ownerid, o.name, o.surname, SUM(d.price) AS spending
FROM petsowners.owners AS o
INNER JOIN petsowners.pets AS p
    ON o.ownerid = p.ownerid
INNER JOIN petsowners.procedurehistory AS h
    ON p.petid = h.petid
INNER JOIN petsowners.proceduredetails AS d
    ON h.proceduretype = d.proceduretype
   AND h.proceduresubcode = d.proceduresubcode
GROUP BY o.ownerid, o.name, o.surname
ORDER BY spending DESC
LIMIT 1;
```
Ergebnis: **Daniel Fay (Owner 8316) mit 450.**

5. Look at the data and ask yourself what more questions one could ask!

Ideen:
- Welche Tierart verursacht im Schnitt die höchsten Kosten?
- In welchen Monaten ist am meisten los (Auslastung der Praxis)?
- Welcher Anteil der Hunde ist gegen Tollwut geimpft, und wie viele sind überfällig?
- Gibt es Besitzer, deren Tiere besonders oft als Notfall kommen?
