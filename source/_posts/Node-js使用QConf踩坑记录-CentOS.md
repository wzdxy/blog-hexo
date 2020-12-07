---
title: Node.js使用QConf踩坑记录(CentOS)
date: 2020-12-07 20:53:04
tags:
permalink: node-qconf-start
---

## 一、安装QConf客户端（如果服务器上已安装可以跳过此步骤）
### 1、安装CMake （如果已安装可以跳过）
#### 1.1 准备编译环境

```bash
yum -y install gcc gcc-c++
```


#### 1.2 获取源码，并解压

```bash
wget https://github.com/Kitware/CMake/releases/download/v3.19.1/cmake-3.19.1.tar.gz
tar -zxf cmake-3.19.1.tar.gz
cd cmake-3.19.1
```

#### 1.3 编译安装
```bash
./bootstrap --prefix=/usr --datadir=share/cmake --docdir=doc/cmake && make
sudo make install
cmake --version # 检查是否正确安装
```

## 2、安装 QConf

```bash
git clone git@github.com:Qihoo360/QConf.git  (如果没有权限可以直接去 Github 主页下载 zip 包)
cd QConf/
mkdir build && cd build
cmake ..
make
make install
```



## 3、启动

```bash
/usr/local/qconf/bin/qconf_agent
```


结尾可能出现 `Failed to get conf!` 是一个 WARNING，可以暂时忽略，已经启动成功了。



## 二、在 Node.js 调用
### 1、在项目中安装 node-qconf
首先配置环境变量

```bash
export QCONF_INSTALL=/home/work/local/qconf
```

安装依赖
```bash
npm install node-qconf
```


### 2、调用
```js
// qconf.js
console.log('启动')
try {
  var qconf = require('node-qconf')
  console.log('version:', qconf.version())
} catch (e) {
  console.error(e)
}
```

qconf 的错误处理不太完善，又十分依赖本机环境，容易出现程序直接中断而没有报错的情况。因此需要 try catch （包括 require('node-conf') 语句）


## 三、常见问题


Q：报错：`Error: QConf init failed: 201`

A：大概率是因为 QConf 没有启动 （参考 https://github.com/Qihoo360/QConf/issues/22）





Q：npm 安装 node-qconf 报错：

```bash
../qconf.cc:2:19: fatal error: qconf.h: No such file or directory
#include <qconf.h>
^
compilation terminated.
```

A：安装 node-qconf 前，需确保 QConf 已经被正确安装，并配置了 QCONF_INSTALL 环境变量




Q：`require('node-qconf')` 报错：

```bash
Error: libqconf.so: cannot open shared object file: No such file or directory
at Object.Module._extensions..node (internal/modules/cjs/loader.js:731:18)
at Module.load (internal/modules/cjs/loader.js:612:32)
at tryModuleLoad (internal/modules/cjs/loader.js:551:12)
at Function.Module._load (internal/modules/cjs/loader.js:543:3)
at Module.require (internal/modules/cjs/loader.js:650:17)
at require (internal/modules/cjs/helpers.js:20:18)
at Object.<anonymous> (/home/wwwroot/acs-platform-server/node_modules/node-qconf/qconf.js:1:80)
at Module._compile (internal/modules/cjs/loader.js:702:30)
at Object.Module._extensions..js (internal/modules/cjs/loader.js:713:10)
at Module.load (internal/modules/cjs/loader.js:612:32)
```

A：找不到`libqconf.so`文件，需要在/usr/lib或/usr/lib64下创建libqconf的软连接

```bash
sudo ln -s /usr/local/qconf/lib/libqconf.so /usr/lib64/libqconf.so
```



参考链接：

https://github.com/Qihoo360/QConf

https://github.com/Qihoo360/QConf/blob/master/doc/Qconf%20Node%20Doc.md

https://github.com/bluedapp/node-qconf




