---
layout: post
title: CentOS上sqlite3版本兼容问题
published: true
comments: true
date: 2011-10-09 16:41:53 +08:00
categories: [CentOS, Sqlite3]
---

问题
--------------------------------
sqlite3-ruby的1.3版本在CentOS不兼容，访问数据库时报如下错误：

{% highlight bash %}
/usr/local/ruby/ruby-enterprise-1.8.7-2011.03/bin/ruby: symbol lookup error: /usr/local/ruby/ruby-enterprise-1.8.7-2011.03/lib/ruby/gems/1.8/gems/sqlite3-1.3.4/lib/sqlite3/sqlite3_native.so: undefined symbol: sqlite3_open_v2
{% endhighlight %}

解决方案
--------------------------------
退回到1.2.5版本， gem install sqlite3-ruby -v=1.2.5

服务器相关配置信息
--------------------------------
{% highlight bash %}
$ uname -a
Linux fx-40 2.6.18-274.el5 #1 SMP Fri Jul 22 04:43:29 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
$ rpm -qa | grep sqlite
sqlite-devel-3.3.6-5
sqlite-3.3.6-5
sqlite-3.3.6-5
python-sqlite-1.1.7-1.2.1
sqlite-devel-3.3.6-5
{% endhighlight %}

参考
---------------------------
* http://railsforum.com/viewtopic.php?id=39585
