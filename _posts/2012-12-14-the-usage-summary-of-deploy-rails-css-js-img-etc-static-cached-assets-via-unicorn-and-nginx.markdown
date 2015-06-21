---
layout: post
title: 'Unicorn 和 Nginx 部署Rails应用的 css, js, img 等静态资源缓存使用总结'
published: true
comments: true
date: 2012-12-14 09:41:54 +08:00
categories: [Nginx, Unicorn, Cache]
---

nginx方案
------------------------------------------
接上文 [Rails动态文件添加ETag缓存](https://gist.github.com/4174674) 来自动生成304 Not Modified告诉客户端来直接使用本地缓存，但是在这种情况下会出现图片闪动（重新加载渲染），影响用户体验。除了Etag这种通过和服务器进行HTTP头部比对来实现缓存的策略外，还可以采用Cache-control来通知浏览器在一段时间内不必重新请求服务器而直接本地缓存。配置 nginx.conf 如下:

{% highlight nginx linenos %}
# 使用root用户来避免文件权限问题而导致403错误
user  root nginx;

# 在server { } 里加入Cache-Control声明
location ~ ^/(assets)/  {
  gzip_static on;
  expires     1h;
  add_header  Cache-Control public;
}
{% endhighlight %}

配置 config/environments/production.rb 如下:
{% highlight ruby linenos %}
# Disable Rails's static asset server (Apache or nginx will already do this)
config.serve_static_assets = false
# Compress JavaScripts and CSS
config.assets.compress = true
# Don't fallback to assets pipeline if a precompiled asset is missed
config.assets.compile = true
# Generate digests for assets URLs
config.assets.digest = true
# 指定需要预先编译的css和js
config.assets.precompile += %w[js css].map {|ext| Dir[Rails.root.join("app/assets/*/*.#{ext}")] }.flatten.map {|f| f.split('/')[-1] }
{% endhighlight %}

每次重新部署前运行RAILS_ENV=production bundle exec rake assets:precompile 来重新生成静态资源缓存


Rack方案
------------------------------------------
https://github.com/mvj3/rack_image_assets_cache_control/
