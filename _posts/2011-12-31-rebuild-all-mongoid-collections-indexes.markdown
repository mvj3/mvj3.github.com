---
layout: post
title: 整个项目的mongoid表重建索引
published: true
comments: true
date: 2011-12-31 16:45:09 +08:00
categories: [Mongoid, Mongodb]
---

{% highlight ruby %}
Object.constants.map(&:constantize).select {|c| c.included_modules.include?(Mongoid::Document) rescue nil }.compact.map(&:create_indexes)
{% endhighlight %}
