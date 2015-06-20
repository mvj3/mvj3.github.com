---
layout: post
title: '解决 Memcached::ServerError: object too large for cache 错误'
published: true
comments: true
date: 2013-05-28 15:28:32 +08:00
categories: [Memcached]
---

问题
---------------------------------------
在添加 [用jsbeautifier.org解压缩jing.fm的Web版的js代码
](http://code.eoe.cn/1620) 的长达7029行js代码后，后台服务器马上报500错误，对应错误信息是 `Memcached::ServerError: "object too large for cache". Key {"git_file_html_8741fc1d7923a820e7de64d996125a527792cc89"=>"localhost:11211:8"}`

解决方案
---------------------------------------
在添加 [用jsbeautifier.org解压缩jing.fm的Web版的js代码
配置memcached的-I选项以调整每个cache item的最大值。
{% endhighlight %}sh
memcached -I 3m -p 11211 -v -m 512 -d
{% endhighlight %}
