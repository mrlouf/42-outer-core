Exploit: Find a .htpasswd File
===============================================

Description
-----------
Looking at the robots.txt file revealed a disallowed directory `/whatever`.
Accessing it gave us access to a `.htpasswd` file, which is used for basic HTTP authentication.
The `.htpasswd` file contains usernames and hashed passwords.

In this case, the file contained the following entry:

```plaintext
root:437394baff5aa33daa618be47b75cb49
```

This indicates that the username is `root` and the password hash is `437394baff5aa33daa618be47b75cb49`.
The lack of prefix or suffix around the hash suggests it is an MD5 hash, which is very
easily crackable using tools like `hashcat` or online services.
Using an online MD5 hash cracker, we find that the password corresponding to this hash is `qwerty123@`.

Cool, but now what? We have the key, but where is the door?

We can use the tool `dirsearch` to lookup all the directories on the web server.

```plaintext
Target: http://192.168.1.43/

[15:14:26] Starting: 
[15:14:29] 301 -  193B  - /admin  ->  http://192.168.1.43/admin/
[15:14:29] 200 -    1KB - /admin/
[15:14:29] 200 -    1KB - /admin/?/login
[15:14:29] 200 -    1KB - /admin/index.php
[15:14:31] 301 -  193B  - /audio  ->  http://192.168.1.43/audio/
[15:14:32] 301 -  193B  - /css  ->  http://192.168.1.43/css/
[15:14:33] 301 -  193B  - /errors  ->  http://192.168.1.43/errors/
[15:14:33] 200 -  967B  - /errors/
[15:14:33] 200 -    1KB - /favicon.ico
[15:14:33] 301 -  193B  - /fonts  ->  http://192.168.1.43/fonts/
[15:14:34] 200 -  967B  - /images/
[15:14:34] 301 -  193B  - /images  ->  http://192.168.1.43/images/
[15:14:34] 301 -  193B  - /includes  ->  http://192.168.1.43/includes/
[15:14:34] 200 -  967B  - /includes/
[15:14:34] 200 -    7KB - /index.php
[15:14:34] 200 -  967B  - /js/
[15:14:34] 301 -  193B  - /js  ->  http://192.168.1.43/js/
[15:14:37] 200 -   53B  - /robots.txt
```

This is interesting because we have found an `/admin` directory.
Accessing it leads to a login page that requires authentication.
We can use the credentials we found earlier (`root` / `qwerty123@`) to log in, and there you are.

Possible solutions
------------------
1. Do not store sensitive files such as `.htpasswd` or `.env` in publicly accessible directories. Ever.
2. Use stronger passwords, yes, but more than anything use stronger hashing algorithms (eg. bcrypt).
    MD5 is considered weak and easily crackable; modern algorithms with salting should be enforced
    to protect stored passwords.

Sources
-------
https://dev.to/iotools/understanding-htpasswd-a-comprehensive-guide-4c31
https://crackstation.net/