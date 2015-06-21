---
layout: post
title: "How do I create stepstepstep gem"
date: 2013-07-13 16:41
comments: true
categories: [Rails, Rake, Algorithm]
---

A few months ago, I was writing a single page application about learning mobile development technology at http://learn.eoe.cn. This page contains lessons, a video, classes, teachers, students, reference material, question-to-answers, exams, chat messages, and their current all learning statuses and dependencies. In brief, there are fifteen steps to load this page, including privileges to judge, fourteen illegal `redirect_to` , etc. So I need to write a step dependencies management tool, like rake tasks.

At first, I thought maybe I could define several `proc`s in a single before_filter, but the execution context is really complicated. Then one day, I found action_jackson.gem, which was written by [Blake Taylor](https://github.com/blakefrost/action_jackson) two years ago. The core implementation of this gem is to define each action as a method, and at last call a class method `register_filters` to register all these methods as `before_filter` independently. Of course, they're ordered by the earlier declarations. This implementation is not elegant, but the idea is really awesome, it doesn't break Rails's rules.

Then I got a deep understanding of the Rails controllers filters's implementation mechanism. Maybe `skip_before_filter` helped. In each `step`, I insert it first, extract all the inserted steps by `skip_before_filter`, then sort them by TSort(a topological sorting algorithm provided by Ruby standard library), and at last append them again to before_filters. It works, and all rspecs are passed.

I renamed it from action_jackson to stepstepstep, because the DSL is only a `step` class method, which handles all the details. Most of the implementations were rewritten, and I added rspecs . Thanks Blake Taylor :)

The project homepage is http://github.com/eoecn/stepstepstep
