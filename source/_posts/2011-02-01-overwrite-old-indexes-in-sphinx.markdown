---
layout: post
title: sphinx覆盖旧索引
published: true
comments: true
date: 2011-02-01 16:45:09 +08:00
categories: [Sphinx, Index]
---

换用sphinx后，产品同事发现旧的数据也能搜索出新数据来，查了下官方文档 http://sphinxsearch.com/docs/manual-0.9.9.html#index-merging， 发现更新索引时thinking-sphinx没有把它自定义的sphinx_deleted属性同时更新上去，导致在执行增量索引时用的--merge-dst-range选项无效。现解决方案如下： 

1. 在config/production.sphinx.conf的searchd部分加上 attr_flush_period = 5 ，让sphinx在更新sphinx_deleted属性后写入到磁盘里。 

2. 因为sphinx要部署在另外一台独立的机子上，为了方便运维部署和维护，不用安装其他的类似rmagick之类和sphinx无关的软件，就写了一个ruby脚本，用bundler配置安装下gem包，放在cron里定时跑，部分代码如下： 


```ruby
#!/usr/bin/env ruby -rubygems  
RAILS_ROOT = File.expand_path(File.dirname(__FILE__)) unless defined?(RAILS_ROOT)  
sphinx_config_yml = RAILS_ROOT + '/config/sphinx.yml'  
mysql_config_yml = RAILS_ROOT + '/config/database.yml'  
production_sphinx_conf = RAILS_ROOT + '/config/production.sphinx.conf'  
gem 'rails', '2.3.4'  
require 'initializer'  
%w[active_record active_support action_view action_controller action_mailer].map {|act| require act}  
gem "thinking-sphinx", "1.3.18", :lib => "thinking_sphinx"  
%w[yaml riddle thinking_sphinx].map {|lib| require lib}  
  
class Hash  
  def symbolize_keys  
    inject({}) do |options, (key, value)|  
      options[(key.to_sym rescue key) || key] = value  
      options  
    end  
  end  
end  
  
sphinx_config = YAML.load_file(sphinx_config_yml)['production'].symbolize_keys  
ActiveRecord::Base.establish_connection(YAML.load_file(mysql_config_yml)['production'].symbolize_keys)  
  
class ActiveRecord::Base  
  def self.has_attached_file(a, b = {}); end  
  def self.validates_attachment_content_type(a, b = {} ); end  
end  
  
files = Dir.glob(RAILS_ROOT + "/app/models/*/*.rb") + Dir.glob(RAILS_ROOT + "/app/models/*/*/*.rb")  
model_strs = files.map {|path| path.scan(/app\/models\/(.*)\.rb/)[0][0].split('/').map(&:camelize).join('::') }  
  
model_strs.each do |str|  
  arr = str.split("::")  
  arr.size.times do |x|  
    begin  
      eval("class #{arr[0..x].join('::')} < ActiveRecord::Base; end")  
    rescue TypeError  
      # FIX superclass mismatch for class Data (TypeError)  
    end  
  end  
end  
  
files.each do |x|  
  begin  
    load x  
  rescue TypeError  
  end  
end  
  
  
client = Riddle::Client.new(sphinx_config[:address], sphinx_config[:port])  
indexes = []  
  
models = ThinkingSphinx.context.indexed_models.each do |str|  
  prefix = str.split('::').map {|s| s.downcase }.join('_')  
  indexes << ( index = ["#{prefix}_core", "#{prefix}_delta"] )  
  attrs = {}  
  str.constantize.all(:select => "id", :conditions => ["updated_at > ?", Time.now - 3650]).each do |item|  
    attrs[item.id * 5] = [1]  
  end  
  
  unless attrs.blank?  
    puts attrs.inspect  
    puts "Updating #{client.update(index[0], ['sphinx_deleted'], attrs )} docs"  
  end  
end  
sleep 10 # 等待写入到磁盘里  
  
# 只允许0出现在最终索引里  
system "/usr/local/bin/indexer --rotate --config #{RAILS_ROOT}/config/production.sphinx.conf #{indexes.map {|x| x[1] }.join(' ')}"  
sleep 2 # 马上执行以下会导致delta没有更新到main索引里  
indexes.each do |index|  
  system "/usr/local/bin/indexer --rotate --config #{RAILS_ROOT}/config/production.sphinx.conf --merge #{index.join(' ')} --merge-dst-range sphinx_deleted 0 0"  
end  
```
