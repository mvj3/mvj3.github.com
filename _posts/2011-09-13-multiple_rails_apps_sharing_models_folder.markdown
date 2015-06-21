---
layout: post
title: 多个Rails项目共用app/models和Gemfile配置
published: true
comments: true
date: 2011-09-13 21:03:03 +08:00
categories: [Ruby, Rails]
---

时兴的用Rails做的Web2.0项目一般由桌面浏览器访问的网站，移动客户端的API接口，后台管理，和统计分析等构成。为了项目开发及维护的相对独立性，不可避免地想要拆分成多个子项目，当中不可避免的抽取一些公用代码库，app/models是占很大比例的，完全分开的话重复定义，模型关系校验等就够你悲催了="=。

可以考虑把其中一个项目作为基础库，封装成一个Gem。在lib目录下创建一个share_ws.rb文件，比如：
{% highlight ruby linenos %}
module Share
  ModelsPath  = File.dirname(File.expand_path(__FILE__)).sub('lib', 'app/models')
  LibPath     = File.dirname(File.expand_path(__FILE__)).sub('lib', 'app/lib')
end

Dir[File.join(Share::LibPath, '*rb')].map {|lib| require lib rescue nil }
{% endhighlight %}

这样你在其他项目的Gemfile里就可以像这样引用：
{% highlight ruby linenos %}
if `whoami`.strip == 'mvj3'
  gem 'ws', '1.0', :path => ENV['HOME'] + '/company/code/ws', :require => 'share_ws' # 方便本地开发调试
else
  gem 'ws', '1.0', :git => 'git@company.git.server:/data/git/share/ws.git', :require => 'share_ws'
end
{% endhighlight linenos %}
如果你对上面为什么要指定版本存在疑问，请移步 [Gemfile里引用没有gemspec的gem](http://mvj3.iteye.com/blogs/1096204)

然后在config/application.rb的配置里加上一句：
{% highlight ruby %}
config.autoload_paths << Share::ModelsPath
{% endhighlight %}


既然你看到这里了，想必也厌倦在多个子项目各自的Gemfile写上大同小异的gem包配置，基本情况是总会遇到某个库要依赖某些特定版本库的问题。不过对于大部分完全重复的配置，你大可以在Gemfile直接eval公共配置的Gemfile文件。
{% highlight ruby linenos %}
eval begin
  File.read(File.expand_path('../db/Gemfile', __FILE__)).split("\n").reject do |line|
    line.match(/mysql|thinking-sphinx|arel|delayed_job|sprockets|cache_fu|whenever/i)
  end.join("\n")
end
{% endhighlight %}
