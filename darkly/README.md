# darkly

A CTF project to discover, inspect and exploit vulnerabilities on a web app to learn the basics of cybersecurity and OWASP.

## Overview

The Darkly project consists in conducting a small audit of a simple web application to discover and learn about common web vulnerabilities.
As stated per the subject, there are 14 flags to be found, each corresponding to a specific vulnerability that the student will have to identify and exploit.

Each vulnerability is documented in a dedicated folder with a README file explaining the vulnerability, how to exploit it, and possible solutions.

## Setup

To set up the Darkly project, you will need to launch a VM using the provided ISO file.
The most straightforward way to do this is to use a virtualisation software like VirtualBox.

After a quick unattended installation, the VM should be ready to use:
set the network adapter to "Bridged Adapter" mode to be able to access the web application from your host machine.
If the launch is successful, you should see the IP address of the application in the VM window and access via the port 80.

## Web Application

The web application is a simple PHP-based site with multiple pages and functionalities.
Each page is designed to demonstrate a specific vulnerability that can be exploited to retrieve a flag.
All vulnerabilities can be found by manually exploring the application and inspecting the source code,
however some tools like curl, dirsearch or hydra can be very useful.

## Takeaways

The Darkly project is a great way to learn about common web vulnerabilities and how to prevent them
as a web developer or a security professional. Having done the previous ft_transcendence project,
this CTF allows to look back at web security from a different angle from which we can sum up a few key takeaways:

- If it is in the browser, it can (and will) be manipulated by the user. User input should never be trusted.
  This means that for any type of input (form fields, URL parameters, cookies, headers, etc.),
  proper validation and sanitisation should be implemented server-side to prevent potentially harmful data
  from being processed.
- Discretion is key when it comes to error messages or even file names. Revealing too much information
  about the server, database or application structure can help attackers identify potential vulnerabilities
  and exploit them.
- Generally speaking, whitelists are preferred over blacklists when it comes to validation. 
  It's often easier to define what is allowed rather than what is not allowed, as blacklists can be bypassed
  by clever attackers. This is also true for CORS policies, like redirections or content security policies.