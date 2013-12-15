---
layout: post
title: '解决Backbone视图的事件重复绑定'
published: true
comments: true
date: 2013-05-28 15:28:32 +08:00
categories: [Backbone]
---


原理
-------------------------------------
Backbone的模版和事件绑定原理是输出HTML，供dom操作。然后利用Javascript代理机制进行对应的事件绑定。

```javascript
var QAListTopicView = Backbone.View.extend({
  events: {
    "click li": 'topic_show'
  },
  topic_show: function(event) {
  },
  template: _.template($("#qa_list_topic_template").html()),
  initialize: function(opts) {
    this.topics = opts.topics;
    return this;
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  }
});

var list_topic_view = new QAListTopicView(data);
$("#qa ul").html(list_topic_view.render().el);
```

如果在View.render方法里进行事件绑定，那么就会对多重Backbone.View的多重实例进行重复绑定。

例子
-------------------------------------
详细的一个使用Backbone里的View和Event的例子见: https://github.com/eoecn/qa-rails/blob/master/app/assets/javascripts/qa-rails.js
