---
layout: post
title: 'Rails Route配置多个点的参数'
published: true
comments: true
date: 2012-12-19 12:49:00 +08:00
categories: [Rails, Routing]
---

代码分享里要对动态的资源文件做路由匹配，设置路由为

```ruby
match "/code/:gist_id/:tree_sha/blob/:blob_sha/:filename" => "code#file", :via => :get 
```

但是它却无法对像 /code/18/9877da148810c9d8bb5691772fda5488302259b6/blob/9084c88ef62c2566c315d3c4ff6e157146f4bfb4/测试点号.Android_开发中使用_SQLite_数据库.pdf  包含多个点号的URL做匹配，抛出了ActionController::RoutingError (No route matches 的异常。

google到一个解决方案 http://x3ro.de/rails-3-routing-parameters-dots/ , 使用constraints参数去对特点的URL做正则匹配。比如 `match "/foo/:search", :constraints => { :search => /[^\/]*/ }`  会对URL最后非 / 字符串做全部匹配。

Rails官方文档见 http://edgeguides.rubyonrails.org/routing.html#segment-constraints
