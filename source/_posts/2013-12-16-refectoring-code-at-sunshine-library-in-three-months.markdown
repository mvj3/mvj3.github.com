---
layout: post
title: "Rails项目 重构，我在阳光书屋的三个月"
date: 2013-12-16 12:26
comments: true
published: true
categories: [Refactoring, Rails]
---

## 背景介绍

在 [阳光书屋的官网](http://www.sunshine-library.org) 上写着，“阳光书屋乡村信息教育化行动是一项公益教育计划，我们致力于用科技填补城乡教育鸿沟，以平板电脑为载体，让每一个农村的孩子都接触到优质的教育资源。” 学生和老师用的平板电脑学习机是基于Android移动开源系统的"晓书"，通过独立研发的阳光桌面OEM定制学习环境，并包含阳光电子书包和阳光学习提高班等App来开展混合式教学模式。

而支撑其后台的便是Ruby on Rails这套Web开发框架，到目前为止经历了三代架构的变迁。当我以Ruby架构师角色在八月底进入书屋时，随着秋季的开学，项目也在紧张地进行着包括新功能后期收尾，迁移到MongoDB数据库重构，和提高班数据系分析新系统 等工作。@renchaorevee 和 @Logicalmars 两位志愿开发者主要负责了测试相关的工作。

重构的事稍后再行一一细说，先简单的过一下前面两代。

## 第一代Rails架构

单独一个Rails程序，借用其中一个志愿开发者 @Logicalmars 的话说，就是"主要用Ruby on Rails写服务器后台。我们这开发人员不多，很多东西都得自己搞，我不光更加理解了RoR，还顺便学习了如何架设Rails的服务器，如何做MySQL Replication，如何向安卓端同步数据库Table等等"。

## 第二代Rails架构

随着业务的细化，需求逐渐被明朗细化为LocalServer和CloudServer两大块。

从网络层面上说，LocalServer搭在学校当地以提供快速的网络响应，CloudServer搭在阿里云上去管理协调各LocalServer，两者通过VPN串联起来位于同一网络中以保证信息的安全。

从业务层面上说，LocalServer提供的功能包括晓书的电子书包等API通讯，设备管理，教师备课和查看学生数据等。CloudServer提供的功能包括各LocalServer管理，提高班和App等公用资源的分发和中转，查看跨校统计数据等。这方面就不展开细说了，主要是为下面的技术和重构提供一些背景概念。

根据其分布式特点，采用了MongoDB数据库，在保留_id主键时同时使用了全局唯一的 [uuid](http://en.wikipedia.org/wiki/Universally_unique_identifier) 键作为CloudServer和众LocalServer的资源共享管理的依据。

等业务需求大概确定下来后，剩下来的就是如何用技术实现之，并可以适当的随着业务需求发生变动而更好的迭代之。

## 第二代Rails架构和第三代重构，如何挖坑和填坑

### 面临的挑战

在 [背景介绍] 的最后提到，我进入该项目时，已经处于紧张的项目上线期。简单的形容一下就是，

* 维护一个项目难，
* 维护一个二手项目难，
* 维护一个臃肿的二手项目更难，
* 维护一个开发中的臃肿的二手项目更难，
* 维护一个有紧急上线或BUG修复的开发中的臃肿的二手项目非常难。

完全展开按照线性叙事来讲就太琐碎了，为了给第三者理解上的方便，还是就以下几个重点来分享一下吧。

### Rails 拆分和合并

问题：

在第二代，书屋把Rails程序剥离为LocalServer和CloudServer两个Rails应用程序。代码物理上的分拆虽然带来了从业务去理解技术上的一些好处，但是冗余的问题随之而来，模型和视图上的占了多数，而这个同时保持两份修改显然不是明知之举。事实证明有些BUG确实是因为两边数据结构没有修改一致导致的，甚至有些相同的字段在两边都有不同的存储形式。

解答：

Local和Cloud合为一个Rails项目，代码或模块用全局变量判断载入。

1. 在 `config/initializers/constants.rb` 里建立全局变量，比如 `$IS_LOCAL_SERVER`, `$IS_CLOUD_SERVER` 等。
2. 公用的 `models` 按照Rails约定放在app/models目录下，各自环境的功能分别放在 `lib/models/local` 和 `lib/models/cloud` 目录下。载入过程在 `(Rails::Application).load_extend_model_features` 方法，分别可通过 Mongoid::Sunshine 模块 和 ApplicationController重载 实现动态载入。
3. routes, controller, views等还是按照Rails约定走，唯一区别是在代码里用全局变量判断载入。
4. 目前Production, Development, 以及部署模式已完全兼容Rails默认约定。

相关技术细节披露：

```ruby
# 定义Model功能依不同环境动态载入
def (Rails::Application).load_extend_model_features
  Dir[Rails.root.join("lib/models/#{LocalCloud.short_name}/*.rb")].each do |path|
    # load appended feature if the model already exists.
    next if not Object.constants.include?(path.match(/([a-z\_]*).rb/)[1].classify.to_sym)
    (Rails.env == 'production') ? require(path) : load(path)
  end
end if defined? Rails

# 配置最公用的Mongoid::Sunshine，直接替换默认的Mongoid::Document。
module Mongoid
  module Sunshine
    extend ActiveSupport::Concern
    included do
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mongoid::TouchParentsRecursively
      include Mongoid::Paranoia
      include Mongoid::UUIDGenerator
      include Mongoid::SyncWithDeserialization if $IS_LOCAL_SERVER
      include ActiveModel::IsLocalOrCloud
      include ActiveModel::AsJsonFilter
      include Mongoid::ManyOrManytomanySetter

      include Mongoid::DistributeTree if (not self.name.match(/ETL::/)) # 排除同步ETL
      include Mongoid::ChapterZipStyle if %W[Chapter Lesson Activity Material Problem ProblemChoice].include? self.name

      # autoload app/models/cloud|local/*.rb
      (Rails::Application).load_extend_model_features

      include Mongoid::OverwriteDefaultFeatures
    end
  end
end

# 在development模式下动态载入Model
class ApplicationController < ActionController::Base
  # load cloud and local features model exclusively
  before_filter do
    (Rails::Application).load_extend_model_features
  end if Rails.env != 'production'
end
```

要提一点的是，除了测试可以帮你解决重构是否无误的问题外，请活用 `git grep` 来分析相关的代码调用。

### 阳光电子书包的同步更新 自动策略

晓书上的电子书包是按 科目(1) <- 章节(n) <- 课时(n) 的组织结构去划分的，每种富媒体资源都是以文件夹形式挂载在最下面的课时节点上。一旦某课时发生变动，就更新自己级其上的章节和科目的时间戳。这样客户端可以定时请求LocalServer，依据时间戳去更新对应结构和数据（删除操作由结构树自己来管理更新）。

之前的解决方案由于文件夹的内容类型比较复杂，且在Controller和Model等多处都有操作，没有统一的分层机制，所以对于时间戳更新的遗漏难免。

对此我的解决方案是写了Mongoid的一个插件mongoid_touch_parents_recursively，它依赖Mongoid Model间的关系声明来在 `after_save` 钩子里更新，并解决了多对多和一对多等关系。具体原理请见 [实现文件描述](https://github.com/mvj3/mongoid_touch_parents_recursively/blob/sunshine/lib/mongoid_touch_parents_recursively.rb) 和 [README配置文档](https://github.com/mvj3/mongoid_touch_parents_recursively) 。

### 课程压缩包的内容优雅的解压缩

在线教育相比其他社交和电子商务等行业，多类型结构的课程数据包含了各种形式的文本，逻辑关联和多媒体文件等，因此提高班的产品owner @fxp 设计了基于JSON格式和文件目录的SchemeFolder来灵活管理课程数据。在导入后台过程中出现了解压缩相关处理代码和课程数据组织逻辑混淆的场面，给二次维护带来一些难解。

对此我在 [人类思维和软件工程学](http://mvj3.github.io/2013/12/15/human-mind-and-software-engineering/) 的 #框架之后# 一节中对这次重构的策略做了详细分析，抽取了[mongoid_unpack_paperclip](https://github.com/mvj3/mongoid_unpack_paperclip) 模块来给含有paperclip的Mongoid 支持解压缩包和清理的封装。只需要include Mongoid::Paperclip和Mongoid::UnpackPaperclip即可，然后调用 ` self.unpack_paperclip { ... } ` 去做对应的操作即可。

其中对Paperclip对象的获取是通过对 [Model自省](https://github.com/mvj3/mongoid_unpack_paperclip/blob/sunshine/lib/mongoid_unpack_paperclip.rb#L16) 获得的。

### JSON API 输出的定制

之前在面向移动客户端JSON API输出的开发时，有些API都是客户端按自己结构去定义的，而没有针对Model做RESTful输出，实现者用Helper方法对资源进行了递归描述，这样定义起来代码比较冗余和难以公用。限于客户端的设计，这部分只能按原来设计继续维护了。

在LocalServer和CloudServer都做了as_json的覆写，这里交叉公用了一些字段。因此写了 active_model_as_json_filter 来做类似`as_json` options 的配置，比如：

```ruby
class App
  self.as_json_options.except.add(:classroom_ids)
end
```

或者配置全局的属性配置，

```ruby
ActiveModel::AsJsonFilter.finalizer_proc = lambda do |result|
 result['id'] = result['uuid'] if result['uuid']
 return result
end
```

更多见 [active_model_as_json_filter](https://github.com/mvj3/active_model_as_json_filter) 开源项目主页描述。

### 元数据同步的数据类型兼容

CloudServer到LocalServer的数据同步是通过JSON API进行的，这个在上面的前两代Rails架构已经提到了。但是里面遇到的问题是因为MongoDB数据库是SchemeLess的，而且也没有很好的对时间类型做反序列化的支持。比如你给`checked_at`时间字段赋值`2013-11-22 15:43:04 +0800`，保存的还是String类型。

因为时间类型的字段不单单是只有`created_at`和`updated_at`两个Rails默认的字段名，还可能有其他比如上面提到的`checked_at`，如果全部手工定制也就一团乱了，所以最好方法是在配置field时候指定type为DateTime等类型，这样也就可以对Model通过自省来获得在`before_save`时要解析的字段值了。 具体实现见 [mongoid_sync_with_deserialization](https://github.com/mvj3/mongoid_sync_with_deserialization/blob/sunshine/lib/mongoid_sync_with_deserialization.rb#L35) 。

### Mongoid使用uuid字段进行Model关联

在 #第二代Rails架构# 提到，书屋的资源都是用uuid来标示唯一的，这个在ActiveRecord时期即是如此。

而迁移到MongoDB之后，由于它是为单collection设计优化的数据库，查询操作并没有像ActiveRecord那般对模型关系处理的成熟，（个人更建议用MySQL或含有NoSQL特性HStore的PostgreSQL)。

有个多对多关联数据保存的BUG，在_id主键存在情况下，通过另外一个uuid键来做多对多，而结果却是对方保存的_ids是uuid，而自己保存的_ids却是非期待的_id。仔细调查发现是Mongoid没有对这种特殊情况做 [深入兼容](https://github.com/mvj3/mongoid_many_or_many_to_many_setter/blob/sunshine/doc/mongoid.markdown) 。

因此我也写了 mongoid_many_or_many_to_many_setter 去利用Model之间关联关系自省在`before_save`时 [重新赋值](https://github.com/mvj3/mongoid_many_or_many_to_many_setter/blob/sunshine/lib/mongoid_many_or_many_to_many_setter.rb#L29) 。

### 同步机制的范式转移

进入书屋后，遇到的最大问题就是服务器间数据同步不一致，黑盒子，VPN内部因传输冗余媒体文件而导致网络堵塞。

之前采用的技术方案组合我觉得更多是从技术层面去混搭，很明显这个犯了过度追求自己不能很好掌控的新技术，和对本身业务理解不深刻的错误。一想到多服务器高性能分发，就用了RabbitMQ的分发订阅，但是却忽略了最大的瓶颈其实在于媒体文件的传输。一想到文件传输，就用了支持异步多并发的NodeJS框架，和前者一样，本质在网络带宽限制上，以及细力度操作。更多见 [同步架构变迁历史概述](https://github.com/mvj3/distribute_tree#同步架构变迁历史概述) 。

让我们梳理数据同步的本质，从数据量和业务上考虑，可以分为，一是树的同步，二是叶子上的多媒体数据同步。

树的同步就是JSON元数据的同步，这是飞快的。不过它分为两种同步模式，第一种是自动同步，即在CloudServer对数据进行了CRUD后，都要马上反映到各个被要求同步的LocalServer那里去。这里有些LocalServer可能由于业务或网络问题是不需要同步的，所以得有个管理同步服务器的功能。第二种同步是手工同步，比如新增一个学校，或者一个学校因为某种原因中途中断了同步，而现在要继续同步，那么就要单独对它进行同步。从业务操作上来说，最好就是点一个按钮即可，而反映到技术层面就是必然有种组织在管理全部元数据，那这就是以School为Root，Chapter, Folder, Lesson等为层叠Children的 [DistributeTree](https://github.com/mvj3/distribute_tree) ，其中的关系都通过Model类变量 `@@distribute_children` 得到声明，在同步时被递归访问进行，当然在自动同步模式中这个就被 [禁用](https://github.com/mvj3/distribute_tree/blob/sunshine/lib/distribute_tree.rb#L20) 了。如前面所说，手工同步最好点一个按钮即可，但是我们这里可以在一个页面里选择多个学校和多个资源一起同步。

叶子上的多媒体数据同步在树的同步下就没问题了，不过一点需要注意的是最好是采用网络下行同步以保证网络速度，也即是被同步方自己请求静态资源地址。

总结一点，其实就和NoSQL挑战SQL的情况一样，企业对结构化数据的一致性和方便管理的需求远远大于SchemeLess和高性能。所以技术选型更多是从业务出发，让技术辅助业务，而不是因为技术的某些特性听上去和业务某些场景相符就选择了，应该按业务最本质的结构和最大比例的需求来。

## 一些关于重构的想法

* 我个人现在反感给Model添加太多的逻辑，长长的上百行，几百行，我觉得最好只存在module引入的声明，字段的声明，和类似Paperclip等插件DSL的声明，其他处理都依照业务划分到不同的类和模块中。
* 很多人都误会了 `Fat model, skinny controller` 的本意，它其实只是关于重构箴言一段话里的中间一句。Fat models只是鼓励你DRY(don’t repeat yourself)，实现逻辑共享而已，其次是Model相比Controller更有利于测试，因为业务核心的处理往往都是在Model层面。推荐看 [“Fat model, skinny controller” is a load of rubbish](http://joncairns.com/2013/04/fat-model-skinny-controller-is-a-load-of-rubbish/) 。
* 三层以上关系一般来说不宜用继承，它超过了[人类理解的复杂度](http://mvj3.github.io/2013/12/15/human-mind-and-software-engineering/)，记住"组合优于继承"。
* 测试覆盖率，代码坏味道自动发现，scrum开发模式等都不能保证软件项目的质量，唯一可以保证的就是深刻地结合业务与技术，在你的业务里用你的技术再去深层次地抽象出另一个"MVC"模块化的框架结构。
* 重构的前提是不改变软件的行为，而混乱的代码经由重构后，它的内部结构已经不是之前那个范式了。
* 当你需要对项目进行重构时，那就说明该项目以前存在某种技术或人员等上的问题。
* 代码没有被结构化和注释，不是项目时间因素，而是个人水平能力的体现，因为代码结构和注释体现了思考。
* BUG如果是功能，那就不能修复了，而是要花更多的时间去分析和开发。
* 除非是为了表达视觉结构，否则不推荐重复代码。我对单行代码有偏爱，比如 `def teacher?; self.user_type == 'teacher'; end` 。
* 类似不要在GUI里放入逻辑等，都是模块化的体现。但是很多初级程序员不知道这一点，良好的程序员会注意这一点，而优秀的程序员已经在实践之。
* 逻辑只是用来证明直观，正是范式的体现。
* 类似重构原则只是事后补救时说服别人用的，它无益于提升你的编码能力，就像很多人做的和以为的设计模式只是在你有几年工作经验后才会去整理自己知识经验体系用的而已，否则会很难以理解这些设计模式。
* 重构中会有造成自己方被动和被误解的情况，因为甲方看到的和关心的只是是软件的表面行为而已，请慎重沟通。
* 正如《重构》第359页提到的，它的进度应该是，今天一点点，明天一点点。不是一次性全部重构(那就是重写了)，而是每次重构一点点，不断的抽取模块，按当时的业务需求和BUG来，当然其中也可能有依赖，去重构牵扯的功能模块。
* 关于管理软件的复杂度和理解力的原则和思想方面可以参考我写的另一篇 [人类思维和软件工程学](http://mvj3.github.io/2013/12/15/human-mind-and-software-engineering/) 。

## 为什么我能做到以上重构

其实如果没有四五年的工作经验，没有上半年把 [一个单页应用在线学习应用完全模块化](http://mvj3.github.io/2013/08/04/a-man-github/) 的思考和经验，我可能还只是停留在 `Fat model, skinny controller` 和 翻起Martin Fowler的《重构》手册指导的那种层次而已。

## 其他教育项目的重构

Rails社区的一个牛人 @yedingding 在今年2013三月也分享了一篇公益项目Re-education做 [重构](http://yedingding.com/2013/03/04/steps-to-refactor-controller-and-models-in-rails-projects.html) 的案例。对于一般规模的Rails项目，[Skinny Controller, Fat Model] 差不多能解决大部分问题了，其次通过适当的Concern(Shared Mixin Module)机制抽取公用部分，再以Delegation Pattern, Service, Presenter，DCI等在MVC不同层面去抽象种种业务逻辑结构。

## 关于MongoDB动态字段的吐槽

MongoDB的动态字段被很多人误用为根据业务变动可以随意动态调整了，其实它的最佳场景是类似新鲜事的非结构化数据及其大数据分片，因为它是为 **单collection** 里读写 **单个记录的整体** 而优化设计的。
