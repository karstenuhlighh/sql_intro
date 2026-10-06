# Intro to SQL

A hands-on introduction to SQL for data work. You connect to a PostgreSQL database with DBeaver and practice querying it, starting from your first `SELECT` and building up through filtering, joins, aggregates, and grouping. Internal data usually lives in a database, so being able to retrieve and reshape it with SQL is a core data-science skill.

## Learning Objectives

By the end of this repository, you should be able to:

- Explain what a relational database is and how tables relate through primary and foreign keys
- Connect to a PostgreSQL database using DBeaver
- Write `SELECT` queries that filter rows with `WHERE`, `IN`, `BETWEEN`, and `LIKE`
- Combine tables with `INNER JOIN`, `LEFT JOIN`, and `FULL JOIN`
- Summarise data using aggregate functions together with `GROUP BY` and `HAVING`
- Sort and limit results with `ORDER BY` and `LIMIT`, following the mandatory SQL clause order

## Learning Path

Work through the modules in order. The third is an optional bonus.

### 1 - SQL Basics

Core SQL syntax with worked examples and guided exercises. Start here.

| File                                                                | Description                                                  |
| ------------------------------------------------------------------- | ------------------------------------------------------------ |
| [**Lesson & Exercises**](1_SQL_Basics/sql_basics.md)   | Concepts and guided exercises, from SELECT through grouping. |

### 2 - SQL Exercises

Practice querying a vet clinic's pets-and-owners database.

| File                                                                                         | Description                                                  |
| -------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| [**Vet Clinic Practice**](2_SQL_Exercises/petsowners.md)                         | Fifteen analytics questions on a pets-and-owners. Use the petsowners schema|
| [**Vet Clinic Expected Outputs**](2_SQL_Exercises/petsowners_expected_output.md) | The same questions with screenshots of the expected results. |

### 3 - SQL Exercises (Complex)

Optional bonus: a crime investigation to uncover who stole the Mona Lisa.

| File                                                                              | Description                                       |
| --------------------------------------------------------------------------------- | ------------------------------------------------- |
| [**The Theft of the Mona Lisa**](3_SQL_Exercises_Complex/monalisa.md) | Solve the case using joins, keys, and subqueries. Use the monalisa schema.|

### Additional Folders and Files

| File / Folder                                        | Description                                                             |
| ---------------------------------------------------- | ----------------------------------------------------------------------- |
| [**Assets**](assets/)                             | Screenshots for the database connection and the expected-output checks. |
| [**Database Connection**](database_connection.md) | How to connect DBeaver to the shared PostgreSQL database.               |
| [**Solutions**](solutions/)                             | Solutions to the exercises.                                                 |

## Setup

> [!NOTE]
> Throughout these steps, text in angle brackets like `<repo-name>` is a **placeholder**. Replace it, including the `< >` brackets, with your own value. For example, `cd <repo-name>` becomes `cd ds-sql-intro`.

### 1. Create the Repository from the Template

Click **Use this template** on GitHub.

When creating the repository:

- Set yourself as the **Owner**
- Choose a repository name
- Disable **Include all branches**
- Click **Create repository**

> [!IMPORTANT]
> If you are working in pairs or groups, only **one person** should complete this step.

---

### 2. Add Collaborators (Pairs/Groups Only)

If working with teammates:

1. Open the repository on GitHub
2. Go to **Settings → Collaborators**
3. Add your teammates as collaborators
4. Share the repository link with your team

Teammates should accept the invitation before continuing.

---

### 3. Clone the Repository

Copy the SSH URL from the **Code** button on GitHub, then run:

```bash
git clone <copied-ssh-url>
cd <repo-name>
```

The copied SSH URL will look like `git@github.com:<your-username>/<repo-name>.git`.

---

### 4. Connect to the Database

All queries run against a shared PostgreSQL database through DBeaver. Follow the [Database Connection guide](database_connection.md) to set up the connection and open your first SQL editor, then start with the [SQL Basics lesson](1_SQL_Basics/sql_basics.md).

## References & Further Reading

- [**DBeaver**](https://dbeaver.io/): The free database client used throughout this repository
- [**PostgreSQL Tutorial**](https://www.postgresqltutorial.com/): Beginner-friendly, example-driven PostgreSQL reference
- [**SQLBolt**](https://sqlbolt.com/): Interactive SQL lessons you run in the browser
