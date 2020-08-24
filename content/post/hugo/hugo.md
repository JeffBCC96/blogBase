---
title: "Hugo建立个人博客"
date: 2020-07-06T19:05:01-04:00
draft: false
tags: [
    "Python",
    "Hugo"
]
author: "Rong Ma"
type: "post"
---

都0202年了，哪个可爱的男孩纸或者女孩纸不想拥有一个属于自己的博客呢。但是建一个博客听起来就好麻烦哦，还好有hugo这个轻量化的web 框架，从而让我们很快地搭建一个属于自己的免费的博客。让广大网友在第一时间就可以享受到分享的快乐以及成就感。
<!--more-->

**准备工作**

*以下命令最好在<mark>Mac terminal</mark>或者 <mark>Linux</mark> 中进行并用自己定义的名字去替换<>中的内容*

1. `brew install hugo` 或者去[hugo官网](https://gohugo.io)下载
2. `hugo new site <网站名字>`
3. 去 Git hub 上创建两个repositories
   1. 网页仓库地址： `<username>.github.io` 来存放你的网页代码 
   2. 总仓库地址： 来存放后端的代码或文件
4. `cd <网站名字>`
5. `git init`
6. `git remote add origin <总仓库地址>`
7. 去themes.hugo 下载想要的主题 
8. `git submodule add -b origin <主题git地址> <themes/主题名字>`

**搭建和调试**
1. 换一下这个conf 文件 或者 直接用 example_site 
2. `hugo new post/<blogNmae>.md` 或者新建一个包含.md 的文件夹 `hugo new post/<folder name>/<blogNmae>.md`
3. 启动本地服务器
   1.  `hugo server -t <主题地址> --buildDrafts`
   2.  `hugo --theme=<主题名字> --baseUrl=<网页仓库地址> --buildDrafts`


**将网页部署在git总仓库和网页仓库中**
1. `fetch --all`
2. `git add .`
3. `git commit -m <update>`
4. `git push origin master`
5. 如果已经建了public 这个文件 先删除`rm -rf ./public`
6. `git submodule add -b origin <网页仓库地址> public`
7. `hugo --theme=<主题名字>`
8. `cd public`
9. `git add .`
10. `git commit -m <update>`
11. `git push origin master`


**将来更新**
1. 删除已经发布的文章 
   1.  要删除content/post 中的原文
   2.  要删除public/post中对应的文件夹
   
2.  添加新的博客
    * 用我找到的deploy.sh 
    * 在site 根目录下 `./deploy.sh <更新消息>` [下载连接](../deploy.sh)
    * 如果不把draft:true 变成 false , 将不会在网页中显示


将来我会把录制的视频教程放在这条博客下。


