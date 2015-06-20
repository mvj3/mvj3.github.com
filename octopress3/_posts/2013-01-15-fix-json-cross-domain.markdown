---
layout: post
title: 'Rails解决JSON数据跨域问题 Access Control Allow Origin not allowed by'
published: true
comments: true
date: 2013-01-15 15:09:03 +08:00
categories: [XMLHttpRequest, Rails]
---


XMLHttpRequest请求在不同域名下会出现"Access Control Allow Origin not allowed by"消息，即使是不同子域名，或根域名和子域名，也会出现这种情况。

详情见 https://developer.mozilla.org/en/http_access_control

rails控制器的方法加下以下声明即可
```ruby
response.header['Access-Control-Allow-Origin'] = '*'
response.header['Content-Type'] = 'text/javascript'
```

