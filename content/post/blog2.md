---
title: "Django Deploying (Django 部署)"
date: 2020-07-04T00:53:26-04:00
draft: false
tags: [
	"Django",
	"Python",
]
type: "post"
description: "Know how to deploy Django through AWS (lightsail specifically)"

---

# Problems encountered when deploying Django
*Author: Rong Ma*

## 1. 基础知识
1. DNS (Domain Name System) <br>
	* 一个分布式域名查询系统，将输入的域名(Domain) 变成相对应 IP 的系统。主要根据分级的根和域来确定对应的数据库从而找到相应的ip地址。 [具体说明](https://blog.csdn.net/qq_31930499/article/details/79767330) 

2. Lightsail 
   * Amazon 出品的linux 服务器 并且自带一个安装好的软件。[官网](https://https://aws.amazon.com/cn/)



## 2. 遇到的问题

- **400 Bad Request**  
  * settings.py allowed_host = [*] 或者 等于 domain 的名字， 或者 ip 的地址 
  https://stackoverflow.com/questions/19875789/django-gives-bad-request-400-when-debug-false

- **403 FORBIDDEN Server unable to read .htaccess file, denying access to be safe**
  * Make sure .htaccess is readable by apache chmod 644 access/folder_name/.htaccess ; make sure the directory which contains .htaccess is readble and excutable. https://stackoverflow.com/questions/42849166/server-unable-to-read-htaccess-file-denying-access-to-be-safe?rq=1
  
  * 正确做法 -> `sudo chmod -R 755 <site_top_folder>` https://stackoverflow.com/questions/31365981/server-unable-to-read-htaccess-file-denying-access-to-be-safe







