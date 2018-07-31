---
title: Ubuntu16.04安装新版本的Nodejs
date: 2018-07-30 21:19:39
tags:
- Linux
- Nodejs
permalink: install-node-in-ubuntu
---

在 `Ubuntu 16.04` 中如果直接使用自带的包管理器 `apt-get` 安装, 得到的版本是很旧的(v4), 所以想用到比较新的 `Nodejs` , 需要找其他方法.

在网上看到很多方法, nvm 管理, 源码编译等, 其实直接用 Node 官方推荐的方法最简单. 只需要两条命令, 而且速度很快

```bash
# 安装 8.x
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```

或者:

```bash
# 安装 10.x
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```

官方文档地址 : [https://nodejs.org/en/download/package-manager/](https://nodejs.org/en/download/package-manager/)
