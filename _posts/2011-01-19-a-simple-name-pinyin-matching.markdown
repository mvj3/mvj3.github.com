---
layout: post
title: 一个简单的姓名拼音匹配
published: true
comments: true
date: 2011-01-19 22:32:00 +08:00
categories: [Algorithm, Ruby]
---

一个简单的姓名拼音匹配

姓名一般是由两三个汉字组成，选其顺序且连续的拼音缩略的组合就算匹配成功。

{% highlight ruby %}
# encoding: UTF-8

require 'chinese_pinyin'
@name = "成吉思汗"
pinyins = Pinyin.t(@name).split

# 把姓名生成对应的拼音数组
array = []
pinyins.each_with_index do |han, index|
  array[index] = []
  han.size.times {|num| array[index] << han[0..(num - 1)] }
end

as = []
array.size.times do |x|
  sub_array = []

  # 第一趟生成姓名拼音缩略的所有满足顺序且连续的组合
  array.each_with_index do |ele, i|
    ni = i + x
    sub_array << array[i..ni] if array[ni]
  end

  # 第二趟把每个组合各自归并
  sub_array.each do |arr|
    while arr.size > 1
      sub_as = []
      arr[0].each {|a1| arr[1].each {|a2| sub_as << ( a1 + a2 ) } }
      arr[0..1] = [sub_as]
    end
    as << arr
    puts arr.join(' ')
  end

end

as.flatten.join(',')
{% endhighlight %}

Ruby标准库里的abbr.rb是排除两个英文单词的共同缩略，见http://ruby-doc.org/stdlib/libdoc/abbrev/rdoc/classes/Abbrev.html
