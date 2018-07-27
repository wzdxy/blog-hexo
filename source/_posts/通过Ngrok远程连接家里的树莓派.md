---
title: 通过Ngrok远程连接家里的树莓派
date: 2016-09-16 10:13:18
tags: 
- 树莓派
- Linux
- SSH
---

1、登录http://www.ngrok.cc/ 官网注册并新增一个隧道，选择TCP协议，端口号随遍写一个，本地IP在树莓派上执行`ifconfig`查看，保存后复制获得的`id`

2、在树莓派下载Ngrok：`wget http://hls.ctopus.com/sunny/linux_arm.zip`

3、解压：`unzip linux_arm.zip`

<!-- more -->

4、运行：`./ sunny cliendid id`

5、SSH登录`server.ngrok.cc:端口号`即可远程连接到树莓派

6、可选进阶：通过screen使Ngrok后台运行：

- `Ctrl+C`暂时关闭ngrok

- 下载screen `apt-get install screen`

- 创建一个新窗口`screen -S ngrok`

- 重新启动ngrok

- `Ctrl+A+D`快捷键切回主窗口

- `screen -ls`查看所有窗口



