---
layout: post
title: 二分查找定位Rails文本日志
published: true
comments: true
date: 2011-09-17 15:21:54 +08:00
categories: [Ruby, Rails]
---

对网站作统计分析时，经常需要对各种文本日志定时进行解析抽取数据，因此有必要确定上次结束解析的位置。[logpos](http://github.com/mvj3/logpos)使用[二分法](http://en.wikipedia.org/wiki/Binary_search_algorithm)进行查找，具体用法如：
{% highlight ruby linenos %}
pos = Logpos.seek_pos_before log_path, (RptVerbPathParams.desc(:time).first.try(:time) || Time.at(0))
{% endhighlight %}
logpos是以Rails默认的日志格式来解析的，但是也可以自己定义一个时间解析器：
{% highlight ruby linenos %}
lg = Logpos.new
lg.time_parser = proc do |line|
  line.match(/^Started/) && TIME_PARSER_CLASS.parse(line.split(/for [0-9\.]* at /)[-1])
end
pos = lg.seek_pos_before log_path, time
{% endhighlight %}
Logpos接受的time_parser要求是一个Proc，返回是一个Time实例或nil，以便之后的比较。

我这边测试一个4G多的正常的Rails日志文件，对不同的时间点做测试，日志记录时间范围内的一般在10毫秒以下，范围外的在80毫秒以下。
