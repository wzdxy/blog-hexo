---
title: 如何优雅的在 windows 下开发---Windows SubSystem Linux 踩坑记录
date: 2018-11-03 10:08:15
tags:
- Linux
- WSL
permalink: wsl-start
---

## 简介


## 安装和启动
1. 准备工作: 在`启用或关闭 Windows 功能`中打开 `适用于 Linux 的 Windows 子系统`
<!-- more -->
![](https://static.wzdxy.com/img/Snipaste_2018-11-03_12-47-35.jpg)
2. 应用商店搜索 `wsl`, 安装 `Ubuntu 16.04` 或其他 Linux 发行版
![](https://static.wzdxy.com/img/Snipaste_2018-11-03_12-45-08.jpg)
3. 在开始菜单中启动即可, 首次打开需要设置用户名和密码
![](https://static.wzdxy.com/img/sc_2018-11-03_12-52-57.jpg)
4. 在 cmd 或 Wox 启动

## 加入右键菜单
![](https://static.wzdxy.com/img/sc_2018-11-03_15-41-04.jpg)
1. 找到注册表中 `\HKEY_CLASSES_ROOT\Directory\Background\shell\`
2. 右键`shell`新建一个项 (名称随意, 可以叫`WSL`), 双击其中的`默认`, 改为 `Bash here`(右键菜单要显示的名字)
3. 在默认下面加一个`字符串值`, 名为`Icon`, 双击将它的值改为你想要的图标的地址,可以是.ico和.exe文件., 比如用 [Ubuntu 的图标](https://static.wzdxy.com/img/ubuntu.ico)
4. 在 `WSL` 下新建一个项,名为`command`, 将这个项中的 `默认` 改为 `"C:\Windows\System32\bash.exe"`, (带双引号)
![](https://static.wzdxy.com/img/sc_2018-11-03_15-17-21.jpg)
![](https://static.wzdxy.com/img/sc_2018-11-03_15-17-31.jpg)

## 访问 windows 下的文件
- `/mnt` 路径
- 软连接挂载常用目录 `ln -s /mnt/e e`
![](https://static.wzdxy.com/img/sc_2018-11-03_12-57-10.png)

## 配置开发环境
### 设为 vscode 默认终端
1. 设置 `"terminal.integrated.shell.windows": "C:\\Windows\\Sysnative\\bash.exe" `
2. `Ctrl + `` 启动终端即可
![](https://static.wzdxy.com/img/sc_2018-11-03_14-46-17.jpg)


## 命令行访问 windows 下的可执行文件
1. `code .` 当前目录启动 vscode  (这个 vscode 是windows下的, 貌似仅支持在 `\mnt` 路径下的文件夹使用, 不支持 linux 路径)
2. 执行全局 node 模块
[安装 Node.js](https://blog.wzdxy.com/2018/07/install-node-in-ubuntu/) 后, 在 Ubuntu 里可以直接运行 windows 下的 npm 包.
![](https://static.wzdxy.com/img/sc_2018-11-03_14-16-52.jpg)
关于执行 Node 模块这一点真是让人困惑, 我在 windows 上安装的 node 版本是 10.x , Ubuntu 上安装的是 8.x.
从截图看出我在 Ubuntu 上只装了一个 gulp, 但我运行 `parcel`, `hexo` 等 windows 上安装的全局包时, 却可以正常运行, 而 hexo 的 info 显示使用的 Node 是 Linux 上的.
也就是说, 只要子系统安装了 node, 就可以在 Linux 环境直接调用 windows 下的 npm 包, 不需要单独安装, 不过还没测试过本地编译的包能不能用.
(我怎么感觉这是个环境变量混乱导致的 BUG, 还需要再了解一下 WSL 和 windows 交互的特性啊)

## To Be Continue...