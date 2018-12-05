---
title: 如何优雅的在 windows 下开发---Windows SubSystem Linux 踩坑记录
date: 2018-11-03 10:08:15
tags:
- Linux
- WSL
permalink: wsl-start
---

## 简介
或为目前最好用的 Linux 发行版
更纯正的 Linux 命令行环境和~~更~~最好用的图形界面操作系统


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

## 让终端能走梯子
- 不需要在 linux 中安装 ss , 可以直接利用 windows 上 ss 的代理
```ini
# ~/.bashrc 或 ~/zshrc
export http_proxy="http://127.0.0.1:1080"
export https_proxy="http://127.0.0.1:1080"
```

## 安装oh my zsh
1. 安装 zsh , `sudo apt-get install zsh`
2. 安装 oh my zsh
```shell
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```
3. 设置为默认终端
```ini
# ~/.bash_profile (适用于 cmder , vscode)
exec zshh
source .zshrc
```

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

## 配置换行符为 LF
windows 下默认的换行方式是 `CRLF`, 而大家在协作时通用的代码换行方式是 Unix 系的 `LF` 换行, (Mac OS 从前使用 `CR`, 现已经改为 `LF`)
在 windows 系统中, VCS 通常采用 `autocrlf` 的办法来解决问题, 在检出代码时将 `LF` 替换为 `CRLF`, 提交时再替换回 `LF`, 以此保证提交的代码和使用 Linux/Mac 的小伙伴一致.
但是在 WSL 中, Linux 和 windows 的文件系统是互通的, 这就会导致问题, 尤其是使用WSL中的 git 时. 如果开启 autocrlf, 在 WSL 的 git 检出代码时, 会得到 windows 默认的 CRLF 换行, 在 windows 中这符合预期, 但如果我们在 Linux 使用 git 安装一些程序, 这些程序的代码就会出错 (因为 Linux 的文件系统不应该出现 CRLF 换行符), 所以我们在 windows 系统中也使用 `LF` 换行:
1. 关闭 windows 中 git 的自动转换 `git config --global core.autocrlf false` (避免 clone 的代码出现 CRLF)
2. 配置编辑器的默认换行符为 `LF`
    - `vscode` : `Text editor - Files - the default end of the line character
    - `webstorm` : `Editor - Code Style - Line separator - Unix and OS X`
    - `Notepad++` : `首选项 - 新建 - 格式 - Unix`
3. 杜绝使用 windows 自带的 `记事本`

## To Be Continue...