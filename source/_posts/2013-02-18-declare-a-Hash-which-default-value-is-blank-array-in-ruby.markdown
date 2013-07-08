---
layout: post
title: Ruby声明默认是空数组的Hash
published: true
comments: true
date: 2013-02-18 12:13:50 +08:00
categories: [Ruby, Hash]
---

Ruby里声明一个新Hash的方法一般是

```ruby
im_a_new_hash = {}
```

如果给它设一个为0的默认值，可以
```ruby
im_a_new_hash.default = 0
```
变成一行语句就是
```ruby
im_a_new_hash = Hash.new 0
```

但是这里注意，这里的0其实是个唯一对象，即是每一个默认值的object_id都是一样的，比如
```ruby
im_a_string_hash = Hash.new "string" # => {}
im_a_string_hash[3] # => "string"
im_a_string_hash[3].object_id # => 2168523080
im_a_string_hash[4].object_id # => 2168523080
```
可以看到取键3和4的默认值的object_id都是2168523080

Ruby里提供了new {|hash, key| block } → new_hash的方法, 因此声明一个默认是空数组的Hash的具体方法应该是
```ruby
im_a_default_array_hash = Hash.new {|hash, key| hash[key] = [] } # => {}
im_a_default_array_hash[99] # => []
im_a_default_array_hash[99].object_id # => 160533940
im_a_default_array_hash[99].object_id # => 160533940
im_a_default_array_hash[100].object_id # => 160571060 
```
可以看到键99的值的object_id一直是160533940，而键100的值的object_id则是160571060

具体文档查看 http://www.ruby-doc.org/core-1.9.3/Hash.html#method-c-new
