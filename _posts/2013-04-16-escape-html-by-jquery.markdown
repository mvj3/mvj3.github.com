---
layout: post
title: 'jQuery转义HTML'
published: true
comments: true
date: 2013-04-16 14:45:54 +08:00
categories: [jQuery]
---

参考 http://stackoverflow.com/questions/6020714/escape-html-using-jquery

{% endhighlight %}javascript
escapeHTML = function(text) {
  return $('<div/>').text(text).html();
}

escapeHTML('<div id="main">');
// "&lt;div id="main"&gt;"
{% endhighlight %}
