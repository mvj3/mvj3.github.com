---
layout: post
title: '个性域名正则表达式'
published: true
comments: true
date: 2013-01-23 16:35:34 +08:00
categories: [Ruby, Regexp]
---

老大提了个用单个正则表达式来匹配个性域名ID的需求，具体是：3-15个字符，可以用[a-z0-9_\-]字符，必须用数字或者字母开头，且不能是纯数字

让我们来分步化解
对于，3-15个字符，可以用[a-z0-9_\-]字符，稍微了解点正则表达式的同学马上就可以写出如下正则

{% highlight ruby linenos %}
/^[a-z0-9_\-]{3,15}$/i
{% endhighlight %}

让我们来再加一个条件，必须用数字或者字母开头
{% highlight ruby linenos %}
/^[0-9a-z][a-z0-9_\-]{2,14}$/i
{% endhighlight %}

最后一个条件是，且不能是纯数字。

最初我大概的想到是用 或(|) 来做，一个是数字开头，另一个是字母开头，剩余的是否纯数字在后面判断。但这剩余里还是会遇到判断在哪个位置里已经出现了字母的问题。所以这里就需要正则表达式里非匹配获取的功能了。


维基百科里给出的是 (?=pattern) ，它表示 匹配pattern但不获取匹配结果，也就是说这是一个非获取匹配，不进行存储供以后使用。这在使用或字符「(|)」来组合一个模式的各个部分是很有用。例如「industr(?:y|ies)」就是一个比「industry|industries」更简略的表达式。具体见 [http://zh.wikipedia.org/wiki/正则表达式](http://zh.wikipedia.org/wiki/正则表达式)

stackoverflow里有更通俗的例子 http://stackoverflow.com/questions/1559751/regex-to-make-sure-that-the-string-contains-at-least-one-lower-case-char-upper
{% highlight javascript linenos %}
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+$
A short explanation:
^                  // the start of the string
(?=.*[a-z])        // use positive look ahead to see if at least one lower case letter exists
(?=.*[A-Z])        // use positive look ahead to see if at least one upper case letter exists
(?=.*\d)           // use positive look ahead to see if at least one digit exists
(?=.*[_\W])        // use positive look ahead to see if at least one underscore or non-word character exists
.+                 // gobble up the entire string
$                  // the end of the string
{% endhighlight %}

这样我们就在 `/^[0-9a-z][a-z0-9_-]{2,14}$/i` 里再加上个 `(?=.*[a-z_\-])` 就可以匹配不是纯数字了
{% highlight ruby %}
@regexp = /^(?=.*[a-z_\-])[0-9a-z][a-z0-9_\-]{2,14}$/i

puts "合法测试"
%w[c11213311 mvj3 123mmmmm iceskysl 3_3].each do |str|
  puts "#{str}   =>   #{str.match(@regexp)}"
end

puts "\n"

puts "非法测试"
%w[123 12345 mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm _ssssss 你好].each do |str|
  puts "#{str}   =>   #{str.match(@regexp) || '没有匹配'}"
end
{% endhighlight %}


测试结果如下
{% highlight html %}
合法测试
c11213311   =>   c11213311
mvj3   =>   mvj3
123mmmmm   =>   123mmmmm
iceskysl   =>   iceskysl
3_3   =>   3_3

非法测试
123   =>   没有匹配
12345   =>   没有匹配
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm   =>   没有匹配
_ssssss   =>   没有匹配
你好   =>   没有匹配
{% endhighlight %}




Ruby-China上的讨论 http://ruby-china.org/topics/8383
-------------------------------------------
我景仰的大牛 @luikore 给出了易读版

{% highlight ruby %}
/\A
  (?=.*[a-z_\-])    # 不能全是数字
  [0-9a-z]          # 必须用数字或者字母开头
  [a-z0-9_\-]{2,14} # 3-15个字符，可以用[a-z0-9_\-]字符
\z/xi
{% endhighlight %}
