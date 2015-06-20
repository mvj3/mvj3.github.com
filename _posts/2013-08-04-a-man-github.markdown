---
layout: post
title: '一个人的"github"'
date: 2013-08-04 09:20
published: true
comments: true
categories: ["Rails", "Single Page Application"]
---

Github不是一个人做的，三个核心创始人在创业时都是写代码的，其中两个人作为程序员也十分有名，是不少有名开源项目的作者。对比这个星球上其他伟大的IT公司，Github网站的代码是能开源就尽量开源的，包括操作Git的grit，用作消息队列的resque，等。Github自然不是我做的，但作为一个自诩有好品味的程序员，我在努力向Github学习和实践它的精神和有益的工作方式，我要构建一个自己的"github"，在此也感谢我所处的公司 eoe 能给我自己去选择技术架构和工作进度这样相对灵活的工作方式的机会。

缘起
--------------------------------------------
今年上半年我的主要工作内容是负责一个专注在线学习编程的单页面应用网站的技术部分。从缘起来说，eoe本身主要是做以Android为主的移动开发者服务的，应用市场，移动应用SDK统计，开发者大会活动等都有涉猎，正式的尝试进入IT培训从去年2012年中就开始了（当然想法会更早些）。

当时CEO @靳岩 让我调研公司进入类似 codecademy.com 在线编程领域方案的可能性，这对于当时刚做完[优亿市场应用海量下载统计分析](http://mvj3.github.io/2012/11/01/android_eoemarket_data_collect_and_analysis_system_summary) 的算法与数据挖掘工程师无疑是一个很刺激的技术点。codecademy, codeschool 等这些国外在线编程网站毫无意外的展示了他们的创新性，codecademy 既支持JavaScript, HTML, CSS这些浏览器本身就提供编程环境的技术，也提供相对初级的Ruby, Python等后端语言在浏览器的模拟实现，他们用的相关技术包括用LLVM把代码编译成JavaScript执行的编译器Emscripten。codeschool里有个 [很有意思的地方](http://code.eoe.cn/67) 就是，它支持在浏览器里按照他们的规则去用Objective-C写iOS程序，编译是在服务器进行的，并通过base64编码不断传回截图，然后模拟成仿佛浏览器真的成了完美的IDE一样，包括编译信息和出错栈。 对于我们要实现在浏览器里用Java编写Android程序，一般方案是采用传送到服务器编译执行，但是这样涉及到复杂的沙盒模型，且对服务器端资源消耗过大。我知道有一家真的实现了，他们前端用的是flash技术，但是这个只能针对简单快速编译的项目，而且我觉得这个脱离了要教会对方学习的本质，因为以后的实际演练肯定是在Eclipse等IDE里进行的，而你的浏览器在现有技术情况下肯定无法全部模拟。后来我也想到了可以以IDE插件的形式解决把线下教学搬到线上的基本构思，技术难度降低一半，这是后话。在教学中三环节 `教问练` 中，真正把教和练做好的公司大概就这几家了，问的话去是程序员都上的stackoverflow等网站就好了。

去年下半年做了偏前端的 [技能测评](http://skill.eoe.cn)，和偏后端的 [gist.github.com 克隆网站](http://code.eoe.cn) 。前者算基本没用过，后者不温不火，这让我明白了一个道理，如果我仅仅沉迷于技术实现，自己却无法分身去从事数种自己不熟悉或不太愿意实际执行的工作，那么它的命运就完全取决于组织的决定，因为一个真实产品的成长它需要不同职责的人的参与。前段时间听 @teahour 的一期 [和knewone的李路聊聊技术和精益创业](http://teahour.fm/2013/07/15/lean-startup-with-knewone.html) 也聊到类似的情况，很有共鸣。

而公司在这半年也陆续做了些小规模的Android培训。今年2013春节后，正式开启线上教育项目，产品设计由 @iceskysl 主导和驱动，我开始做聊天技术的预演，内容运营部门则调动内外部资源继续制作教程内容。

研发
--------------------------------------------
单页面学习应用 learn.eoe.cn 和 报名支付宣传 xuexie.eoe.cn 及后台管理的整体开发上线共历时大概三四个月，我负责的是 learn.eoe.cn（一位前端同事负责写CSS），其他的都是php项目组负责实施。

当 @iceskysl 设计好产品基本原型后，确认学习过程中为单页面应用，因为里面的聊天，问答，考试等的一些操作应该是尽量避免重载页面的。我自告奋勇去设计了学习系统的数据库设计，基本思想上按模块做命名空间切分，课程大纲设计为一个课程包含多个课时，一个课时包含多个小节，小节可以为视频，资料，测评等多种类型，这是内容部分。对应的学生数据则是一个学习数据表绑定一个课程，并关联观看视频监控记录，考试记录，和计时等。这期间，项目组内关于数据结构，或者说课程具体的产品设计需求，经过多次讨论，终于达成思路上的一致。

以下是现在上线后测试服务器里学习页面的多个模块的截图。
![learn_video](/images/one-man-github/learn_video.png)
![learn_qa](/images/one-man-github/learn_qa.png)
![learn_exam](/images/one-man-github/learn_exam.png)


我对架构设计的原则是技术模块化，业务流程化，两者互相解耦。

### 业务流程化
对于一个学生来说，TA面对的主体是课程和TA的学习数据，其他都是依附于其之上。

对于内容管理人员来说，课程是标准的层级关联，视频和其他也只是依附于其之上。

对于我作为学习页面的技术负责人来说，用户是否付款和加入某个班级只是一个是非状态。用户的学习状态依赖于业务需求，可能需要结合多个数据源做操作判断，比如是否可以测评要保证你起码观看过教学视频及教学资料，是否学习完成也依赖于你对该课程所有课时的学习状态。

### 技术模块化
想清楚好以上清晰的业务流程骨架后，我开始本人4年技术生涯里最彻底的模块拆解，并开源出十多个模块。

**跨子域名用户登陆**，用的是PHP写的单点登陆解决方案UCenter，我整理了 @iceskysl 从PHP改写的Ruby代码，并[开源](https://github.com/eoecn/ucenter_authcode)出来。在应用时，有次遇到误把对方一个每次都变的cookies作为这边的唯一身份认证，这个在单域名操作体现不出来，而访问多个子域名后这边session就失效了。

**视频播放**用的 [VIDEO.JS](http://www.videojs.com) 框架，不需要太多配置代码。另外我想了个开源的[视频监控的方案](https://github.com/eoecn/videojs_user_track)，就是把用户对不同时间段的观看频次对应的以秒为单位的数组里，播放一次是1, 最大是9，以此观察视频具体效果，和单个学生的学习疑点。从最近遇到的一个BUG来看，浏览器缓存了视频，但是网络是随时可断的，导致某些网络不太稳定的用户的监控数据可能是部分缺失的。所以监控数据还是得与业务逻辑彻底分开的，前者只应该作为业务判断参考之一。（有人可能会提到放在cookie里，但是其最大长度是4K，那么一个小时的视频 `1*2*3600=7200` 就放不下了）。

**参考资料**用的是markdown编辑和渲染，我抽取了ruby-china的markdown渲染代码，并 [自动识别程序语言，文件名，别名等多种格式](https://github.com/eoecn/markdown-ruby-china)。

**问答讨论**是个太标准的CRUD应用，一个论坛无非是主题和回复，里面显示的用户名和头像其实都是可以在前端用JavaScript去组装的， [用Backbones这个Javascript MVC框架实现模版和事件绑定](http://mvj3.github.io/2013/05/28/fix-backbones-view-duplicated-events-bind/)  ，添加完数据表后，直接用一个Rails Helper配置下即可，我把它取名为 [qa-rails](https://github.com/eoecn/qa-rails) 。

**测评**是个相对独立的业务，鉴于去年做过差不多的，这次实现更加精炼了些，JavaScript 239行，HAML两个模版60行。这块限于业务特殊无法作到开源。

**班级讨论**是基于 [Faye消息订阅发布系统](https://github.com/faye/faye) 做的，并实现了 [在线用户显示和计时](https://github.com/eoecn/faye-online)，原理是绑定了Faye提供用户登入和登出的事件接口。 这里要特别感谢我们的一个女产品(条理清晰的黑盒测试)，是她用心的测试出了有这个用户的电脑非正常关闭浏览器造成服务器端一直在计时的错误。Faye 检测用户退出有两种方法，一种是服务器端的EventMachine定期检测client是否失去连接；另一种是客户端在浏览器关闭前发送disconnect请求(对应的配置选项是autodisconnect)，如果正常关闭那是ok的，但是如果用户取消关闭，那么这个faye client就死掉了，也就无法聊天，更新在线用户和计时。然后我想到了一种方案是，就是关闭autodisconnect，把这个事件改为发送让服务器三秒后才去检测这个client是否继续存活的请求，这样无论浏览器是否关掉，服务器 都照样主动检测。聊天室的弊端在于它的特点是需要中央服务器，无法支持过大的聊天室，这里暗示的一个信息是系统架构是可以按聊天室拆分做负载均衡的。

上面说的大部分都是从前端角度分析的，现在来说说后端。

随着项目不断迭代，我发现几乎大部分操作都直接绑定到用户学习状态表 LearnIssue 了，关联的课时和学习状态，每门课时对应的视频观看数据和考试信息都是代理过去，这样逻辑相对还是很清晰的。

在写单页面应用时，虽然像问答和聊天都独立出去用JavaScript载入了，但是还是需要同时载入几十个变量。[一般人都会反应为什么不整合到Model里去呢](http://ruby-china.org/topics/12477) ，原因是我还把十多个数据合法验证加入到Controller里去了，这里包括后台人员录入的数据不规范和用户访问权限等，出错方式是给出带参数说明的 `redirect_to` URL ，比如 `?reason=course_invalid` ，这样后台可以随时调整并在前端验证。在调整业务的时候，我经常要去调整变量位置，所以就写了类似rake步骤依赖的 [stepstepstep.gem](http://github.com/eoecn/stepstepstep) 去生成自动排序执行的14个before_filters，里面涉及一个图论算法。

这个项目一个很大的特色之一是对JSON的运用，比如学习状态，课程信息等。大部分是直接用 [json_record](https://github.com/bdurand/json_record/) 配置的，效果等同于MongoDB文档存储（当然副作用是不能直接用SQL做字段本身的操作了），但是运维只需面对MySQL即可。我把项目设计成基本都是单表操作，现在一个学习页面的载入包含着近50条SQL查询，而响应时间却都还在300ms左右。

最后为了给大家一个相对直观的项目复杂度的理解，我运行 `bundle exec rake stats` 对Ruby源码情况做了简单统计，并对比由牛人 @huacnlee 主导开发的 Ruby China专业社区论坛。

{% highlight html %}
learn.eoe.cn
+----------------------+-------+-------+---------+---------+-----+-------+
| Name                 | Lines |   LOC | Classes | Methods | M/C | LOC/M |
+----------------------+-------+-------+---------+---------+-----+-------+
| Controllers          |   558 |   356 |       9 |      24 |   2 |    12 |
| Helpers              |    26 |    19 |       0 |       4 |   0 |     2 |
| Models               |   690 |   529 |      17 |      54 |   3 |     7 |
| Libraries            |   114 |    86 |       1 |       2 |   2 |    41 |
| Integration tests    |     0 |     0 |       0 |       0 |   0 |     0 |
| Functional tests     |    11 |     6 |       2 |       0 |   0 |     0 |
| Unit tests           |     8 |     6 |       2 |       0 |   0 |     0 |
+----------------------+-------+-------+---------+---------+-----+-------+
| Total                |  1407 |  1002 |      31 |      84 |   2 |     9 |
+----------------------+-------+-------+---------+---------+-----+-------+
  Code LOC: 990     Test LOC: 12     Code to Test Ratio: 1:0.0

ruby-china
+----------------------+-------+-------+---------+---------+-----+-------+
| Name                 | Lines |   LOC | Classes | Methods | M/C | LOC/M |
+----------------------+-------+-------+---------+---------+-----+-------+
| Controllers          |  1587 |  1251 |      32 |     182 |   5 |     4 |
| Helpers              |   365 |   301 |       0 |      41 |   0 |     5 |
| Models               |  1542 |  1166 |      24 |     106 |   4 |     9 |
| Mailers              |    18 |    15 |       2 |       1 |   0 |    13 |
| Javascripts          |  6908 |  5006 |       1 |     546 | 546 |     7 |
| Libraries            |   552 |   411 |       6 |      41 |   6 |     8 |
| Api specs            |   171 |   148 |       0 |       2 |   0 |    72 |
| Cell specs           |   127 |   106 |       0 |       0 |   0 |     0 |
| Controller specs     |   678 |   572 |       0 |       0 |   0 |     0 |
| Helper specs         |   364 |   290 |       0 |       0 |   0 |     0 |
| Lib specs            |   229 |   173 |       0 |       0 |   0 |     0 |
| Model specs          |  1034 |   859 |       3 |       0 |   0 |     0 |
| Request specs        |    40 |    33 |       0 |       0 |   0 |     0 |
| Routing specs        |    58 |    43 |       0 |       0 |   0 |     0 |
| View specs           |    34 |    26 |       0 |       0 |   0 |     0 |
+----------------------+-------+-------+---------+---------+-----+-------+
| Total                | 13707 | 10400 |      68 |     919 |  13 |     9 |
+----------------------+-------+-------+---------+---------+-----+-------+
  Code LOC: 8150     Test LOC: 2250     Code to Test Ratio: 1:0.3
{% endhighlight %}

假设代码质量和风格差不多的话，从代码量来说 learn.eoe.cn 主体Ruby部分的复杂度是 ruby-china.org 的三分之一 （从Models和Controllers占比来说也是差不多的），对于一个单页应用来说这差不多了。唯一的区别是learn.eoe.cn的控制器方法行数比ruby-china.org大三倍，这和业务逻辑更加复杂有关。（Ruby China得排除基本都是外部静态js的这6908行统计数据。）

另外上午我写了一段Ruby脚本来统计 [learn.eoe.cn Rails项目及其开源项目源码行数](https://gist.github.com/mvj3/6149713) ，结果为：
{% highlight html %}
[rails_engine_eoe]  Ruby:884 | JavaScript:15 | HAML:0
[ucenter_authcode]  Ruby:78 | JavaScript:0 | HAML:0
[rack_image_assets_cache_control]  Ruby:28 | JavaScript:0 | HAML:0
[faye-online]  Ruby:678 | JavaScript:52 | HAML:0
[qa-rails]  Ruby:259 | JavaScript:280 | HAML:183
[videojs_user_track]  Ruby:140 | JavaScript:84 | HAML:0
[stepstepstep]  Ruby:271 | JavaScript:0 | HAML:0
[cross_time_calculation]  Ruby:143 | JavaScript:0 | HAML:0
[/Users/mvj3/eoemobile/code/learn]  Ruby:4113 | JavaScript:1108 | HAML:517

[total] Ruby:6721 | JavaScript:1539 | HAML:700
{% endhighlight %}
可以看到Ruby和JavaScript有三分之一左右是开源的，Ruby更多些。另外一个数据是git提交日志,  `1,347 commits / 21,477 ++ / 12,354 --` 。

这项目最大的遗憾就是没有测试，和互联网创业产品风格及资源配备等都很有关系，不过抽取的外部库比较重要或重逻辑的地方都写了必要的测试了。

注明: 本文仅代表个人观点，与实际所涉公司无关。
