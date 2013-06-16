---
layout: post
title: 删除重复记录
published: true
date: 2011-08-27 16:36:16 +08:00
categories: [Ruby]
---

项目因为一个隐藏的BUG要删除掉重复的评论，如果所有评论挨个比对的话，程序的开销为O(N²)，因此可以采用Hash来把开销降低到O(N)。为避免原始数据作为Hash键导致内存占用过多的问题，可以把Hash键改为原始数据内容生成的Hash码。为了避免误删，删除之前还可对疑为重复数据的记录进行比对。
{% highlight ruby linenos %}
require 'action_pack'
require 'action_view/helpers/number_helper.rb'
include ActionView::Helpers::NumberHelper

def current_vm_size
  `vmmap #{$PID}`.split("\n")[-1].split[1].to_f * 1024 * 1024
end

def object_size
 prev_size = current_vm_size
 yield
 number_to_human_size(current_vm_size - prev_size)
end

require 'digest/sha1'

columns = %w[account_id target_id section_id rating comment status client_id channel_id device_id locale_id]
@hash = {} # avoid to be released in local scope

object_size do
  Comment.find_each(:batch_size => 100) do |c|
    k = Digest::SHA1.hexdigest(columns.map {|column| c.attributes[column].to_s }.join)
    if @hash[k]
      o = Comment.find(@hash[k])
      c.destroy if columns.select {|column| o.attributes[column] == c.attributes[column] }.size == columns.size
    else
      @hash[k] = c.id
    end
  end
end

{% endhighlight %}

在我本机测试，全部载入十万多条原始数据会占用263MB内存，而采用以上hash压缩的方式则降低到13.3MB。如果表里有大文本字段的话，会更有效果。

如果能停掉对数据库表做插入访问，那么也可以直接用SELECT DISTINCT\*的SQL语句导入到临时表中，将原始表清空后再重新导入。
