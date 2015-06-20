---
layout: post
title: '如何查看git历史记录里的已删除文件的历史'
published: true
comments: true
date: 2013-01-09 11:42:25 +08:00
categories: [Git]
---

http://stackoverflow.com/questions/3197416/why-doesnt-git-log-foo-work-for-deleted-file-foo
```bash
git log --follow -- foo
```
