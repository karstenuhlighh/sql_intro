# At the Vet

You are assisting a vet clinic in making sense of their data. Their data is in two tables. And they need you tu perform the following analytics:

1. How many pets, how many owners? Hint: use [COUNT()](https://www.postgresql.org/docs/8.2/functions-aggregate.html)
2. What are the most and least common pet names? Hint: use [ORDER BY](https://www.postgresql.org/docs/8.1/queries-order.html)
3. What kind of pets do we have? Hint: use [DISTINCT](https://www.postgresql.org/docs/9.5/sql-select.html)
4. What is the gender balance across pets and species? Hint: use [GROUP BY](https://www.postgresql.org/docs/9.4/tutorial-agg.html)
5. What is the average age of the pets? Hint: use [AVG()](https://www.postgresql.org/docs/9.4/tutorial-agg.html)
6. How many owners have more than one pet? Hint: use [GROUP BY HAVING](https://www.postgresql.org/docs/9.4/tutorial-agg.html)
7. Do the owners that have more than one pet have the same kind of pet. Hint: use [ARRAY_AGG](https://www.postgresqltutorial.com/postgresql-aggregate-functions/postgresql-array_agg/)
8. Do owners name their pets like owners? Hint: use [INNER JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html)
9. Extract the information of pet names and owners side-by-side! Hint: use [FULL JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html)
10. What are the cities with the largest amount (top 3) of pets? Hint: use [INNER JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html)

### Let's look at some of the procedures those pets had.

1. Combine the tables with the procedure history and the procedure details. You might have to join tables based on more than one column...
2. What pets did't get rabies vaccination? Hint: use [LEFT JOIN](https://www.postgresql.org/docs/8.3/tutorial-join.html), use [ARRAY_AGG()](https://www.postgresql.org/docs/8.2/functions-aggregate.html) and use [ALL()](https://www.postgresql.org/docs/9.1/functions-comparisons.html)
3. What is the most prevalent type of surgery?
4. Which owner spent the most on their pet and how much was it? Hint: use [SUM()](https://www.postgresql.org/docs/8.2/functions-aggregate.html)
5. Look at the data and ask yourself what more questions one could ask!
