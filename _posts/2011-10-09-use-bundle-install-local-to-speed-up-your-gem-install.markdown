---
layout: post
title: bundle install --local 利用本地缓存来加速Gem安装
published: true
comments: true
date: 2011-10-09 16:04:00 +08:00
categories: [Ruby, Gemfile]
---

如果Gemfile所列出来的gem全在Gemfile.lock里，加上--local选项可以直接绕过 请求rubygems.org的gem列表，从而达到加速本地生成Gemfile.lock。
