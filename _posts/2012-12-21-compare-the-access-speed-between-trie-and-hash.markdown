---
layout: post
title: 'Trie和Hash访问字符串性能比较'
published: true
comments: true
date: 2012-12-21 10:12:13  +08:00
categories: [Ruby, Trie, Hash, Performace]
---

摘自wikipedia的trie词条
----------------------------
在计算机科学中，trie，又称前缀树，是一种有序树，用于保存关联数组，其中的键通常是字符串。与二叉查找树不同，键不是直接保存在节点中，而是由节点在树中的位置决定。一个节点的所有子孙都有相同的前缀，也就是这个节点对应的字符串，而根节点对应空字符串。一般情况下，不是所有的节点都有对应的值，只有叶子节点和部分内部节点所对应的键才有相关的值。

摘自wikipedia的Hash词条
----------------------------
散列函数（或散列算法，英语：Hash Function）是一种从任何一种数据中创建小的数字“指纹”的方法。散列函数把消息或数据压缩成摘要，使得数据量变小，将数据的格式固定下来。该函数将数据打乱混合，重新创建一个叫做散列值的指纹。散列值通常用来代表一个短的随机字母和数字组成的字符串。好的散列函数在输入域中很少出现散列冲突。在散列表和数据处理中，不抑制冲突来区别数据，会使得数据库记录更难找到。

用同样的字符串数组来各自构造一万以上元素的Hash和Trie
----------------------------
{% highlight ruby %}
# gem dependencies: algorithms, nokogiri
%w[benchmark algorithms open-uri nokogiri].map &method(:require)

string_array_for_insert = Nokogiri(open('http://www.douban.com').read).text.split("\n").map(&:strip).uniq
string_array_for_insert = (string_array_for_insert*100).map {|i| i.split(//).shuffle.join }
hash = string_array_for_insert.inject({}) {|h, i| h[i] = rand(100000); h }
trie = Containers::Trie.new; string_array_for_insert.each {|i| trie[i] = rand(100000) }

Benchmark.bm(8) do |x|
  x.report("hash:") { string_array_for_insert.each {|i| hash[i] } }
  x.report("trie:") { string_array_for_insert.each {|i| trie[i] } }
end

=begin
               user     system      total        real
hash:      0.010000   0.000000   0.010000 (  0.007240)
trie:      0.490000   0.010000   0.500000 (  0.503553)
=end
{% endhighlight %}

由以上判断，Hash算法的O(1)远比Trie的O(m)快 (m为键的最大长度)，如非类搜索提示的字符串匹配等应用，一般的键值对采用Hash可以保证最快查找单个元素。
