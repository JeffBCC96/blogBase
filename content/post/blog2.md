---
title: "Blog2"
date: 2020-07-04T00:53:26-04:00
draft: true
tags: [
	"Django",
	"Python",
]
type: "post"

---

# Problems encountered when deploying Django
`Author: Rong Ma`


- 400 Bad Request  |  settings.py allowed_host = [*] 或者 等于 domain 的名字， 或者ip 的地址 https://stackoverflow.com/questions/19875789/django-gives-bad-request-400-when-debug-false

- 403 FORBIDDEN Server unable to read .htaccess file, denying access to be safe| make sure .htaccess is readable by apache chmod 644 access/folder_name/.htaccess ; make sure the directory which contains .htaccess is readble and excutable. https://stackoverflow.com/questions/42849166/server-unable-to-read-htaccess-file-denying-access-to-be-safe?rq=1
正确做法 -> `sudo chmod -R 755 <site_top_folder>` https://stackoverflow.com/questions/31365981/server-unable-to-read-htaccess-file-denying-access-to-be-safe







