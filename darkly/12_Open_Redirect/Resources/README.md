Exploit: Open Redirect
======================

Description
-----------
Looking at some of the links in the application, we can see that some use
a parameter to redirect the user to a different page. For example:

```html
	<li><a href="index.php?page=redirect&site=facebook" class="icon fa-facebook"></a></li>
	<li><a href="index.php?page=redirect&site=twitter" class="icon fa-twitter"></a></li>
	<li><a href="index.php?page=redirect&site=instagram" class="icon fa-instagram"></a></li>
```

If we try to reach `index.php?page=redirect&site=42` we trigger the flag.

This is an example of an **Open Redirect vulnerability**, where an application
redirects users to **arbitrary URLs** based on user input, **without proper validation**.

In a real case scenario, an attacker could **redirect users to a malicious site**,
potentially leading to **phishing attacks** or **malware distribution**.

Possible solutions
------------------
1. In the case of large, complexe applications where redirects to multiple
   external sites are necessary, it is advisable tomaintain a whitelist of allowed URLs or domains.
   The redirects should only be possible after a server-side check against this whitelist.
2. Avoid using user input directly in redirects. Instead, use predefined
   identifiers that map to specific URLs on the server side.

Sources
-------
https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html
