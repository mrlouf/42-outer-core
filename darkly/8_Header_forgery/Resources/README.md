Exploit: Header Forgery
=======================

Description
-----------
Inspecting the bottom of the main page, in the source code, we can see that the copyright line
is actually a link to a semi-hidden page that displays a random information about albatrosses.

Inspecting the HTML reveals some odd comments, suggesting that the user should modify some parameters:

```html
<!--
Let's use this browser : "ft_bornToSec". It will help you a lot.
-->
```
and
```html
<!--
You must come from : "https://www.nsa.gov/".
-->
```

This indicates that we need to modify the "User-Agent" and "Referer" headers to the specified values.
Modern browsers do not always allow direct modification for security reasons,
but we can use simple tools like `curl` to achieve this:

```bash
curl -H "User-Agent: ft_bornToSec" \
    -H "Referer: https://www.nsa.gov/" \
    http://192.168.1.43/index.php?page=b7e44c7a40c5f80139f0a50f3650fb2bd8d00b0d24667c4c2ca32c88e13b758f
```

This loads new content into the HTML page, revealing the flag.

Possible solutions
------------------
1. Avoid relying on HTTP headers for security checks, as they can be easily manipulated by attackers.
2. Implement server-side validation and authentication mechanisms that do not depend on client-supplied headers,
   such as session tokens or OAuth.

Sources
-------
https://owasp.org/www-community/vulnerabilities/Unprotected_Cookies