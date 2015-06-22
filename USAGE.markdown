如何使用 http://mvj3.github.io
==========================================

TODO
------------------------------------------
*    相似性文章 lsi 选项为何无效
*    Add disqus
*    tags
*    Opensource timeline

mvj3.github.io运作原理
------------------------------------------
git@github.com:mvj3/mvj3.github.com.git 是原始 git 源码库，上传到 github.com 网站后，被 jekyll 引擎自动生成网页，并以 mvj3.github.io 域名接受访问。

因为 Github pages 服务默认禁用了 jekyll 第三方扩展运行，所以折衷办法是:
1. 添加 .nojekyll 文件。
2. 运行 rake deploy 命令, 把生成的静态站点源文件(HTML+CSS+JS)放到 git@github.com:mvj3/mvj3.github.com.git 这个源码库里。


如何写日志和管理
------------------------------------------
运行 `bundle exec rake -T` 察看可用任务


网站内容
------------------------------------------
1. main blog
2. statistics-analytics-and-dark-knight
3. statlysis showterm


命令工具
------------------------------------------
```bash
jekyll
```
