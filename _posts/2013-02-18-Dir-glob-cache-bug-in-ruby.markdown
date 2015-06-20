---
layout: post
title: 'Ruby的Dir.glob缓存BUG'
published: true
comments: true
date: 2013-02-18 10:56:07 +08:00
categories: [Ruby, Cache]
---

Ruby的Dir.glob('/your/absolute/path/*')有缓存bug，新文件并不会返回，改成FileUtils.chdir后在Dir.glob(pattern)解决
