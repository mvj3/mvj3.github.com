---
layout: post
title: 给xunsearch提供一对多的不重复的数据列表
published: true
comments: true
date: 2013-03-25 14:07:30 +08:00
categories: [Sphinx, ActiveRecord, Search]
---

问题概述
------------------------------------------------
同事采用的xunsearch搜索引擎在搜索一对多表时遇到了重复内容的问题，问题在通过SQL语句来生成的单表有因为一对多而导致的重复信息。简单google下，发现要用group_concat把两个表要用到的文本字段来把每个都合成到一行记录里，但是这样复杂的SQL估计只有大拿才能写的出来。

解决方案
------------------------------------------------
于是我想到之前做的thinking-sphinx是支持一对多联合查询的，那就看看thinking-sphinx是如何来生成SQL的。


配置thinking-sphinx，这个参考官网。

code_gists对应多个code_documents，给搜索模块配置索引结构  

{% highlight ruby %}
class CodeGist < ActiveRecord::Base
  define_index do
    indexes documents.filename, :as => :content
    indexes documents.content, :as => :content
    indexes :description, :as => :content
    indexes :author, :as => :content

    where "(code_gists.deleted_at IS NULL AND code_documents.deleted_at IS NULL)"
  end
end
{% endhighlight %}

运行bundle exec rake ts:config后，在config目录就有了config/production.sphinx.conf文件，察看source区块的sql_query为  

{% endhighlight %}sql
SELECT SQL_NO_CACHE `code_gists`.`id` * CAST(3 AS SIGNED) + 0 AS `id` , GROUP_CONCAT(DISTINCT IFNULL(`code_documents`.`filename`, '0') SEPARATOR ' ') AS `content`, GROUP_CONCAT(DISTINCT IFNULL(`code_documents`.`content`, '0') SEPARATOR ' ') AS `content`, `code_gists`.`description` AS `content`, `code_gists`.`id` AS `sphinx_internal_id`, 0 AS `sphinx_deleted`, 1875287073 AS `class_crc`, IFNULL(`code_gists`.`author`, '') AS `author` FROM `code_gists` LEFT OUTER JOIN `code_documents` ON `code_documents`.`gist_id` = `code_gists`.`id` WHERE (`code_gists`.`id` >= $start AND `code_gists`.`id` <= $end AND (code_gists.deleted_at IS NULL AND code_documents.deleted_at IS NULL)) GROUP BY `code_gists`.`id` ORDER BY NULL;
{% endhighlight %}

稍微整理后，变成   

{% endhighlight %}sql
SELECT SQL_NO_CACHE `code_gists`.`id`,
                    GROUP_CONCAT(DISTINCT IFNULL(`code_documents`.`filename`, '0') SEPARATOR ' ') AS `content`,
                    GROUP_CONCAT(DISTINCT IFNULL(`code_documents`.`content`, '0') SEPARATOR ' ') AS `content`,
                    `code_gists`.`description` AS `content`,
                    IFNULL(`code_gists`.`author`, '') AS `content`
FROM `code_gists`
LEFT OUTER JOIN `code_documents` ON `code_documents`.`gist_id` = `code_gists`.`id`
WHERE (code_gists.deleted_at IS NULL AND code_documents.deleted_at IS NULL)
GROUP BY `code_gists`.`id`;
{% endhighlight %}

运行一下，就返回了不重复的数据列表了
