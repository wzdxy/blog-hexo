---
title: ubuntu1804下hue的编译和安装
date: 2019-04-01 16:32:07
tags:
permalink:
---

## 安装依赖
- 安装 Java (Open JDK 即可)
```bash
sudo apt-get update
sudo apt-get install openjdk-8-jdk
```
- 安装 Maven
```bash
wget http://mirrors.shu.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
tar xzvf apache-maven-3.6.0-bin.tar.gz
#设置环境变量 (替换成自己的解压目录)
export PATH=/home/zchi/apache-maven-3.6.0/bin:$PATH
#查看版本
mvn -v
```
- 安装 Node.js
[Ubuntu16.04安装新版本的Nodejs](/2018/07/install-node-in-ubuntu/)
- 其他依赖
```bash
apt-get install python2.7-dev \
make \
libkrb5-dev \
libxml2-dev \
libffi-dev \
libxslt-dev \
libsqlite3-dev \
libssl-dev \
libldap2-dev \
python-pip
```

```bash
sudo apt-get install ant gcc g++ libkrb5-dev libffi-dev libmysqlclient-dev libssl-dev libsasl2-dev libsasl2-modules-gssapi-mit libsqlite3-dev libtidy-0.99-0 libxml2-dev libxslt-dev make libldap2-dev maven python-dev python-setuptools libgmp3-dev
# 如果报错  Package 'libtidy-0.99-0' has no installation candidate , 执行:
# sudo apt-get install ant gcc g++ libkrb5-dev libffi-dev libmysqlclient-dev libssl-dev libsasl2-dev libsasl2-modules-gssapi-mit libsqlite3-dev libxml2-dev libxslt-dev make libldap2-dev maven python-dev python-setuptools libgmp3-dev
```

- 编译
```

make apps
```

##
