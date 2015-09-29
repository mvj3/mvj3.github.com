---
layout: default
---


<style>
p { /* introduction */
  font-size: 20px;
}
h2 { /* sub section */
  margin-top: 40px;
}

p ol li a {
  font-size: 16px;
}
</style>

### **David Chen** (陈大伟), aka **@mvj3** .

I'm an avid open-source full-stack engineer, focusing on [data][6] and [web][7],
and have created an offline task management framework called [luiti][8].

<p align="center">
  <!-- ![mvj3_wear_sunglasses](/images/mvj3/mvj3_wear_sungclasses.jpg){: height='360px' width='480px'}" -->
  <img src="/images/mvj3/mvj3_wear_sungclasses_20150526.jpg" alt="mvj3_wear_sunglasses_20150526" height="360px" width="480px">
</p>


Recommended posts
------------------------------------------------
1. [为什么很多人理解不了 Max Howell 通不过白板编程面试][9]
2. [我在一起作业的半年回顾][10]
3. [Rails项目 重构，我在阳光书屋的三个月][11]
4. [人类思维和软件工程学][12]
5. [一个人的"github"][13]


Recent posts
------------------------------------------------
...


Presentations
------------------------------------------------
* 2015-09-12, [Python Conf China 2015 Shanghai][21], Use Luiti to build a data warehouse, [view][22], [download][23]
* 2015-07-18, [Python沙龙深度交流会-第二十期CDA俱乐部活动][3], Luiti - An Offline Task Management Framework, [view][4], [download][2], [video][20]
* 2014-08-24, Internal sharing at 17zuoye, Detdup - Detect duplicated items engine, [view][5], [download][1]
* 2013-06-22, Ruby Saturday in Beijing, [15 gems within two years](http://ruby-china.org/topics/11806)
* 2012-09-01, Ruby Saturday in Beijing, [Statistical Analysis and The Dark Knight](/statistics-analytics-and-dark-knight)

Open Source
------------------------------------------------
See the timesheet and details at [projects](/projects/), related topics are:

1. Building the data warehouse in Python
2. Text mining in Python
3. Offline job in Ruby
4. Rails engines and ORM plugins

Technology Focus
------------------------------------------------
* Programming Language: **[Python][6]**, **[Ruby][7]**, **[JavaScript][14]**, Java, CSS, Objective-C, etc.
* Big Data: HDFS, YARN, **[luigi, luiti][8]**, hue
* Experience: **[modular][8]  [data warehouse][15]**, **[modular single page application][13]**, **[DSL or framework design and implement][17]**, [Text Mining][26], RESTful API, CMS, [realtime chat][16], etc.
* Web Framework: **[Rails][7]**, HAML, jQuery, [Backbone][19], [React.js][18], Bootstrap
* Software: Git, Nginx, Unicorn, Memcached, Sphinx
* Databases: [**Mongodb**, MySQL][17], [Redis][16]
* Editor: MacVim
* Operating Systems: OS X, Linux(CentOS, Ubuntu)

Human Programming Language
------------------------------------------------
Programming language's final aim is to reduce the complexity, and should be understood quickly in people's mind,
so it should be a combinenable, well-structured, introspective language.
`3.weeks.ago.` is a typical statement in Human programming language, and
it's equal to `((3 weeks) ago)` weird format in Lisp.

I wrote lots of Chinese notes (a unified philosophy about the nature of the program and human-mind) at [http://human-lang.org][24] , see more code examples at [https://github.com/human-lang/examples][25] .
The language specifications and interpreter are need to be done in future.


Education
------------------------------------------------
Communication Engineering major, Ningbo Institute of Technology, Zhejiang University (2005-2006)


Philosophy
------------------------------------------------
<!--
The slave of material, the servant of fashion, the king of the inner, and the God of art.

Chinese version: 物质的奴隶，时尚的仆人，内在的国王，艺术的上帝。
-->

I strongly believe that intuition is more important than logic.


Languages
------------------------------------------------
Chinese, English.


[1]: https://github.com/mvj3/mvj3.github.io/raw/master/pdfs/detdup%20-%20Detect%20duplicated%20items%20engine.pdf
[2]: https://github.com/mvj3/mvj3.github.io/raw/master/pdfs/Luiti%20-%20An%20Offline%20Task%20Management%20Framework.pdf
[3]: http://bbs.pinggu.org/thread-3815359-1-1.html
[4]: https://speakerdeck.com/mvj3/luiti-an-offline-task-management-framework
[5]: https://speakerdeck.com/mvj3/detdup-detect-duplicated-items-engine
[6]: /projects/#building-the-data-warehouse-in-python-07-2014-present-
[7]: /projects/#rails-engine-or-related-05-2013-12-2013-
[8]:  https://luiti.github.io
[9]: /2015/06/22/why-most-of-people-cant-understand-Max-Howell-cant-pass-whiteboard-coding-test
[10]: /2014/09/21/half-year-review-at-17zuoye
[11]: /2013/12/16/refectoring-code-at-sunshine-library-in-three-months
[12]: /2013/12/15/human-mind-and-software-engineering
[13]: /2013/08/04/a-man-github
[14]: /projects/#some-javascript-stuffs-03-2014-05-2015-
[15]: /projects/#offline-job-in-ruby-08-2011-12-2013-
[16]: https://github.com/mvj3/faye-online
[17]: https://github.com/mvj3/statlysis
[18]: https://github.com/Luiti/luiti/tree/master/luiti/webui
[19]: https://github.com/eoecn/qa-rails/blob/eoecn/app/assets/javascripts/qa-rails.js#L30
[20]: http://v.youku.com/v_show/id_XMTI5MjE1MTA4NA==.html?f=25942084
[21]: http://cn.pycon.org/2015/shanghai.html
[22]: http://luiti.github.io/talks/Python-Conf-2015-Shanghai.html
[23]: https://github.com/Luiti/luiti.github.io/raw/master/talks/Luiti-Python-China-2015.pdf
[24]: http://human-lang.org
[25]: https://github.com/human-lang/examples
[26]: /projects/#text-mining-in-python-06-2014-05-2015-



<script src="{{ "/bower_components/underscore/underscore-min.js" | prepend: site.baseurl }}" type="text/javascript"></script>

<script>
$(document).ready(function() {
  // render recent posts.
  var recent_posts_header = $("#recent-posts");
  var recent_posts_dom = recent_posts_header.next("p");

  var li_template = _.template(""
    + "<li>"
    + "  <a href='<%= link %>'><%= title %></a>"
    + "</li>"
  );
  var posts_template = function(posts) {
    var lis = _.map(posts, function(post) {
      return li_template(post);
    });
    return "<ol>"
      + lis.join("")
      + "</ol>";
  };

  $.ajax({
      type: "GET",
      url: "/feed.xml",
      dataType: "xml",
      success: function (xml) {
          console.log("[load posts xml]", xml);

          var posts = _.map($(xml).find("item"), function(item) {
            var item = $(item);
            return {
              "title": item.find("title").text(),
              "link":  item.find("link").text(),
            };
          });

          var recent_posts_str = posts_template(posts.slice(0, 5));
          recent_posts_dom.html(recent_posts_str);
      }
  });

  recent_posts_header.html(recent_posts_header.text() + "   <a href='/blog' style='font-size:14px;'>(See more ...)</a>");
});
</script>
