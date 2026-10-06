/* 
1. Investigate the tables
Take a look at the table names and columns. What table could have information about traveling?

Have a look at all tables. Use the select command on all tables present in the database.

The information about traveling is of course in the flight table.
*/

select * from person;

select * from accounts;



/*
2. Have a look at the data
What kind of information is stored in the table with traveling inforamation?
*/

select * from flight;

/*
3. Who lives in Paris?
Get the names of all people who live in Paris.
*/

select * from person where residence = 'Paris';

/*
4. Get all names that did a journey to Paris before 23.10.2014.
*/

select name from flight where dest_city = 'Paris' 
and date < '2014-10-23';

/*
5. Get all names that did a journey from Paris after 23.10.2014.
*/

select distinct name from flight where start_city = 'Paris' 
and date > '2014-10-23';

/*
6 Get all names, that did a journey to Paris before 23.10.2014, where this name is also in an entry for a journey 
from Paris after the 23.10.2014.
*/

select distinct name from flight where dest_city = 'Paris'
and date < '2014-10-23' 
and name in (select name from flight where start_city 
= 'Paris' and date > '2014-10-23');

/*
7. Get all names of persons
 who live in Paris or spent their time in Paris on 23.10.2014 (according to the travel data).
*/

select distinct person.name from person, flight
where residence = 'Paris'
or (flight.name = person.name and dest_city = 'Paris'
and date < '2014-10-23' and flight.name in
(select flight.name from flight 
where start_city = 'Paris' and date > '2014-10-23'));


/*
Now, check the result. There is something wrong! In the list of conspicuous persons,
 there is one, who actually never was in Paris, i.e. who lives neither in Paris nor was traveling there.
*/

select * from flight where name in ('Philipp', 'Kesia', 'Sarah');

/* 
and
*/

select distinct person.name, residence from person, flight
where residence = 'Paris' or
(flight.name = person.name and dest_city = 'Paris' and
date < '2014-10-23' and flight.name in
(select flight.name from flight
where start_city = 'Paris' and date > '2014-10-23'));

/*
First perform a select on the flight table where the name is one of those who do not live in Paris. 
Second, check for every person-residence pair if there is a corresponding flight. 
For one there is no corresponding flight. Who is this person? Why is this person turning up in that list?
*/

select distinct person.name, residence from person, flight 
where residence = 'Paris' or 
(flight.person_id = person.id and dest_city = 'Paris' 
and date < '2014-10-23' and flight.name in 
(select flight.name from flight where start_city = 'Paris'
and date > '2014-10-23'));


/*
8. What foreign keys are used in the table containing the messages and which is the referenced table?
*/

select * from messages where sent > '2014-10-20'
or sent < '2014-10-25';

/*
contract_sender_id and contract_reciever_id are foreign keys and they referr to the table 'person'
*/


/*
9. Try previous query using the primary key/foreign key connection instead of the name
*/

select id from phone_contract where phone_contract.person_id
in (select distinct person.id from person, flight
where residence = 'Paris' or 
(flight.person_id = person.id
and dest_city = 'Paris' and date < '2014-10-23'
and flight.name in (select flight.name from flight
where start_city = 'Paris' and date > '2014-10-23')));

/*
10. What are the names of the table containing the text messages and the one containing phone contracts?

tables 'messages' and 'phone_contract'
*/

/*
11. Get all text messages which where sent between 2014-10-20 and 2014-10-25.
*/

select * from messages where sent > '2014-10-20'
and sent < '2014-10-25';

/*
12. Get all contract ids where the contract.person_id is equal to one of the persons from the results of question 7.
*/

select * from messages where sent > '2014-10-20'
and sent < '2014-10-25' and contract_sender_id in
(select id from phone_contract
where phone_contract.person_id in
(select distinct person.id from person, flight
where residence = 'Paris' or (flight.person_id = person.id
and dest_city = 'Paris' and date < '2014-10-23'
and flight.name in (select flight.name from flight
where start_city = 'Paris' and date > '2014-10-23'))));


/*
13. Get all text messages where the sent date between 2014-10-20 and 2014-10-25 and the contract_sender_id is 
equal to the contract ids where the contract.person_id is equal to one of the persons from the results of question 7.
*/

select * from messages
where sent > '2014-10-20' and sent < '2014-10-25'
and contract_sender_id in (select id from phone_contract
where phone_contract.person_id in
(select distinct person.id from person, flight
where residence = 'Paris' or (flight.person_id = person.id
and dest_city = 'Paris' and date < '2014-10-23'
and flight.name in (select flight.name from flight
where start_city = 'Paris' and date > '2014-10-23'))))
order by sent;

/*----------------------------------------------------------------
15. Who are the thieves? Hint: Read the conversations as they a give a clear trace. 
Check the ids of sender and receiver of the message and look it up in the person tables!
*/

select * from person
where id = 100 or id = 106;