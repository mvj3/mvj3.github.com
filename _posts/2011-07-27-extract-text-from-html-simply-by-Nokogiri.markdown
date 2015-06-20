---
layout: post
title: 使用Nokogiri简单抽取HTML文本
published: true
comments: true
date: 2011-07-27 10:33:00 +08:00
categories: [Ruby, HTML]
---

使用Nokogiri一句就可以搞定！

{% highlight ruby %}
require 'nokogiri'

Nokogiri::HTML(html).text
{% endhighlight %}
