---
layout: post
title: "为什么很多人理解不了 Max Howell 通不过白板编程面试"
date: 2015-06-22T19:52:01+08:00
categories: [Whiteboard Coding, Algorithm, Homebrew, ]
---

作为有类似遭遇的应聘者，我是非常支持 Max Howell 的。

### 为什么很多人理解不了 Max Howell 通不过白板编程面试

这个事件在国内也引起了很大讨论，各大社区都有，以下主要总结 [如何看待 Max Howell 被 Google 拒绝？]( http://www.zhihu.com/question/31202353?rf=31187043 ) 里的讨论，态度主要分为以下两派：
1. 大多是惊讶或者调侃大牛居然连这个算法里的基础题也做不出来，有讨论具体算法细节的，也有发明段子讽刺连面试官给你放水都还帮不了你。
2. 小部分人怀疑白板面试是否真的能很好的筛选人才，毕竟没有多少项目经验的做过算法功课的应届生也可以做到通过这种白板算法面试。 

很不幸的是，我并没有看到更多有分量的开源软件牛人（像 Max Howell 作出 Homebrew 这样巨作的，上了 Github 排行榜的）出来支持 Max Howell 的观点。这也说明了程序员的地位相对企业的地位而言是远不如的，更多聪明的人是选择了沉默，我也听说过[为什么优秀开发者进入Google后就不参与开源了](http://timyang.net/google/open-source/)。

我想这个是有本质原因的，那就是开发复杂且优雅的软件系统 和 在脑子里背下各种计算机科学的算法 是矛盾的。这不是说复杂且优雅的软件系统不需要算法，而是算法已经被工程化地内含在项目里了，项目和代码都是真实世界里存活的东西，而纯粹算法代码只是存活于阉割版（用的字符最精简）证明理论里的，只是被人们用于口头交流功而抽象出的逻辑沟通系统，但却不是用于真实业务代码的理解和修改之用的。不得不承认的是，真正能做出复杂且优雅的软件系统的人比例很少，我指的是写出真正流行的框架和语言的那些人，没错，就是你平时用的那些，所以别太指望有很多人真的能理解 Max Howell 为什么就通不过白板编程面试呢。举个有意思的例子，你会发现有名的开源软件写的代码，和通常算法里写的代码完全是两种路子，虽然从狭义的算法原理上看干的是同一件事，但是前者是富有层次的工程结构，而后者则强调把全部细节都放在脑子里直观地去一次性理解，所以这也是很多初中级程序员啃不下开源代码的原因。

在面试这种紧张(其他的还有考试和演出等）情况下 ，其考察的是肌肉记忆能力，而不是分析和创造能力。即使在面试中能写出完全正确的算法逻辑代码，那么对该人的程序创作能力也是有损伤的，所以白板编程面试是考察候选人能力的下策。

上策是考察过去项目经历，从而推断出其经验和学习能力；其次才是是通过一些实际或虚拟问题去考察。这两者都应该建立在双向沟通反馈上，才算的上是合格的面试。

最后补充一条信息，一年多前我也发过 “ [面试时候如何用 Ruby 写一个最短二分查找代码]( https://ruby-china.org/topics/16601 ) ” 文章来描述去某公司面试时的在算法流程上的失败。当时我是写 Ruby 的，面试官是写 Python 的。摘录文章最后一小段，“最后面试官总结我应用或Rails方面的经验比较多，但是算法不太行，他准备和CEO再讨论看看。于是我咨询他公司技术部有哪些算法工作，他提了一个数据排重，然后我说如果准确度不太要求的话，可以用bloomfilter进行过滤。但是他坚持这一轮面试结束了，于是只能出门和他道别了。”有讽刺意味的是，在我加入新公司半年里就用 Python （进入公司当天我就现学 Python 干了一个统计的活了）实现了 百万题库排重算法（相同题目因为各种原因导致进入题库后有微小差异）的开源框架，源码地址在 https://github.com/mvj3/detdup ，演讲稿在 https://speakerdeck.com/mvj3/detdup 。多说几句，目前我的工作内容大部分都是如何在 Hadoop 上实现离线业务模型，并自己在写了一个不错的 DAG 任务管理框架，地址在 https://github.com/17zuoye/luiti 。对 Hadoop 的上手时间基本等同于熟悉一个 Python 类库的时间，再继续上手 Spark, Storm 也是不在话下，而这恰恰是有些看上去熟悉算法的人不容易做到的。

### 关于 Invert Binary Tree 的技术讨论

首先是 [Invert Binary Tree] 的递归版本，虽然我之前从来没有做过这个程序，不过在  LintCode 上读了需求后，用 Python 第一次写就通过了，http://www.lintcode.com/submission/630731/ ，但是脑子里还是慢慢反应一下，甚至还不太自信。

其次是 [Invert Binary Tree] 的非递归版本，即是用栈实现的，我没想出来，主要想法是因为每个节点最多有两个子节点，是不是用数组来模拟索引啥的。因为不是实际想做的，所以和平时工作学习一样，直接搜索了，是用 Stack 实现，其他逻辑大概稍微复杂了一点。总之，凭我的经验，是需要一些时间来突然顿悟这个算法是怎么回事的，但是我知道过段时间我肯定忘了，所以就不想了。

最后是关于 Google 面试官考察的到底是不是  Invert Binary Tree，我看到 Max Howell 给某人的回复是 "min-max the tree, ascending to descending"，地址在 https://twitter.com/mxcl/status/608891015945170944 。这样听上去好像是要做个上下翻转，而不是左右翻转，这可能是 Max Howell 没说清问题，也可能就是本身问题描述就不是一下子能说清的，那么请考虑在如何实现时就需要去理顺更多细节，可想而知会更容易出错了。


### 傲娇的人只是对事情更认真而已

有些人说 Max Howell 是大牛，被考察一个简单的 Invert Binary Tree 太不上档次了。

对于这个问题，我首先强调的是，优秀是一种习惯，同样一个人的代码风格往往是一致的，更深一点理解，TA 解决问题的范式都已经形成了自己的一套经验体系。所以大牛去写一个算法，通常是工作中的，那么必然是考虑到各种和其他模块如何整合，API 是如何的形式，而自身的代码组织逻辑又是如何自恰。举个象棋或围棋的例子，虽然规则大家都懂（这个类比到算法的步骤），但是大师看布局的角度和一般人的是完全不同的（这个类比到有人觉得 Homebrew 没啥复杂技术，可是却不是一般人能做出来的），而且也不太好解释（要知道机器至今在围棋成绩上仍远远落后于人类水平）。所以突然把大牛放到一个陌生的工作模式里，即是换成教科书的算法步骤思维，并且是面试的场景，而且是短时间，做不出来是很正常很可以理解的事情。要知道真正一个算法整合到实际项目里是得花很长时间的，里面涉及到不断的反复构思和调整。

有些人说 Max Howell 傲娇了，但他其实已经做了算法面试准备了（A good thing that came out of it is, I *did* prepare, and actually I found a bunch of common algorithm problems a lot of fun. Will continue.  https://twitter.com/mxcl/status/608754975364276224 ）。而且大家得注意一个事实，工作多年的人去复习算法和训练专门用于测试的思维方式是有时间成本的，相对来说应届生的时间成本就少多了，专门做算法的人在此不谈（TA们的软件工程水平相比而言也是低一点的）。算法确实很有意思，这两年我也在提高，它仅仅是解决问题的关键之一，而且大部分场景下，刻意的教科书算法对于工程来说都不是关键的。

说一下我个人对编码面试的观点，我热于在实际工作中接受任何相关项目的挑战，但是我不想做无用的压抑的耍猴游戏（可能也和我不喜欢玩电子游戏有关）。


### 面试时气场不合是个关键问题

很多时候人都是相当情绪驱动的，我人生经验里有一个让我震惊的观点是，有些我认为是应该非常理性的人居然也很坦率地承认自己对这个问题就是感性的。Max Howell 的气质是偏艺术家型的（这里有他在 Github 的演讲视频 https://www.youtube.com/results?search_query=homebrew+max+howell ），我猜测 Google 的那个面试官是偏死板的工程型的。所以如果和面试官气场不和，我理解是主要是TA感受不到你在TA未来的控制（中性词）范围内。

我一直有个疑问，对于一些很有想法的人（理解 Max Howell 的个性看他个人主页的色彩设计就知道了 http://mxcl.github.io/ ），面试官在看到简历时，为何不直接拒绝呢。还有另一个可能性是，一个面试官去面试可能是别人要求去的。如果让对方来了，为何大家不和和气气好好沟通呢，面对一个可能是未来的同事，非得拿那些刁钻的题目来为难对方呢（举个人人努力一下都会做的算术题，比如 7*19 比 200*300 难多了，虽然同是两个数，而且前者数还小），工作应该是快乐和有激情的啊（有些人其实是在组织里很压抑的）。

举一个我认为相当侮辱人的程序员段子，美女来面试，连不会写 HelloWorld 都能过（所谓程序员鼓励师），长相不好看的来面试，一定得拿红黑树来压制。虽然大家都当是个笑话，可是也折射出一些潜在的不良价值观。我理解 culture fit 是个一直都存在的常见问题，但是我还是觉得工作能力优先，这样才不会劣币驱良币。有一个调查是全球盲人比例约为千分之五，而城市道路上基本都人性化的加上了盲道，从道德上来说，应该谴责强势雇主在性格上歧视应聘者，另外我也相信大多数人还是知趣的吧 ：）


### 其他一些关于面试的问题

我看到一篇看上去很好的文章 http://www.gayle.com/blog/2015/6/10/developer-interviews-are-broken-and-you-cant-fix-it ，主旨是讲面试流程无论如何改进，都是有缺陷的。我的想法是，这真的是典型的逻辑式废话，从各种利益权衡来证明现有的制度是合理的和没办法的，同时为了公平性而不能更改任何细节。

我唯一的想法是，很直观的，一个大牛活生生的站在你的面前和你善意地沟通，同样希望得到一些相互的尊重，而面试官却非得照着一个脆弱的流程，去让自己和大牛都去适应这个规范（虽然实际工作时大家都是很灵活的），让旁观者也是干着急啊。

有必要我可以逐条反驳文章里我认为不妥的意见。


---------------------------------------------

### 上文背后的一些事实注解:

事实就是 Max Howell 发表了一条 "Google: 90% of our engineers use the software you wrote (Homebrew), but you can’t invert a binary tree on a whiteboard so fuck off" 的推文，作为有强烈共鸣的作者我在事件发生几天后的周末(20150615)写作发表了以上文字。

文章发表在以下三个地址:

1. http://www.zhihu.com/question/31202353/answer/51304584
2. http://v2ex.com/t/198594
3. https://ruby-china.org/topics/25977#reply13

截至 20150622 止，知乎上这个问题的按赞同数排名的前三名回答获得赞同数分别是 520, 209, 202 个。

第一名是 调侃 + 相对保守的，再加上根据他后来的补充，"现在，我们要招好工程师，他可能不是一个伟大的程序员，但他可以和所有人处得来。如果一个牛逼工程师有其他的非技术问题，以至于同事们都不想和他共事，那么我们将无法培养一个好的团队，我们的业务也就无从扩张。"，我判断他其实正是会刷掉 Max Howell 的面试官的类型，也说明了在行业里占主要话语权的人的观点。

第二名是发了 LeetCode 刷题相关的，也算是制度流程的主力竞争者。

第三名是我这个回答，说明对于制度的态度，相当一部分人还是愿意保持思考和怀疑的。

这个问题回到社会意义上来说，有些人是依靠制度流程本身的，有些人是个人智慧影响集体智慧的，两者在一定程度上是不可调和的。同时制度流程其实也是由后者一段时期里的的胜利者制定的，这个话题涉及到管理学和社会学等相关复杂庞大的领域，目前我还没有能力去思考这些东西。

最后说点个人的其他收获，从行为数据来看，这次发表文章得到的赞和关注获得了我个人历史上前所未有的新高，这让我有信心去做一些编程领域里我认为非常有价值的一些事，比如我的 [Human 编程语言](http://human-lang.org) 。
