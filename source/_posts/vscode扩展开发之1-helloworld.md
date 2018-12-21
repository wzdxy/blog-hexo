---
title: vscode扩展开发之1-hello world
date: 2017-07-01 23:54:11
tags:
- vscode
permalink: vscode-ext-1
---

# Hello Word
## 环境搭建

```
npm install -g yo generator-code
yo code //choose New Extension(TypeScript)
```

## 运行
- 使用 VS Code 打开刚创建的文件夹, F5运行
- 在新打开的窗口中 F1 调用命令 `Hello World`
- 看到弹出消息框表示成功

## 生成代码(Generated Code)
- 每个扩展都从 `activate()` 函数输出, VSC只会在 `activationEvents` (在`package.json`中描述)触发时调用这个函数**一次**
- 如果扩展使用系统资源 (如生成过程) ,扩展可以从输出自 `deactivate()` 函数, 这个函数会在VSC关闭的时候被调用
- 当前这个扩展引入了 `vscode` API并且注册了一个命令, 它关联着一个函数, 并且可以在`extention.sayHello`被调用时触发, 显示一个`Hello World`的通知信息

## 各个文件说明
- `.vscode/launch.json` 在开发模式下定义启动规则
- `.vscode/settings.json` 默认排除了`out`文件夹, 可修改想要隐藏的文件
- `.gitignore`
- `-vscodeignore` 发布扩展时要忽略的文件夹
- `README.md` 针对扩展的描述
- `vsc-extension-quickstart.md` 扩展开发的快速指南
- `test/extension.test.ts` 测试

## 扩展激活过程
- 扩展开发实例发现扩展, 并读取 `package.json` 文件
- 用户按下 `Ctrl+Shift+P`:
    - 命令面板显示出被注册的命令
    - 命令列表中会有一个`Hello World`, 它已经在 `package.json` 中被注册了
- 选择了 `Hello World` 之后:
    - 调用`extension.sayHello` **命令** (command) 
    - 创建`onCommand:extension.sayHello` **活动事件** (activation event)
    - 这个活动事件的所有扩展清单都会被激活(?)
    - 加载 `./out/src/extension.js` 到 JavaScript 虚拟机
    - 调用 `activate` 函数
    - 注册 `extension.sayHello` 命令, 定义了其具体实现 `implementation`
- 调用 `extension.sayHello` 实现函数
- 显示 "Hello World" 消息

## 离线安装自己的扩展
- Windows: `%USERPROFILE%\.vscode\extensions`
- Mac/Linux: `$HOME/.vscode/extensions`

## 发布扩展
[click me](https://code.visualstudio.com/docs/extensions/publish-extension)