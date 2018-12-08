---
title: 在 mac & linux 终端中连接 ssh
date: 2018-07-30 20:08:22
tags:
- Mac
- Linux
- SSH
permalink: terminal-ssh
---

### 手动模式

```bash
ssh -i privatekey.pem user@my.server.com
```

### 配置 `~/.ssh/config` 文件

按照以下格式配置即可, 支持多个 `ssh` 配置, 这样就可以任意连接多台服务器了

```ini
Host servername           # 别名，域名缩写
HostName sever.com        # 域名/IP
User username             # 登录该域名使用的账号名
IdentityFile ~/.ssh/id_rsa # 私钥文件的路径
```

使用: `ssh servername` , 支持 `tab` 补全

### 现在 windows10 也支持这些 ssh 操作了~
在 CMD 和 PowerShell 里都可以用