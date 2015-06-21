---
layout: post
title: '用C的sscanf和Ruby的正则表达式解析nginx日志性能对比'
published: true
comments: true
date: 2012-12-13 12:18:30 +08:00
categories: [Nginx, C, Ruby, Regexp]
---

{% highlight ruby linenos %}
require 'rubygems'
require 'inline'

class ParseLogInC
  inline do |builder|
    builder.c <<-CODE
      #include 'ruby.h'
      #include 'stdio.h'f
      static VALUE nginx(VALUE line) {
        VALUE ary = rb_ary_new();

        int lt = strlen(STR2CSTR(line));
        char ip_str[24], time_str[26], path[lt > 200 ? lt : 200], i1[4], i2[lt/4];
        sscanf(STR2CSTR(line), "%s - - [%s +0800] %s %s %s", ip_str, time_str, i1, path, i2);
        rb_ary_push(ary, rb_str_new2(ip_str));
        rb_ary_push(ary, rb_str_new2(time_str));
        rb_ary_push(ary, rb_str_new2(path));

        return ary;
      }
    CODE
  end
end

NginxLogRegexp = Regexp.new [
  '((?:\d+\.){3}\d+)', # ip
  '[\ -]*',
  '\[(.*?)\]', # [$time_local]
  '[\" ]*',
  '([A-Z]*) ', # HTTP verb
  '(.*)', # url
].join

@plc = ParseLogInC.new
[%q(123.159.55.238 - - [28/Aug/2012:00:02:11 +0800] "GET //app?id=26964&client_id=142&channel_id=350 HTTP/1.1" 302 0 "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" "-" ---- download.eoemarket.com),
    %q(113.108.11.51 - - [26/Sep/2012:11:12:46 +0800] "GET //app?id=96061&client_id=140&channel_id=319 HTTP/1.1" 302 0 "http://s.myapp.com/dw_stats.jsp?dt=0&sid=AevJEO5AXd56AEqHdh0oAIlG&sn=4&idx=0&siteId=4&apkid=154699&st=0&url=sHdmymPs30ZhvM4YgPxtls6Sl2gYu8dlvbX4xbgOYKjIcB7FqAKXQLATVWAKd0FGCdLEmN%2FB%2FD%2BF%0AtH7nT7X9TWHPqokJ5nFE2YCDnMBkFNM%3D&key=%E6%89%8B%E6%9C%BA%E6%89%93%E7%A2%9F%E6%9C%BA" "MQQBrowser/3.5/Adr (Linux; U; 2.3.6; zh-cn; HUAWEI U8661 Build/U8661V100R001C17B827;320*480)" "211.138.243.113" ---- download.eoemarket.com),
    %q(117.136.15.146 - - [26/Sep/2012:17:19:58 +0800] "GET /app?id=27034&client_id=12&channel_id=201&uniquely_code=333228032439999999990&w=480&dpi=240&sdk=15&brand=alps&product_id=MX9984K&model=e1809c_v75_gq1008_9p017&product=e1809c_v75_gq1008_9p017&locale=zh_CN&version_code=30&uniquely_code=359220438409074&channel_key=paU3GRB4hk9zOT3gmTTGA&api_key=jPo2Fs9C5a33c9TRNJTPxw&nonce=ef306825998be5dexeb1f6lv0a1b5fca49f8a99a&timestamp=1339080849896&api_sig=d7ew8f2fc5e90dc9e4e0899b7e87o896 HTTP/1.1" 404 3 "-" "Dalvik/1.6.0 (Linux; U; Android 4.0.3; e1809c_v75_gq1008_9p017 Build/IML74K)" "-" ---- download.eoemarket.com)
].each do |line|
  l1, l2 = line.split("HTTP/")
  t1 = Time.now; @plc.nginx(l1); puts "c #{(Time.now - t1).to_f*100*100}"
  t2 = Time.now; oa = l1.match(NginxLogRegexp).captures; ary = [oa[0], oa[1], oa[2]]; puts "r #{(Time.now - t2).to_f*100*100}"
end

__END__
c 0.14
r 0.37
c 0.04
r 0.1
c 0.05
r 1.42
{% endhighlight %}
