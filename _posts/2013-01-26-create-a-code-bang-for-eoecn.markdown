---
layout: post
title: '*.eoe.cn制作代码大爆炸！'
published: true
comments: true
date: 2013-01-26 16:44:15 +08:00
categories: [Code, iMovie, Git]
---

![imovie](/images/2013-01-26-create-a-code-bang-for-eoecn/imovie.png)

下载安装code swarm，系统环境预备见 https://github.com/rictic/code_swarm

{% highlight bash linenos %}
git clone git://github.com/rictic/code_swarm.git && cd code_swarm # 下载源码
ant # 编译
{% endhighlight %}

合并多个git仓库
{% highlight bash linenos %}
mkdir eoecn_codebang && cd eoecn_codebang # 创建临时仓库目录，并切换
git init && git commit --allow-empty-message -am '' --allow-empty # 初始化git环境
git remote add programmingonline git@eoe.git.server:/opt/datas/git/eoe/programming.online.git # 添加多个git仓库
git remote add eoecn git@eoe.git.server:/opt/datas/git/eoe/eoecn.git
git pull programmingonline master # 合并多个git仓库
git pull eoecn master
git commit -am 'merge programmingonline and eoecn' # 直接合并冲突
export PATH="/Users/mvj3/github/rictic/code_swarm/bin:$PATH" # 把code_swarm的bin目录加入到环境变
量中
code_swarm # 不用管他出错提示，只要在运行就可以了。它会在当前目录下生成包含git历史记录信息的.code_swarm/log.xml
ruby -e 'filename = "/Users/mvj3/eoemobile/code/eoecn_codebang/.code_swarm/log.xml"; File.write(filename, File.read(filename).gsub(/@[^"]*\"/,"\""))' # 在ruby里把无效的email后缀去除。
{% endhighlight %}

生成一帧一帧的png文件
{% highlight bash linenos %}
pwd   #  先切换回code_swarm项目目录，修改defaults/user.config里的InputFile变量到刚才生成的.code_swarm/log.xml的绝对路径
./run.sh defaults/user.config # 如果没错误的话，你就可以frames目录下不断有png生成了。如果量大的话，你会听到电脑的风扇也在狂转了。
{% endhighlight %}


用iMovie制作视频
{% highlight bash linenos %}
ffmpeg -f image2 -r 12 -i ./frames/code_swarm-%05d.png -sameq ./out.mov -pass 2 # 用ffmpeg生成视频，直接iMovie导入这么多png太慢
{% endhighlight %}

### iMovie使用总结
任何视频，音频，字幕操作都是选中后操作，包括时长，大小，变速等。


### 参考文档
*   http://code.google.com/p/codeswarm/wiki/GeneratingAVideo#Instructions_for_running_Codeswarm_0.1_on_OS_X_10.6_with_a_git_r
*   http://progressdaily.diandian.com/post/2012-01-20/14242590




附上配置文件 user.config
{% highlight bash linenos %}
# Your personal preferences for code_swarm, applied to every visualization
# you run, unless overridden by the individual visualization's config

#DON'T EDIT THIS FILE IN PLACE, FIRST COPY IT TO defaults/user.config
#CHANGES TO THIS FILE WON'T BE SEEN BY code_swarm, ONLY user.config

#Some common options to customize:

# It's much faster if we can use OpenGL, but it still doesn't work on some
# platforms/configurations
UseOpenGL=true

# The size of the visualization window
Width=640
Height=280

Font=Helvetica
FontSize=25
BoldFontSize=20
TakeSnapshots=true

#Size in pixels of the width and height of avatar images
AvatarSize=64

InputFile=/Users/mvj3/eoemobile/code/eoecn_codebang/.code_swarm/log.xml
SnapshotLocation=frames/code_swarm-#####.png
#For more options, see defaults/code_swarm.config



# Draw names (combinatory) :
# Draw sharp names?
DrawNamesSharp=true
# And draw a glow around names? (Runs slower)
DrawNamesHalos=false

# Draw files (combinatory) :
# Draw sharp files
DrawFilesSharp=false
# Draw fuzzy files
DrawFilesFuzzy=true
# Draw jelly files
DrawFilesJelly=false

# Show the Legend at start
ShowLegend=false

# Show the History at start
ShowHistory=true

# Show the Date at start
ShowDate=true

# Show edges between authors and files, mostly for debug purpose
ShowEdges=false

# Turn on Debug counts.
ShowDebug=false

# Natural distance of files to people
EdgeLength=25

# Amount of life to decrement
EdgeDecrement=-2
FileDecrement=-2
PersonDecrement=-1

#Speeds.
#Optional: NodeSpeed=7.0, If used, FileSpeed and PersonSpeed need not be set.
#
FileSpeed=7.0
PersonSpeed=2.0

#Masses
FileMass=1.0
PersonMass=10.0

# Life of an Edge
EdgeLife=250

# Life of a File
FileLife=200

# Life of a Person
PersonLife=255

# Highlight percent.
# This is the amount of time that the person or
# file will be highlighted.
HighlightPct=5

## Physics engine selection and configuration
# Directory physics engine config files reside in.
PhysicsEngineConfigDir=physics_engine
# Force calculation algorithms ("PhysicsEngineLegacy", "PhysicsEngineSimple"...) :
PhysicsEngineSelection=PhysicsEngineOrderly

#Is the input xml sorted by date?  It's faster and uses much less memory if it is
IsInputSorted=true

# OpenGL is experimental. Use at your own risk.
UseOpenGL=false
ShowUserName=true
{% endhighlight %}
