Exploit: Cross Site Scripting (XSS)
===================================

Description
-----------
Similarly to the previous example of **Cross Site Scripting (XSS)** via URL parameters, if we head
to the Media page by clicking on the NSA image from the Home page, we can see that there is a parameter
called "src" in the URL. This parameter is used to specify which media file to load:

```
http://192.168.1.43/?page=media&src=nsa
```

If we modify the "src" parameter, we can see that the application tries to load the specified media file,
but mostly fails because the file does not exist:

```
http://192.168.1.43/?page=media&src=42
```

However, if we inject a script directly into the "src" parameter, we might be able to execute JavaScript code:
```
http://192.168.1.43/?page=media&src=%3Cscript%3Ealert(%27XSS%27);%3C/script%3E
```

However this does not work because the application seems to sanitise the input,
maybe by escaping special characters or filtering out certain tags.

The solution is to find a way to inject the script in a way that **bypasses the sanitisation**, with **base64 encoding** for example:

```
echo '<script>alert(1)</script>' | base64
# Result: PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==

# Then in the URL
http://192.168.1.43/?page=media&src=data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==
```

This triggers the flag, that we can then submit.

Possible solutions
------------------
1. Input Validation: Implement strict input validation on all user inputs to ensure that
   only expected data is accepted. In this example, restricting the Name field to alphanumeric
   characters would reject characters like '<' and '>', effectively preventing script injection.
2. Escaping Output: As we saw with the examples that escaped quotes, properly escaping user input
   before rendering it in the HTML context can prevent the execution of injected scripts.
3. CSP (Content Security Policy): Implement a Content Security Policy that restricts the sources
   from which scripts can be loaded. This can help mitigate the impact of XSS vulnerabilities
   by preventing the execution of malicious scripts from untrusted sources, in this case the user input.

Sources
-------
https://www.invicti.com/learn/cross-site-scripting-xss
