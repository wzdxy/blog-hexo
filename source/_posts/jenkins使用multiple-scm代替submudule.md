---
title: Jenkins 使用 multiple SCMs 代替 git submudule 部署
date: 2018-08-16 22:02:30
tags:
- jenkins
- CI
- git
- hexo
permalink: jenkins-mutiple-scm
---

### Hexo 如何安装主题

使用 Hexo 作为博客之后, 选择了比较流行的 `Next` 主题.

要使用一个主题, 需要把主题文件夹整个下载到 `themes` 文件夹下, 然后修改配置文件启用主题.

这就带来了一个问题, 直接 `clone` 到 `themes` 文件夹的 `next` 仓库, 是不能直接纳入我博客的仓库的版本控制的. 换句话说, 虽然 `next` 主题的文件处于 `hexo` 的子目录下, 但是这两个仓库还是互相独立的. 这就需要使用 `git submodule` 将他们建立关联关系, 让 hexo 中的一个引用指向 next 的仓库. 这样就可以分别控制两个仓库的更新和提交了.

<!-- more -->

### Jenkins 部署失败

按照正常的部署流程, 在博客或主题更新之后, `git pull` 或 `git submodule update` 即可获取更新. 

但是在部署 Jenkins 时, 缺在更新子仓库步骤上出了问题.

![](https://static.wzdxy.com/img/Xnip2018-08-16_21-56-37.png)

不知道为什么, Jenkins 在尝试拉取 `submodule` 时, 可能没有使用正确的凭据, 没能成功更新 `next` 仓库. 在网上搜索发现很多人遇到了相同的问题. 也有很多人提出了多种解决方案, 尝试了几种配置 Jenkins 的方案, 都没成功. 有人说是 Jenkins 旧版本的 bug, 但我比较新的版本貌似也没解决

[Stack Overflow - git-submodules-not-updating-in-jenkins-build](https://stackoverflow.com/questions/9953299/git-submodules-not-updating-in-jenkins-build)

[Stack Overflow - why-is-jenkins-getting-authentication-failed-error-for-git-submodule-update](https://stackoverflow.com/questions/17100032/why-is-jenkins-getting-authentication-failed-error-for-git-submodule-update)

[Stack Overflow - jenkins-and-updating-git-submodules](https://stackoverflow.com/questions/36471981/jenkins-and-updating-git-submodules)

**不过最后看到了一个没有太多人采纳的方案:**
[Stack Overflow](https://stackoverflow.com/a/37444825)

![](https://static.wzdxy.com/img/Xnip2018-08-16_23-01-28.png)

### multiple SCMs

一般来说, Jenkins 一个项目只有一个 SCM, 但 `multiple SCMs` 这个插件, 允许在工作目录下的任意目录`checkout`另外的仓库, 这样就(在一定程度上)起到了和 `git submodule` 相同的作用.

1. 首先删掉 hexo 中的 submodule, 使两个仓库独立
2. 安装并配置`multiple SCMs`, 将 `next` 仓库拉到 `themes/next` 目录下
3. 在 `next` 主题的仓库也添加一个 `webhook` 指向 `Jenkins` , 不论主题还是博客有修改, 都能触发构建.

![](https://static.wzdxy.com/img/blog-hexo-github-multi-scm.png)

### 总结

- 对于部署 hexo 的主题而言, 多个仓库直接嵌套就可以了, 博客和主题完全解耦, 可以独立维护.
- 其实 `git submodule` 这种工作方式本身就很繁琐, 不管是对子仓库做添加, 更新, 还是删除的操作, 都很麻烦.
- 有方便的 CI 的话, `git submodule` 很多时候都可以不用了, 当然如果项目复杂, 依赖很多, 在开发环境下使用手动管理方式还是不够高效.
