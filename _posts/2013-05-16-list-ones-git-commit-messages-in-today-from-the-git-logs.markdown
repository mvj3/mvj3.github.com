---
layout: post
title: '从Git的Log里列出今天提交的代码记录信息'
published: true
comments: true
date: 2013-05-28 15:28:32 +08:00
categories: [Git]
---

{% highlight bash linenos %}
GIT_USERNAME=$(git config --global --get user.name);
git log --author $GIT_USERNAME --no-merges --after={1.day.ago} |\
       cat |\
       grep -v '^commit ' |\
       grep -v '^Author: ' |\
       grep -v '^Date: ' |\
       grep -v "^$" |\
       tail -r
{% endhighlight %}
