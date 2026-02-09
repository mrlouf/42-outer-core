Exploit: Cross Site Scripting (XSS)
===================================

Description
-----------
If we head to the Feedback page, we can submit feedback in the form of a comment,
using two text fields: **"Name"** and **"Comment"**. The fields are superficially protected
with non-null and length constraints, but tweaking the HTML allows us to easily bypass these.
As always, "If it's in the browser, it's not protected".

A simple preliminary test is to enter quotes in the fields and see if they are escaped
or not. If they are not escaped, it means that the input is not being sanitised properly,
and we can try to inject HTML or JavaScript code.

In this case, the field Comment was escaping quotes, but the Name field was not: this
is our injection point. We can enter a simple script tag to test if the input is
executed:

```html
<script>alert('XSS');</script>
```

When we submit the feedback, we see an alert box pop up, confirming that our script
was executed. This means we have successfully exploited a **Cross-Site Scripting (XSS)** vulnerability.

Getting the flag is actually far more straightforward: we just need to input the word **"script"**
in one of the fields, and the application will return the flag in the response.

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
