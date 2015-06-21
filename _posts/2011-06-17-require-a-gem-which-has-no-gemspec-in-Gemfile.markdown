---
layout: post
title: Gemfile里引用没有gemspec的gem
published: true
comments: true
date: 2011-06-17 11:10:00 +08:00
categories: [Ruby, Gemfile]
---

在Gemfile里引用一个没有gemspec的gem时，运行bundle install的时候会提示

{% highlight html linenos %}
Could not find gem 'mechanize (>= 0)' in git://github.com/mvj3/mechanize.git (at master).
Source does not contain any versions of 'mechanize (>= 0)'
{% endhighlight %}


解决方案: 指定gem的版本即可，如

{% highlight ruby linenos %}
gem 'mechanize', '2.0', :git => 'git://github.com/mvj3/mechanize.git'
{% endhighlight %}

参考：http://stackoverflow.com/questions/4971074/attemping-to-vendorize-a-gem-into-bundler-with-rails-3-but-gem-has-no-gemspec

{% highlight html linenos %}
I forgot to leave the version out on my Gem! Super important :

gem "spree_easy_contact", '1.0.2', :path => "#{File.expand_path(__FILE__)}/../vendor/gems/spree_easy_contact-1.0.2"
Also it was strange..this Gem also require honeypot-captcha, so I had to include that in my Gemfile. All is well.
{% endhighlight %}
