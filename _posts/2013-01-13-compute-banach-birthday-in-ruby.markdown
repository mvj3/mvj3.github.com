---
layout: post
title: 'Intel面试题解答，算巴拿赫的出生年份'
published: true
comments: true
date: 2013-01-13 13:43:56 +08:00
categories: [Algorithm]
---

摘自soso问问
----------------------------------------
http://wenwen.soso.com/z/q148660327.htm
巴拿赫病故于1945年8月31日。他的出生年份恰好是他在世时某年年龄的平方，问:他是哪年出生的?这道看似很简单的数学问题，你能不能能快地解答呢? 

注意“巴拿赫病故于1945年8月31日”不要忽略后面的月份日期。比如我1989年4月出生的到了1991年3月我还不是二岁是一岁 但不可能比二岁大到了5月我就是一岁。所以在某一年人是有两个年龄的。在世的年龄可能是x或x-1。


Ruby版本解答
----------------------------------------
{% highlight ruby linenos %}
max_age = 150
begin_year = 1945-max_age
possible_birthyears = (0...max_age).map do |age|
  age1 = age; age2 = age+1
  birthyear1 = age1*age1; birthyear2 = age1*age2
  [birthyear1, birthyear2].select {|by| (by > begin_year) && (by < 1945) }
end.flatten
possible_birthyears.flatten.each do |by|
  puts "banach born in #{by}, lived #{1945-by} years, and died in 1945."
end

# banach born in 1806, lived 139 years, and died in 1945.
# banach born in 1849, lived 96 years, and died in 1945.
# banach born in 1892, lived 53 years, and died in 1945.
# banach born in 1936, lived 9 years, and died in 1945.
{% endhighlight %}


关于巴拿赫
----------------------------------------
最后维基百科给出的解是：斯特凡·巴拿赫（Stefan Banach，1892年3月30日－1945年8月31日），波兰数学家。

[http://zh.wikipedia.org/zh-cn/斯特凡·巴拿赫](http://zh.wikipedia.org/zh-cn/斯特凡·巴拿赫)
