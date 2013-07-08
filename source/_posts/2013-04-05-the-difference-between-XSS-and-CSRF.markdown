---
layout: post
title: XSS和CSRF的区别
published: true
comments: true
date: 2013-04-05 20:22:49 +08:00
categories: [Secure, XSS, CSRF]
---


XSS 是直接在源网站执行，如常见的如SQL注入和提交JS代码等。解决方法一般为把用户输入都作为不信任数据做转义处理。

CSRF 是破坏者间接利用了用户在源网站登陆情况下，在其他网站诱导用户触发JS请求获取源网站访问授权。Rails里用每次分配随机的 `csrf_meta_tag` 来解决伪造问题。
