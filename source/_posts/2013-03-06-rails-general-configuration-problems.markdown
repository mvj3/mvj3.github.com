---
layout: post
title: Rails常见配置问题
published: true
comments: true
date: 2013-03-06 10:42:41 +08:00
categories: [Rails, assets, Gemfile]
---


提示已经安装的gem不在Gemfile里
----------------------------------------------------
最近有时遇到明明已经安装了rake，但是却提示我说有些gem没有在Gemfile里引用。比如：
Could not find rake-0.9.2.2 in any of the sources
Run 'bundle install' to install missing gems.

我所使用的Ruby版本管理环境是rvm，查看下rvm info，发现ruby路径和gem管理路径不一致，因此rvm reload一下就解决了该问题。

rvm不一致的问题还需要查下，推测可能是开启多个SHELL，导致设置不一致～



assets没有编译
----------------------------------------------------
需要显示指定路径，在config/environments/production.rb里加入
```ruby
config.assets.precompile += %w[*js *css]
```


development模式下刷新后静态资源不变
----------------------------------------------------
删除public/assets目录下的缓存文件，这样就走动态请求了。


修复rvm info里ruby版本不一致bug
----------------------------------------------------
在/etc/profile里加一行rvm reload

修复gem,irb等命令里老是提示ree某个版本的environment不存在
----------------------------------------------------
修改该命令里的ruby环境路径到自己指定的版本


修复默写外部css引用图片等静态资源不以/assets开头
----------------------------------------------------
把资源及其路径直接拷到/public目录下
