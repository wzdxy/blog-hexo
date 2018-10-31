---
title: 给gitpage添加submodule子模块遇到的一个坑
date: 2016-11-04 01:06:22
tags: 
- Git
permalink: git-submodule-issue
---

### Git Submodule 
昨天想把自己的几个插件Demo放到Gitpage上，学到了submodule的用法

### 问题
给Gitpage的仓库添加了两个子模块之后，在本地可以正常访问，但是push到github上就不不成了，不但访问不了模块的连接，连Gitpage都不更新了，外层库里的代码改动直接被忽略。

甚至改掉仓库名（相当于删掉Gitpage），旧版本的Gitpage还能访问（一段时间），过了很久才404

<!-- more -->

之后再改回来，还是一直404

### 解决

一开始以为是Git服务器缓存的问题，但是等了一天也没有恢复，看来应该是我自己的问题

搜不到相关的问题之后，翻到了rep的setting页，原来这里已经给我报了一个错误

![](https://static.wzdxy.com/img/QQ%E6%8B%BC%E9%9F%B3%E6%88%AA%E5%9B%BE%E6%9C%AA%E5%91%BD%E5%90%8D.png)

意思是要用https协议来引入子模块，带着这个关键字，终于搜到了一篇博客

http://blog.k-res.net/archives/1595.html

看来果然是协议的问题

到`.gitmodules`文件里把git库的ssh链接换成https的链接
![](https://static.wzdxy.com/img/QQ%E6%8B%BC%E9%9F%B3%E6%88%AA%E5%9B%BE%E6%9C%AA%E5%91%BD1%E5%90%8D.png)
```js
git submodule sync
git submodule update  //不知道有没有必要
git push
```

这样就可以访问了