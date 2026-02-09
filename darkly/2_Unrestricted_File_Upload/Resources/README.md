Exploit: Unrestricted File Upload
=================================

Description
-----------
An unrestricted file upload vulnerability occurs when a web application allows users to upload files
without proper validation or restrictions. This can lead to various security risks, including the
execution of malicious code on the server.

In this case, we can see that the upload form has minimal restrictions on the file type,
only checking for the final extension of the file as `.jpg`. If we try to upload any other file type,
we get an error message indicating that the file was not uploaded.
However, if we upload a file with a `.jpg` extension, the upload is successful and we receive a confirmation message.
This confirmation message states:

```
/tmp/fake.jpg succesfully uploaded.
```

This is already a **major security flaw** because of two things:
1. The application leaks where the uploaded files are stored on the server (`/tmp/` directory).
2. The name of the uploaded file is not sanitised and is displayed in clear within the HTML, which can lead to code injection attacks.

Consider a file called `xss<img src=x onerror=alert(1)>.jpg`, for instance: when we upload this file,
the application will try and display the confirmation message but will unintentionally execute the injected JavaScript code.

But we still have not found the flag yet.

To retrieve it, we need to look at the way the form is sent to the server.
If we have a look at the payload sent when trying to upload a file that is not a `.jpg`, we can see the following in the developer tools of our browser:

```
------geckoformboundarybfc94206b61883c28f5ba77b0a6f3f39
Content-Disposition: form-data; name="MAX_FILE_SIZE"

100000
------geckoformboundarybfc94206b61883c28f5ba77b0a6f3f39
Content-Disposition: form-data; name="uploadedimage/jpg"; filename="exploit.php"
Content-Type: application/x-php


------geckoformboundarybfc94206b61883c28f5ba77b0a6f3f39
Content-Disposition: form-data; name="Upload"

Upload
------geckoformboundarybfc94206b61883c28f5ba77b0a6f3f39--
```

The key part here is the `Content-Type` header, which is set to `application/x-php`. The client is indicating to the server that the file being uploaded is a PHP file,
but what happens if we change this header to `image/jpg` instead so that it matches the expected file type?

Consider the following payload:

```
------geckoformboundarybfc94206b61883c28f5ba77b0a6f3f39
Content-Disposition: form-data; name="uploaded"; filename="exploit.php"
Content-Type: image/jpg
```

This is effectively telling the server that we are uploading a file called `exploit.php` and that it is of type `image/jpg`.
If the server only checks the `Content-Type` header and not the actual content of the file, it will accept the upload.

In our case, the server accepts it and shows the confirmation message, and we trigger the flag.

Possible solutions
------------------
1. Never leak where files are stored on the server. A simple "File successfully uploaded" message is sufficient.
2. Sanitise file names to prevent code injection attacks: remove special characters and limit the length of the file name.
   If possible, generate a random file name instead of using the original one, with a simple hash function for instance.
   image.png could become `5f4dcc3b5aa765d61d8327deb882cf99.png`, and so on.
3. Implement strict file type validation: not just the extension, but the actual file content (MIME type) should be checked server-side.

Sources
-------
https://www.vaadata.com/blog/file-upload-vulnerabilities-and-security-best-practices/