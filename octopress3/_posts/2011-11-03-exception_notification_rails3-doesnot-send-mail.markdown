---
layout: post
title: exception_notification_rails3没有发邮件
published: true
comments: true
date: 2011-11-03 16:45:09 +08:00
categories: [Ruby, Mail, Gem]
---

Rails项目里同事发现配置的 exception_notification_rails3 没有正常的发出异常错误邮件

对比了下我这边正常的配置，把config.middleware.use ExceptionNotifier 放到config/application.rb里最后就可以了，虽然没有从源码里看出问题来 = =
