关于mvj3.github.io的笔记
==========================================

TODO
------------------------------------------
*    相似性文章lsi选项为何无效
*    主题重新定制

mvj3.github.io运作原理
------------------------------------------
git@github.com:mvj3/mvj3.github.com.git 是原始git源码库，上传到github.com网站后，被jekyll引擎自动生成网页，并以mvj3.github.io域名接受访问。

因为github pages服务默认禁用了jekyll第三方扩展运行，所以折衷办法是:
1. 添加.nojekyll文件。
2. 运行rake deploy命令, 把生成的静态站点源文件(HTML+CSS+JS)放到 git@github.com:mvj3/mvj3.github.com.git 这个源码库里。


如何写日志和管理
------------------------------------------
运行 `bundle exec rake -T` 察看可用任务
