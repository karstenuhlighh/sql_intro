# The theft of the Mona Lisa
---

The exercises are adapted to Postgresql from the sql-tutorial by [opentechschool](http://opentechschool.github.io/sql-tutorial/)

How you will find the thief of the Mona Lisa?

Follow the tutorial, step-by-step:

-> Find out, who was in Paris at that time?

-> The thief was probably not working alone. Is there any suspicious communication during the time in question?

-> If you find the people responsible, who was the actual wire-puller and who was "only" the henchman?

In DBeaver set the monalisa as the default schema.

> **Lösungen:** Alle Abfragen nutzen den Präfix `monalisa.` und laufen deshalb auch ohne Standard-Schema. Getestet gegen die Kurs-Datenbank am 06.10.2026.

## Exercises:

Work in pairs to solve the following tasks

![](https://static.wikia.nocookie.net/s__/images/7/79/Jessica_fletcher.jpeg/revision/latest?cb=20130409163539&path-prefix=sherlockpedia%2Fde)

### 1. Investigate the tables

Take a look at the table names and columns. What table could have information about travelling?

Lösung: Das Schema hat die Tabellen `account`, `bank_transaction`, `flight`, `messages`, `person` und `phone_contract`. Reiseinformationen stehen in **`flight`**.

### 2. Have a look at the data

What kind of information is stored in the table with travelling information?

```sql
SELECT *
FROM monalisa.flight
ORDER BY date;
```
Lösung: Pro Flug `id`, `person_id`, `name`, Abflugort `start_city`, Zielort `dest_city` und `date`. 54 Flüge im Jahr 2014.

### 3. Who all live in Paris?

Get the names of all the people who live in Paris.

```sql
SELECT name
FROM monalisa.person
WHERE residence = 'Paris';
```
Lösung: **Carlos und Wei.**

### 4. Get the names 

Who travelled to Paris before 23.10.2014.

```sql
SELECT name, start_city, date
FROM monalisa.flight
WHERE dest_city = 'Paris'
  AND date < '2014-10-23';
```
Lösung: **Philipp** (aus Hamburg, 20.10.), **Kesia** (aus Ouagadougou, 21.10.), **Sarah** (aus Atlanta, 21.10.).

### 5. Get more names 

Who travelled from Paris after 23.10.2014.

```sql
SELECT name, dest_city, date
FROM monalisa.flight
WHERE start_city = 'Paris'
  AND date > '2014-10-23';
```
Lösung: Philipp (nach Berlin, 24.10.), Sarah (nach Atlanta, 24.10.), Kesia (nach Moskau, 25.10.), Bethanie (nach Frankfurt, 31.10.).

### 6. Get even more the names 

Who travelled to Paris before 23.10.2014, and whose names also appear in entries for journeys departing from Paris after 23.10.2014. 

```sql
SELECT name
FROM monalisa.flight
WHERE dest_city = 'Paris'
  AND date < '2014-10-23'
  AND name IN (
      SELECT name
      FROM monalisa.flight
      WHERE start_city = 'Paris'
        AND date > '2014-10-23'
  );
```
Lösung: **Kesia, Philipp, Sarah.** Sie waren am 23.10. in Paris. Bethanie ist nur abgereist, aber nicht vorher angekommen.

### 7. Get all the names 

Of persons who live in Paris or who spent their time in Paris on 23.10.2014 (according to the travel data).

```sql
SELECT name
FROM monalisa.person
WHERE residence = 'Paris'
UNION
SELECT name
FROM monalisa.flight
WHERE dest_city = 'Paris'
  AND date < '2014-10-23'
  AND name IN (
      SELECT name
      FROM monalisa.flight
      WHERE start_city = 'Paris'
        AND date > '2014-10-23'
  );
```
Lösung: **Carlos, Kesia, Philipp, Sarah, Wei.** `UNION` fügt beide Listen zusammen und entfernt Doppelte.

### What is the pool of suspects you have left?

The Local police will visit individuals on the list to inquire about their alibi. Proceed with the previous query, this time we require a list of names and their respective residences. 

First perform a selection on the flight table where the name is one of those who do not live in Paris. Second, check for every person-residence pair if there is a corresponding flight. For one there is no corresponding flight. Who is this person? Why is this person turning up on that list?

```sql
SELECT name, residence
FROM monalisa.person
WHERE name IN (
    SELECT name
    FROM monalisa.flight
    WHERE dest_city = 'Paris'
      AND date < '2014-10-23'
      AND name IN (
          SELECT name
          FROM monalisa.flight
          WHERE start_city = 'Paris'
            AND date > '2014-10-23'
      )
);
```
Lösung: Die Liste zeigt Kesia (Ouagadougou), Philipp (Hamburg), **Philipp (Mumbai)** und Sarah (Atlanta). Für **Philipp aus Mumbai** gibt es keinen passenden Flug. Er taucht nur auf, weil es **zwei Personen namens Philipp** gibt und wir über den Namen verknüpft haben. Der Name ist nicht eindeutig.

Now, check the result. Is there something wrong! Do you have the correct list of people who travelled to Paris before 23.10.2014 and who travelled from Paris after 23.10.2014?

<details>
<summary>
Click here for Hint 
</summary>
Do not include people who reside in Paris
</details>

Lösung: Nein. Der Fehler ist die Verknüpfung über `name`. Richtig wird es erst über die eindeutige ID, siehe Aufgabe 9.

---
## Primary Key and Foreign Key

Now, look at your where statement in the last query you performed. Are the tables person and flight joined by the field name whose entries are not unique? <br>

To prevent mistakes like this we use primary key (PK) and foreign key (FK). People who create a table, usually define a column (or the combination of several columns) which is unique for every entry. This column is called the primary key. Other tables which are referencing entries of this table have a corresponding column, containing the same value as the primary key column of the referenced table. This corresponding column is called a foreign key. 
For example, in our person table, the field id is the primary key. This id is used in the phone_contract table as a foreign key person_id.

person (id) = phone_contract (person_id)

### 8. Foreign Keys

What foreign keys are used in the table containing the messages and which is the referenced table?

**hint:** the primary key is unique and the name often contains the suffix "id" and the foreign key columns often contain the name of the referenced table. (this is though only a convention, not always implemented in practice) 

Lösung: In `messages` sind **`contract_sender_id`** und **`contract_receiver_id`** die Foreign Keys. Beide verweisen auf **`phone_contract.id`**. Hinweis: In der Datenbank sind sie nicht als echte Constraints angelegt, man erkennt sie nur an der Namenskonvention.

### 9. Try the previous query 

use the primary key/foreign key connection instead of the name

```sql
SELECT DISTINCT p.id, p.name, p.residence
FROM monalisa.person AS p
INNER JOIN monalisa.flight AS arrival
    ON arrival.person_id = p.id
INNER JOIN monalisa.flight AS departure
    ON departure.person_id = p.id
WHERE arrival.dest_city = 'Paris'
  AND arrival.date < '2014-10-23'
  AND departure.start_city = 'Paris'
  AND departure.date > '2014-10-23'
  AND p.residence <> 'Paris';
```
Lösung: **Kesia (105), Philipp aus Hamburg (100), Sarah (106).** Philipp aus Mumbai ist jetzt verschwunden.

## WHO is the thief?? - order by and group by
---

![](https://64.media.tumblr.com/bd06d5721a022f2ba59abf60a4537758/tumblr_o8ofi9NGiJ1udb1f6o1_500.jpg)

To find out who the thief is, check the text messages stored by the mobile phone providers.

### 10. What are the names 

Of the table containing the text messages and the ones containing phone contracts?

Lösung: **`messages`** und **`phone_contract`**.

### 11. Get all the text messages 

Sent between 2014-10-20 and 2014-10-25.

```sql
SELECT *
FROM monalisa.messages
WHERE sent BETWEEN '2014-10-20' AND '2014-10-25';
```
Lösung: 51 Nachrichten.

### 12. Get all the contract ids 

Where the contract.person_id is equal to one of the persons from the results of question 7.

```sql
SELECT id AS contract_id, person_id, name
FROM monalisa.phone_contract
WHERE person_id IN (
    SELECT id
    FROM monalisa.person
    WHERE residence = 'Paris'
       OR id IN (
           SELECT arrival.person_id
           FROM monalisa.flight AS arrival
           INNER JOIN monalisa.flight AS departure
               ON arrival.person_id = departure.person_id
           WHERE arrival.dest_city = 'Paris'
             AND arrival.date < '2014-10-23'
             AND departure.start_city = 'Paris'
             AND departure.date > '2014-10-23'
       )
);
```
Lösung: Verträge **100 (Philipp), 102 (Carlos), 103 (Wei), 105 (Kesia), 106 (Sarah).**

### 13. Get all text messages 

with the sent date between 2014-10-20 and 2014-10-25 and the contract_sender_id is equal to the contract ids. And where the contract.person_id is equal to one of the persons from the results of question 7.

- You see that you got all the required information but the output looks kind of chaotic. You can order a result set according to a column with an order by phrase. The query to get all text messages from 21.10.2014 ordered by time reads

- select a message from messages where sent like '2014-10-21'
order by sent;

```sql
SELECT *
FROM monalisa.messages
WHERE sent BETWEEN '2014-10-20' AND '2014-10-25'
  AND contract_sender_id IN (100, 102, 103, 105, 106);
```
Lösung: 12 Nachrichten. Die IDs stammen aus Aufgabe 12.

### 14. Get a list of messages 

From our suspects from the given time period and sort the messages.

```sql
SELECT m.sent, sender.name AS sender, receiver.name AS receiver, m.message
FROM monalisa.messages AS m
INNER JOIN monalisa.phone_contract AS cs
    ON m.contract_sender_id = cs.id
INNER JOIN monalisa.phone_contract AS cr
    ON m.contract_receiver_id = cr.id
INNER JOIN monalisa.person AS sender
    ON cs.person_id = sender.id
INNER JOIN monalisa.person AS receiver
    ON cr.person_id = receiver.id
WHERE m.sent BETWEEN '2014-10-20' AND '2014-10-25'
  AND m.contract_sender_id IN (100, 102, 103, 105, 106)
ORDER BY m.sent, m.id;
```
Lösung: Die Namen von Absender und Empfänger kommen über zwei Joins dazu, `phone_contract` → `person`. So lassen sich die Gespräche lesen.

### 15.  Who are the thieves? 

Hint: Read the conversations as they give a clear trace. Check the ids of the sender and receiver of the message and look it up in the person tables!

Lösung: **Philipp (aus Hamburg) und Sarah (aus Atlanta).** Die Spur in den Nachrichten:
- 20.10. Philipp an Sarah: "Hi, I just arrived in Paris"
- 21.10. Sarah an Philipp: "Let's meet tonight 8pm at the tour eiffel and finalize ... preparation"
- 21.10. Philipp an Sarah: "btw: good news, I found a buyer. 100.000 k"
- 24.10. Philipp an Sarah: "This was a coup! ... would loved to keep ML to myselfe"

Kesia und Carlos haben sich nur zum Mittagessen verabredet.

Zur Frage nach dem Drahtzieher: Philipp hat den Käufer besorgt. Auf Sarahs Konto in Atlanta gehen am 24.10. vierzehn Zahlungen über je 1.000 mit dem Vermerk "Artwork" ein. Die vollständige Auflösung steht im verlinkten Kapitel 4 des Tutorials.

If you have found the thieves you deserve some break! To practice more SQL, you can continue the investigation of this incredible crime and find out [who was the string puller](http://opentechschool.github.io/sql-tutorial/chapter4.html) when you have some free time.
