---
title: 利用scp命令通过终端传输文件
date: 2018-09-02 22:44:01
tags:
- Linux
permalink: scp
---

## 简介
`scp` 命令全称 `secure copy`, 是基于ssh的远程文件拷贝命令。可以用于在本机和服务器之间复制文件和目录。

```bash
% scp
usage: scp [-12346BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
           [-l limit] [-o ssh_option] [-P port] [-S program]
           [[user@]host1:]file1 ... [[user@]host2:]file2
```

可使用 `man scp` 命令查看各参数的详细说明

## 基本用法
本地文件上传到服务器 (使用密钥)
```bash
scp -i ~/.ssh/key.pem ~/web/index.html username@xx.xx.xx.xx:/var/www/web/index.html 
```
<!-- more -->
服务器下载到本地 (使用密钥)
```bash
scp  -i ~/.ssh/key.pem username@xx.xx.xx.xx:/var/www/web/index.html ~/web/index.html
```
传输文件夹, 使用 `-r` 参数
```bash
scp -i ~/.ssh/key.pem -r ~/web username@xx.xx.xx.xx:/var/www/web 
```

## 利用 ssh config 配置文件简化命令
如果配置了`~/.ssh/config` (参考 [在 mac & linux 终端中连接 ssh](/2018/07/terminal-ssh/)) , 可以使用主机名代替认证参数, 用户名和主机地址

```
scp  -r ~/web vps1:/var/www/web
```

## 上传文件到服务器 `Permission denied`解决方法
```
scp: /var/www/index.html: Permission denied
```
目标目录没有写入权限, 可以先复制到有权限的文件夹(如`/tmp`), 再 ssh 到服务器上进行操作