---
layout: post
title: ActiveRecord兼容非正规数据库表名和表字段设计的多对多，一对多关系
published: true
comments: true
date: 2013-01-24 16:07:41 +08:00
categories: [Rails, ActiveRecord]
---

Rails里的多对多关系声明极其简单，一句 `has_and_belongs_to_many :projects` 就可表示当前表通过一个中间表来拥有多个projects，唯一的约定就是复数的表名和_id后缀的外键。

但是如果你接手的数据库是在别的不同约定的语言框架里设计的，这样去套用Rails的 `has_and_belongs_to_many` 就炕爹了，你得一个一个去声明每一个选项，以下就是本人惨痛的经历，其他人看了就不用重蹈覆辙了。

参考：http://guides.rubyonrails.org/association_basics.html ，和本地的Rails rdoc文档

需求是查出一个用户收藏的所有代码。


 先来看下表结构。用户，收藏，代码三个表结构主要部分如下：
{% endhighlight %}sql
CREATE TABLE `common_member` (
  `uid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`uid`),
) ENGINE=MyISAM AUTO_INCREMENT=802058 DEFAULT CHARSET=utf8;

CREATE TABLE `common_user_favorite` (
  `itemid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `model` enum('blog','code','news','book') NOT NULL,
  `create_time` int(11) NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `code_gists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_code_gists_on_deleted_at_and_user_id_and_updated_at` (`deleted_at`,`user_id`,`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8;
{% endhighlight %}

我们接下来的代码逻辑就是查找出目标用户，通过收藏表，来找出该用户的所有代码。

先声明三个model如下：
{% highlight ruby %}
class CommonMember < ActiveRecord::Base
  self.table_name = :common_member
end
class CommonUserFavorite < ActiveRecord::Base
  self.table_name = :common_user_favorite
end
class CodeGist < ActiveRecord::Base
end
{% endhighlight %}

接着声明三个model之间的关系
{% highlight ruby %}
CommonUserFavoriteConditions = "`common_user_favorite`.`is_delete` = 0 AND `common_user_favorite`.`model` = 'code'"
class CommonMember < ActiveRecord::Base
  has_many :fav_gists, :through => :favs, :order => "`common_user_favorite`.`create_time` DESC", :source => :gist
  has_many :favs, :class_name => CommonUserFavorite, :foreign_key => :uid, :conditions => CommonUserFavoriteConditions
end
class CommonUserFavorite < ActiveRecord::Base
  belongs_to :gist, :class_name => CodeGist, :foreign_key => :itemid
end
class CodeGist < ActiveRecord::Base
  has_many :favs, :class_name => CommonUserFavorite, :foreign_key => :itemid, :conditions => CommonUserFavoriteConditions
end
{% endhighlight %}

以下是解释

先声明收藏表(CommonUserFavorite) `belongs_to` 代码表(CodeGist)，指定 收藏表(CommonUserFavorite)  的外键是:itemid，关联的代码表(CodeGist)的主键是:id。示例如：
`CommonUserFavorite.where(:model => 'code').first.gist`
{% endhighlight %}sql
SELECT `common_user_favorite`.*
        FROM `common_user_favorite`
        WHERE `common_user_favorite`.`model` = 'code'
        LIMIT 1;

SELECT `code_gists`.*
        FROM `code_gists`
        WHERE `code_gists`.`id` = 43 AND (`code_gists`.`deleted_at` IS NULL)
        LIMIT 1;
{% endhighlight %}

再声明代码表(CodeGist) `has_many` 收藏表(CommonUserFavorite) ，指定 收藏表(CommonUserFavorite)  的外键是 :itemid，且查询条件是 `:conditions => ["common_user_favorite.model = 'code'"]` 。示例如： `CodeGist.last.favs`
{% endhighlight %}sql
SELECT `code_gists`.*
        FROM `code_gists`
        WHERE (`code_gists`.`deleted_at` IS NULL)
        ORDER BY `code_gists`.`id` DESC
        LIMIT 1;

SELECT `common_user_favorite`.*
        FROM `common_user_favorite`
        WHERE `common_user_favorite`.`itemid` = 107
                AND (`common_user_favorite`.`is_delete` = 0
                AND `common_user_favorite`.`model` = 'code');
{% endhighlight %}

最后声明是用户表(CommonMember)对代码表(CodeGist)的has_many 是通过 用户表(CommonMember)对收藏表(CommonUserFavorite)的has_many 和 收藏表(CommonUserFavorite)对代码表(CodeGist)的belongs_to 共同实现的，这两个声明关系分别表述为  `:through => :favs` 和  `:source => :gist`。各自的示例如： 

`cm = CommonMember.where(:uid => 470700).first`
{% endhighlight %}sql
SELECT `common_member`.*
        FROM `common_member`
        WHERE `common_member`.`uid` = 470700
        LIMIT 1;
{% endhighlight %}

`cm.fav_gists`
{% endhighlight %}sql
SELECT `code_gists`.*
        FROM `code_gists`
        INNER JOIN `common_user_favorite`
              ON `code_gists`.`id` = `common_user_favorite`.`itemid`
        WHERE `common_user_favorite`.`uid` = 470700
              AND (`code_gists`.`deleted_at` IS NULL)
              AND (`common_user_favorite`.`is_delete` = 0
              AND `common_user_favorite`.`model` = 'code')
        ORDER BY `common_user_favorite`.`create_time` DESC;
{% endhighlight %}
