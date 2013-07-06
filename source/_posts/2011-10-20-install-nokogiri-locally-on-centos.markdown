---
layout: post
title: CentOS本地安装nokogiri
published: true
comments: true
date: 2011-10-20 16:45:09 +08:00
categories: [Ruby, nokogiri, CentOS]
---

帮同事在一台centos上安装nokogiri，记载如下：

系统信息：

```text
[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.18-194.el5 #1 SMP Fri Apr 2 14:58:14 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# cat /proc/version 
Linux version 2.6.18-194.el5 (mockbuild@builder10.centos.org) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)) #1 SMP Fri Apr 2 14:58:14 EDT 2010
```

卸载并重新安装nokogiri依赖的C库：

```bash
sudo yum remove -y libxml2-devel libxslt-devel
sudo yum install -y libxml2-devel libxslt-devel
```

最近rubygems.org的在amazon的代码库索引源访问极慢，无奈只能把本地安装过的gems压缩包全部拷上去
scp /usr/local/rvm/gems/ree-1.8.7-2011.03/cache/*gem root@host:~/gems/
然后在服务器上执行 sudo gem i nokogiri-1.5.0.gem  -l 即可

测试代码如下，nokogiri已能正常解析HTML了

```ruby
require 'rubygems'
%w[nokogiri open-uri].map &method(:require)
resp = open("http://www.douban.com").read
puts Nokogiri::HTML(resp).css("body .article .content")
```
