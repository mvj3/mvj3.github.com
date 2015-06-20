---
layout: post
title: 'HAML引用html5shiv.js'
published: true
comments: true
date: 2012-12-13 12:14:55 +08:00
categories: [HTML5, HAML, Javascript]
---


{% endhighlight %}haml
/[if lt IE 9]
  %script{:src=>"html5shiv/dist/html5shiv.js"}
{% endhighlight %}
