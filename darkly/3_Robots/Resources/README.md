Exploit: Find the robots.txt File
===============================================

Description
-----------
The robots.txt file is used by websites to give instructions to web crawlers
about which pages or sections of the site should not be crawled or indexed.
However, this file alone does not prevent access to those areas,
and anyone can choose to ignore the instructions and access the restricted sections.
An attacker can easily locate and access the robots.txt file by navigating to
`http://example.com/robots.txt`, where `example.com` is the target website's domain.

Here is the content of the robots.txt file:

```plaintext
User-agent: *
Disallow: /whatever
Disallow: /.hidden
```

This indicates that the `/whatever` and `/.hidden` directories are disallowed
for web crawlers, but gives a human attacker clues about where to look.

Accessing the directory `http://192.168.1.43/.hidden/` reveals a huge arborescence
of directories and subdirectories that may contain sensitive information, or nothing.
They are too numerous to explore manually, so an attacker could use automated tools or
simply use recursive commands like `wget -r` to download the entire content for further analysis:

```plaintext
wget -r -np -nH -e robots=off http://192.168.1.43/.hidden/
```

wget options explained:
- `-r`: recursive download
- `-np`: no parent, do not ascend to the parent directory, ie. stay within `.hidden` and don't go up
- `-nH`: no host directories, do not create a directory named after the host (optional)
- `-e robots=off`: ignore robots.txt file: this is key, since we are explicitly trying to access a disallowed directory
- `--cut-dirs=1`: ignore the first directory level when saving files locally (optional)

Once we have downloaded the content, we can recursively search for interesting files such as flags:

```plaintext
grep -R -i "flag" .hidden/
```

And there you have it.

Possible solutions
------------------

1. Avoid using the robots.txt file to hide sensitive directories or files.
   Instead, use proper authentication and authorization mechanisms to restrict access.
2. If you must use robots.txt, ensure that the disallowed directories do not contain sensitive information,
   and do not leak any clues about the structure of your website.

Sources
-------
https://en.wikipedia.org/wiki/Robots.txt
