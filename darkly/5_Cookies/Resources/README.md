Exploit: Cookie Manipulation
===============================================

Description
-----------
If we open the **dev console** in the browser, we can see that there is a cookie
with the explicit name **"I_am_admin"** with a value that looks like a hash:

```plaintext
I_am_admin:"68934a3e9455fa72420237eb05902327"
```

This looks again like a simple **MD5 hash**. If we try to reverse it using an online MD5
decryption tool, we find out that the original value is the boolean "false".
Using the reverse logic, if we change the cookie value to the MD5 hash of "true",
we can escalate our privileges to admin and get the corresponding flag after refreshing the page.

Possible solutions
------------------
1. Avoid storing sensitive information in cookies, and especially avoid using predictable names.
2. Again, use more complex algorithms for hashing, and add a salt to the hash to make it more secure.
3. Use secured, HttpOnly, and SameSite cookie attributes to enhance security.

Sources
-------
https://owasp.org/www-community/vulnerabilities/Unprotected_Cookies
