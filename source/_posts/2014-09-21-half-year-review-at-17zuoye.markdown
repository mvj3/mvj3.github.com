---
layout: post
title: "我在一起作业的半年回顾"
date: 2014-09-21 21:55
comments: true
categories: Review
---

去年年末经朋友介绍加入 17zuoye，算来也大半年多了，颇有收获，把做过的和想做的事情大概暂记如下。

## 开源项目

HTTPS://GITHUB.COM/17ZUOYE ，关于我的项目动态大部分都可以从 Github 得知，陆续做了十多个，应该算高产吧，不过没一个 star ，哈哈，应该是交流不足吧，像我这种内向型，又特别羞涩，和别人交流会消耗大量能量的人真的是个难事，会慢慢改善的。

直接列举吧，详细介绍就以后单独写文章了。项目具体功能都见测试吧，基本功能点都覆盖了，README 有些我偷懒了。

1. [etl_utils](https://github.com/mvj3/etl_utils) ETL实用工具库。打印进度，缓存，字符处理等等。
2. [model_cache](https://github.com/17zuoye/model_cache) 直接把 Model instance 持久化缓存到 Model 这个 Dict 里，支持 sqlite, shelve等存储格式, 当然也可以直接 memory 做测试。
3. [tfidf](https://github.com/17zuoye/tfidf) 常用的数据挖掘方法之一，这个实现核心功能就是加了缓存。
4. [phrase_recognizer](https://github.com/17zuoye/phrase_recognizer) 英文短语识别器，支持词形变化。也支持复杂点结构，比如 "tie...to...", "...weeks old", 运行效率还是不错的。
5. [fill_broken_words](https://github.com/17zuoye/fill_broken_words) 针对小学英语里选择把某些字母从答案里填回到破损的题目内容中的数据修复，各种组合算法，算是所有项目里算法复杂度最高的。没时间优化，可能方法包括对组合做下排序或贪婪算法等。
6. [region_unit_recognizer](https://github.com/17zuoye/region_unit_recognizer) 识别 带有省市区等地址的 企事业单位。
7. [split_block](https://github.com/17zuoye/split_block) 把英语文本按纯英语，纯符号，纯空格等分块，包含相关模块，好支持fill_broken_words, article_segment 等工作。
8. [article_segment](https://github.com/17zuoye/article_segment) 数据修复英语文本里带空格的单词，基于别人的库做的。

以上全是Python写的，虽然我之前做了近五年的Ruby项目。

## 新录题平台

临时加入该平台做了两月，负责前期前后端架构，说穿了也就是一个主程。

1. 数据存储在 MongoDB 里，基本是单表设计，但是业务分类很庞大，就是体力活。
2. 语言框架是 Python 里的 Flask ，插件丰富，从 Rails 直接转过来也不费劲。前期想转 Node.js ，不过被 CTO 劝住了，他应该是对的，项目复杂度不是这种初生生态系统可以控制的。
3. 前端采用的 Backbone.js ，复杂度堪比后端。顺手写了构造复杂表单编辑和查询的插件 [backbone.brick](https://github.com/mvj3/backbone.brick) ，以及在前端里处理嵌套参数访问的实用库 [normalize_nested_params](https://github.com/mvj3/normalize_nested_params) 。前者没时间整理，模版部分和业务耦合的紧。后者可以通过 bower 或 npm 安装。
4. 审核模块业务需求也是很复杂的，可能还要考虑到打回等异常处理。最初设计时过于理想化了，出于之前架构内省的思想，而且假设从前端业务划分来指导后端数据表设计。事实证明这是错的，中间绕了一个大弯，身心疲惫，最后想到老老实实记录每次详细操作解决了，并默认了整个系统在任何时候都可能出错。

## 题库排重

题库排重引擎 detdup 是在 17zuoye 的第一个大项目，各种算起来也花了快三个月吧。框架代码加测试 870 行，目前应用于小学和初高中题库平台。

前段时间做了一个内部技术分享，演讲稿在 https://speakerdeck.com/mvj3/detdup 。项目源码因为商业原因而暂时不能公开（所以也不准备写相关文章了），欢迎交流。

* 20150606 补记。源码地址在 https://github.com/17zuoye/detdup ，并通过 travis 测试。

## 知识点抽取

说起来做这块还真的是我近几年技术生涯顺利过渡来的结果，感谢连华老师对我的悉心指导。对于完全自学进入计算机行业的我，老师就是"互联网大学"，但是数据挖掘这个综合学科一直不得其门，虽然之前也写了 [statlysis](https://github.com/mvj3/statlysis) 统计分析框架，但是概率和线性代数等数学模型一直懵懵懂懂，现在只能说进步一点了吧。

主要结果就是完成了 textmulclassify 多标签抽取框架。算法模型基本来自于连华老师，还有俊晨和李恒。我只贡献了文本相似度，算是一个小优化。可能会开源。

## 想做的事情

1. spark, hadoop等生态系统。
2. 恶补概率，线性代数等数学。
3. 开源这个事业。
4. 看的书虽然多，但是还得把每本书吃得更透些。
5. ...

## 未来

谈未来多俗气啊，可是人都是越活越俗气，对外交流慢慢停了，每个周末基本和女友一起各种玩，也许就是朴树所言的"平凡之路"吧，可是在这个"屌丝"也当不起的年代里，"平凡"没有什么意义，一个人根本无法逃避，还是选择一直有底气地活下去吧。
