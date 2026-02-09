Exploit: Brute Force Attack
===========================

Description
-----------
A **brute force attack** involves systematically trying a large number of possible combinations
to guess a secret value, such as a password or a PIN. In this scenario, we can perform a brute force
attack on a login form by automating the submission of different username and password combinations
until we find the correct one with the help of a tool like **hydra**.

The sign-in page contains a login form that requires a username and password.
These credentials are then used in the **URL parameters** when submitting the form:

```
http://192.168.1.43/?page=signin&username=admin&password=password&Login=Login#
```

An incorrect login attempt results in the loading of a new page with a specific error message and image `WrongAnswer.gif`.
This gives us a **textbook playground for a brute force attack**, as we can easily automate the process of trying different
username and password combinations by manipulating the URL parameters.

Using hydra
-----------
To perform the brute force attack, we can use the following hydra command:

```
hydra -l admin -P rockyou.txt  192.168.1.43 http-get-form "/:page=signin&username=^USER^&password=^PASS^&Login=Login:F=WrongAnswer.gif"
```

In this command:
-l admin: specifies the username to use (in this case, the very common "admin").
-P rockyou.txt: specifies the password list to use (in this case, the popular "rockyou.txt" wordlist).
192168.1.43: is the target IP address.
http-get-form: indicates that we are targeting an HTTP GET form according to the structure found in the HTML source code.

Form parameters (separated by a colon ":"):
"/" means the root path of the web application.
"page=signin&username=^USER^&password=^PASS^&Login=Login" is the structure of the form submission, with placeholders ^USER^ and ^PASS^ for the username and password.
"F=WrongAnswer.gif" specifies the failure condition, whereas the presence of `WrongAnswer.gif` in the response HTML indicates a failed login attempt.

It took about 30 seconds for hydra to find the correct password:

```
[80][http-get-form] host: 192.168.1.43   login: admin   password: shadow
```

Using the discovered credentials, we can sign in and retrieve the flag.

**Brute force attacks** can be **time- and resource-consuming**, and it may be detected by security systems,
however when done in a **targeted manner** with the right tools and wordlists, they can be effective in uncovering **weak credentials**.

Possible solutions
------------------
1. Implement account lockout mechanisms (temporary or not) after a certain number of failed login attempts
   to prevent automated brute force attacks.
2. Use CAPTCHAs to distinguish between human users and automated scripts.
3. Enforce strong password policies to make passwords harder to guess:
   Use of special characters, minimum length, forbid dictionary words, etc.
4. Monitor and log login attempts to detect and respond to suspicious activity.

Sources
-------
https://github.com/vanhauser-thc/thc-hydra
https://github.com/dw0rsec/rockyou.txt
