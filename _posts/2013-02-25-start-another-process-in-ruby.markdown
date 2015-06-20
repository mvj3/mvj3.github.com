---
layout: post
title: Ruby同时启动另一个进程
published: true
comments: true
date: 2013-02-25 14:33:51 +08:00
categories: [Ruby, Process]
---


比如自动启动faye服务器, from http://stackoverflow.com/questions/6430437/autorun-the-faye-server-when-i-start-the-rails-server

{% highlight ruby %}
Thread.new do
  system("bundle exec rackup faye.ru -s thin -E production")
end
{% endhighlight %}

如果是Rails/Rack，加入到项目根目录的config.ru，这样在执行console, rake, migration等其他操作时就不用启动这个进程了。
