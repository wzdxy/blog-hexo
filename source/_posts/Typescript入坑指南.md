---
title: Typescript入坑指南
date: 2019-12-22 00:03:06
tags:
- Javascript
- Typescript
permalink: ts-start
---

## 用命令行编译 ts 文件
```shell
# 安装
npm i typescript -g
# 编译
tsc hello.ts
```

## 在 VSCode 中直接调试 TS 文件

<!-- more -->

### 1. 在根目录创建 `tsconfig.json`
```json
{
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "outDir": "out",
    "sourceMap": true // 用于断点调试
  }
}
```

### 2. 在 VSCode 的命令窗格(Ctrl/Command + Shift + P)中执行 `Run Task` - `tsc:watch - tsconfig.json`
这个操作将会启动一条任务, 功能是监听 ts 文件变化, 并实时按照 `tsconfig.json` 的配置编译成 js 文件


### 3. 创建一个调试配置 `launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch Program",
      "program": "${file}",
      "outFiles": [
        "${workspaceFolder}/out/**/*.js"
      ]
    }
  ]
}
```

### 4. 开始调试

切到要调试的 ts 文件, 按下F5即可运行当前文件, 支持打断点调试

因为 Task 已经实时做了编译, 也不需要每次写完 ts 再用 tsc 手动编译了

一键即可快速运行

![](https://static.wzdxy.com/img/20191222001544.png)