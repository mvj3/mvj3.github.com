---
layout: post
title: redis和memcached初始化内存比较
published: true
comments: true
date: 2011-12-19 16:45:09 +08:00
categories: [redis, memcached, IO]
---

```text
$ redis-stat 
------- data ------ --------------------- load -------------------- - child -
keys       mem      clients blocked requests            connections          
3          1.30M    1       0       150000 (+150000)    751         
3          1.30M    1       0       150001 (+1)         751         
3          1.30M    1       0       150002 (+1)         751       

$ ps -ef | grep memc
  501 28585     1   0   0:00.00 ??         0:00.00 memcached -d
  501 28596 15675   0   0:00.00 ttys010    0:00.00 grep memc
$ vmmap 28585 | tail -n 2
DefaultMallocZone_0x100065000      18.0M        179      1235K      6%
```

redis默认比memcachd低多了
