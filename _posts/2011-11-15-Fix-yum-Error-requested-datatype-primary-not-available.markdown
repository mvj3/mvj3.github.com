---
layout: post
title: '解决yum错误Error: requested datatype primary not available'
published: true
comments: true
date: 2011-11-15 16:45:09 +08:00
categories: [CentOS, yum]
---


服务器信息
-----------------------------------

{% highlight bash linenos %}
[mvj3@sdk2 ~]$ cat /proc/version
Linux version 2.6.18-194.el5 (mockbuild@ca-build10.us.oracle.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)) #1 SMP Mon Mar 29 22:10:29 EDT 2010
{% endhighlight %}

出错信息
-----------------------------------
{% highlight bash linenos %}
[mvj3@sdk2 ~]$ sudo yum install gettext-devel httpd-devel openssl-devel zlib-devel gcc gcc-c++ curl-devel expat-devel gettext-devel mysql-server mysql-devel libevent-devel mysql-devel mysql pcre pcre-devel libxml2-devel sqlite-devel ruby-devel -y
Loaded plugins: security
Error: requested datatype primary not available
[mvj3@sdk2 ~]$ sudo yum upgrade
Loaded plugins: security
Error: requested datatype primary not available
{% endhighlight %}

解决方案
-----------------------------------
{% highlight bash linenos %}
[mvj3@sdk2 ~]$ sudo yum clean all
Loaded plugins: security
Cleaning up Everything
[mvj3@sdk2 ~]$ sudo rpm --rebuilddb
{% endhighlight %}
