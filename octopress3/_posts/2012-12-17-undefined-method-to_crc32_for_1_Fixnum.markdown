---
layout: post
title: 'undefined method to_crc32 for 1:Fixnum'
published: true
comments: true
date: 2012-12-17 11:21:29 +08:00
categories: [Sphinx, ActiveRecord]
---

预备知识
---------------------------
如果对条件选择做索引的话，sphinx采用的数据结构均为非字符类型，碰到字符字段，在ThinkingSphinx都被默认经CRC32转换成标识唯一整数。

解决过程
---------------------------
ThinkingSphinx需要对表名做一个CRC32转化，具体在 lib/thinking_sphinx/source/sql.rb 的 `crc_column` 方法。该方法里为了对继承表进行兼容，里面会判断Rails里约定的 `inheritance_column` 是否也在表字段里（代码为 `@model.column_names.include?(@model.inheritance_column)` ），如果有就把type字段也作为CRC32的参数。可是如果type为整数类型，那么它没有 `to_crc32` 方法，所以就报了undefined method `to_crc32' for 1:Fixnum 错误。

解决方案
---------------------------
给有整数type字段的model加一句 `self.inheritance_column = :_type`
