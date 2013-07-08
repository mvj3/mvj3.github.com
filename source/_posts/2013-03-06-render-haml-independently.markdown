---
layout: post
title: 独立使用HAML渲染
published: true
comments: true
date: 2013-03-06 14:45:06 +08:00
categories: [HAML, RenderEngine]
---

对于基本HAML语法可使用下列方法渲染即可

```ruby
content     = File.read(your_haml_path)
engine      = Haml::Engine.new(haml_content)
engine.render
```

如果在content里使用了text_field_tag等view方法，那就需要在给engine指定render的作用域。默认是obj = Object.new，但是这个obj没有text_field_tag方法，所以就需要include ActionPack里对于的View模块，例如

```ruby
class HomeController < ApplicationController
   include ActionView::Helpers::AssetTagHelper
   include ActionView::Helpers::FormTagHelper
   include ActionView::Helpers::OutputSafetyHelper
end
engine.render(HomeController.new)
```

参考文档
----------------------------------------------
* http://haml.info/docs/yardoc/Haml/Engine.html
* http://stackoverflow.com/questions/6125265/using-layouts-in-haml-files-independently-of-rails
