---
layout: post
title: '统计分析DSL设计，解决惰性加载 和 作用域 两个问题'
published: true
comments: true
date: 2013-04-17 21:42:44 +08:00
categories: [Statlysis, Lazy-loading, Proc]
---

```ruby
# encoding: UTF-8
#
# 统计分析DSL设计
#

require 'singleton'

module StatlysisDslDesign
  class << self
    def setup &block
      raise "必须配置proc" if not block

      puts "开始配置 StatlysisDslDesign"
      # 1, 作用域   使用&block把proc对象传递给其他对象作用域执行
      StatlysisDslDesign.time_log do
        config.push block
      end
      puts
    end

    def process
      config.daily_crons.each do |name, _proc|
        puts "开始执行 #{name} 任务"
        StatlysisDslDesign.time_log do
          puts "结果 #{_proc.call}"
        end
      end
    end

    def config
      Configuration.instance
    end

    protected
    def time_log
      t = Time.now
      yield
      puts "时长 #{(Time.now - t).round(2)}秒"
      puts "-" * 42
    end
  end

  class Configuration
    include Singleton
    attr_accessor :daily_crons
    self.instance.daily_crons = {}

    def push _proc
      self.instance_exec(&_proc)
      self
    end

    def daily symbol
      raise "必须配置一个和symbol对应的proc" if not block_given?
      # 2, 惰性加载 实现方法用proc包装block
      self.daily_crons[symbol] ||= Proc.new { yield }
      return self
    end

  end

end

StatlysisDslDesign.setup do
  daily :large_count do
    sleep rand
    Struct.new(:count).new(10**10)
  end

  daily :slow_count do
    sleep 3
    Struct.new(:count).new(1)
  end
end
StatlysisDslDesign.process

__END__
开始配置 StatlysisDslDesign
时长 0.0秒
------------------------------------------

开始执行 large_count 任务
结果 #<struct count=10000000000>
时长 0.57秒
------------------------------------------
开始执行 slow_count 任务
结果 #<struct count=1>
时长 3.0秒
------------------------------------------
```
