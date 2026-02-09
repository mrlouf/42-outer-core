Exploit: Forgot Password Functionality Abuse
============================================

Description
-----------
This exploit targets web applications that have a **"Forgot Password"** feature.
In this case, the application allows users to recover their password using a button
that supposedly sends a recovery email to the system administrator's email address.
The email address is hardcoded in the application, making it vulnerable to exploitation:

```html
<input type="hidden" name="mail" value="webmaster@borntosec.com" maxlength="15">
```

Changing the value with a different email address allows an attacker to receive
the password recovery email intended for the administrator.

Possible solutions
------------------
1. Avoid hardcoding email addresses in the HTML code, especially sensitive ones.
2. Implement a server-side verification to ensure that the email address belongs to a valid user.
3. Open an endpoint 'api/send_recovery_email' that accepts only registered user emails.
    The message should be neutral and not disclose whether the email is registered or not, e.g.:
    "If the email is registered, you will receive a recovery email shortly."
4. Use CAPTCHA and/or rate limiting to prevent automated abuse of the password recovery feature.

Sources
-------
https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html
