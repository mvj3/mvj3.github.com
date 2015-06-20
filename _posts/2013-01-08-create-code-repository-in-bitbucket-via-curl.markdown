---
layout: post
title: '通过CURL在bitbucket上创建代码仓库'
published: true
comments: true
date: 2013-01-08 17:12:06 +08:00
categories: [Git, curl, bitbucket]
---

{% endhighlight %}bash
curl -k -X POST -d 'name=hello1'\
     --user your@email.com:password
     https://api.bitbucket.org/1.0/repositories -v
{% endhighlight %}

