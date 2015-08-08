http://mvj3.github.io [![Build Status](https://travis-ci.org/mvj3/mvj3.github.com.png)](https://travis-ci.org/mvj3/mvj3.github.com)
==========================================
Thoughts from David Chen @mvj3 .

mvj3.github.io 和 mvj3.github.com 两个仓库介绍
------------------------------------------
1. mvj3.github.io 被 Github 默认优先使用来作为静态网页渲染。
2. mvj3.github.com 被我用来做基本的开发和写作。


mvj3.github.com 目录结构介绍
------------------------------------------
本身就是用 [jekyll](http://jekyllrb.com) 工具构建的，所以运作原理见官方文档即可。

1. 核心配置在 `_config.yml` 。
2. 前端开发资源配置见 `bower.json` 。

前端开发工具采用 [bower](http://bower.io) 来管理，以后都是这样，纯粹使用前端的
HTML，不同内容之间的网页涉及到的静态资源 **完全隔离** 。


如何写日志和管理?
------------------------------------------
模仿 `_posts` 下其他文章的格式规范即可。

如何发布网站新内容到 Github ?
------------------------------------------
在根目录下运行

`bundle exec jekyll server -V`

即可生成全站的 HTML 到 _site 目录(被 .gitignore 所忽略的)下。而 _site
也是一个 Git 仓库，即是 mvj3.github.io ，所以按正常的 Git 操作，直接
push master 分支到 Github 即可，Github 服务器会自动更新静态网站内容。

目前的网站内容
------------------------------------------
1. main blog
2. statistics-analytics-and-dark-knight
3. statlysis showterm

TODO
------------------------------------------
* ...


为什么不使用 Octopress ?
------------------------------------------
历史上使用 Octopress ，但是因为以下三点原因被我弃用:

1. 加了一层，增加了不透明性。虽然 Octopress 3 改变策略，变成 Gem
   模式，但是我还是选择自己自定义的吧，跟着别人开发累。
2. 直接 git merge 内容操作，太依赖官方。
3. 各种原始的插件机制很不好用(和运作原理有关，Octopress 和 Jekyll
   在我看来都有这问题)

历史遗迹见以上两个仓库打的 tag 。
