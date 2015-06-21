---
layout: post
title: Rails 3.1找不到静态资源
published: true
comments: true
date: 2011-07-25 14:41:00 +08:00
categories: [Rails, Assets]
---


发现一个诡异的现象，Rails在production模式下启动后找不到资源，报如下错误：


{% highlight html linenos %}
Started GET "/images/people.jpg" for 127.0.0.1 at Mon Jul 25 14:21:35 +0800 2011

ActionController::RoutingError (No route matches [GET] "/images/people.jpg"):

Rendered /usr/local/rvm/gems/ree-1.8.7-2011.03/gems/actionpack-3.1.0.rc4/lib/action_dispatch/middleware/templates/rescues/routing_error.erb within rescues/layout (0.8ms)
cache: [GET /images/down_logo.jpg] miss

Started GET "/images/down_logo.jpg" for 127.0.0.1 at Mon Jul 25 14:21:35 +0800 2011

ActionController::RoutingError (No route matches [GET] "/images/down_logo.jpg"):
{% endhighlight %}
  
用Thin, Mongrel, Webrick启动都是一样的结果。

解决方案
---------------------------------------
在Gemfile里注释掉其他Ruby的Webserver，只留一个，比如Thin。
