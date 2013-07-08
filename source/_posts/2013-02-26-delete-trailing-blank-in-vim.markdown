---
layout: post
title: Vim删除行末空格
published: true
comments: true
date: 2013-02-26 12:17:53 +08:00
categories: [Vim, Tips]
---

在查看(View)模式下输入

```vim
:%s/\s\+$/g
```

其实也即是删除了整行都是空格字符的。
