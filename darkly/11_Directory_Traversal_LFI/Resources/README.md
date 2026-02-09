Exploit: Directory Traversal / Local File Inclusion (LFI)
=========================================================

Description
-----------
When navigating in the web app, we can notice that the URL contains a parameter that
is being used to load files from the server, for example:

```
http://192.168.1.43/?page=signin
```

This loads the `signin` page. Now, if we try to change the `page` parameter to another value,
we can try to access other files on the server, or start a directory traversal attack.

Such an attack might be performed by adding `../` sequences to the parameter value, for example:

```
http://192.168.1.43/?page=signin/../../
```

This may allow the attacker to navigate to parent directories and potentially access sensitive files
on the server, such as `/etc/passwd` or application configuration files.
The example above actually triggered an error message hinting that we were on the right track:

```
<script>alert('Wrong..');</script><!DOCTYPE HTML>
```

It took some trial and error to find the number of `../` sequences to reach the objective
and trigger the flag:

```
http://192.168.1.43/?page=../../../../../../../../etc/passwd
```

Possible solutions
------------------
1. Implement proper input validation and sanitisation to prevent directory traversal sequences.
2. Use a whitelist approach to only allow specific, known-good file names to be included and reject all others.
3. Configure the web server (Nginx) to restrict access to sensitive files and directories via a blacklist for instance.

Sources
-------
https://owasp.org/www-community/attacks/Path_Traversal
https://en.wikipedia.org/wiki/Directory_traversal_attack#Example
