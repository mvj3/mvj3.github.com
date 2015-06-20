---
layout: post
title: Mongodb删除重复数据
published: true
comments: true
date: 2011-11-03 16:49:38 +08:00
categories: [Mongodb, Index, Statistical]
---

统计分析需要跑各个时间粒度的任务，如果异常中断后重新选择某个时间删除后再跑的时候，有时候还是会有重复的统计数据。

在mongodb中建立唯一索引时加上dropDups选项可以解决此问题：

A unique index cannot be created on a key that has pre-existing duplicate values. If you would like to create the index anyway, keeping the first document the database indexes and deleting all subsequent documents that have duplicate values, add the dropDups option

http://www.mongodb.org/display/DOCS/indexes#Indexes-dropDups 

Mongoid对应的参数配置是 , :unique => true, :background => true, :dropDups => true
