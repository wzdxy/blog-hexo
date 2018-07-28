---
title: 在 electron 中使用 ffi
date: 2017-11-30 20:26:08
tags: 
permalink: electron-ffi
---

[https://github.com/wzdxy/electron-ffi-demo](https://github.com/wzdxy/electron-ffi-demo)

## 搭建 electron 环境

## 安装 node-gyp

```bash
npm i -g node-gyp
```

<!-- more -->

## 安装 fii 和 ref 

- 安装 ffi 即可 , ref 会作为依赖自动安装
```bash
npm i fii
```

## 重新构建 ffi 和 ref

```bash
# 切换到 ffi 路径
cd .\node_modules\ffi\
# 使用 gyp 来构建 , electron 版本号和平台要正确
node-gyp rebuild --target=1.7.9 --arch=x64 --target_arch=x64 --dist-url=https://atom.io/download/electron --msvs_version=2017

# ref 同理, 在 ref 路径下进行相同操作
node-gyp rebuild --target=1.7.9 --arch=x64 --target_arch=x64 --dist-url=https://atom.io/download/electron --msvs_version=2017
```

## 在 electron 中使用
```js
let ffi=require('ffi');
let Dll=ffi.Library('./MyDll.dll',{
'Add':['int','int']
})
console.log(Dll.Add(2,4))   // 6
```

## 报错
- `Error: Dynamic Symbol Retrieval Error: Win32 error 127`
```
Error: Dynamic Symbol Retrieval Error: Win32 error 127
    at DynamicLibrary.get (D:\electron-test\node_modules\ffi\lib\dynamic_library.js:112:11)
    at D:\electron-test\node_modules\ffi\lib\library.js:50:19
    at Array.forEach (native)
    at Object.Library (D:\electron-test\node_modules\ffi\lib\library.js:47:28)
    at App.createWindow (D:\electron-test\main.js:35:17)
    at emitTwo (events.js:111:20)
    at App.emit (events.js:194:7)
```
- 解决方案 : 更换了一个 DLL , 推测是 DLL 的问题