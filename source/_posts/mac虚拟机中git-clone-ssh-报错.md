---
title: mac虚拟机中git clone(ssh)报错
date: 2019-07-21 21:08:26
tags:
permalink:
---

在 windows 上用 vmware workstations 安装了一个 macos 虚拟机, clone 代码的时候报错没有权限.
```
packet_write_wait: Connection to 13.229.188.59 port 22: Broken pipe
```

### 解决方案

创建 `~/.ssh/config` 文件:
```
Host *
    IPQoS lowdelay throughput
```
或者执行:
```
sudo dnf downgrade openssh-clients-7.7p1
```

### 原issue链接

[OpenSSH 7.8 causes VMware Workstation and Player networking SSH bug on Linux VMs](https://github.com/vmware/open-vm-tools/issues/287#issuecomment-421347524)
