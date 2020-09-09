---
title: VSCode中的油猴--powertools插件试用
date: 2020-09-09 09:43:38
tags:
permalink: powertools-start
---

## 简介
Power Tools 是一个 VSCode 插件, 可以让用户随时编写自己的脚本, 并能很方便地在 VSCode 中运行, 而且支持 VSCode 扩展的 API.
下面来使用 Power Tools 实现一个半自动 px 转 rpx 的快捷功能.

## 使用条件
- VSCode
- Power Tools 插件

## 一、 安装
直接从 [ego-digital.vscode-powertools](https://marketplace.visualstudio.com/items?itemName=ego-digital.vscode-powertools) 安装
或在VSCode中搜索
![](https://static.wzdxy.com//img/Code_VCt9E3tfVC.png)

## 二、 配置

### F1启动命令窗口， 输入 settings 搜索， 选择 settings（JSON）

![](https://static.wzdxy.com/img/M8MeV2WaSw.png)

### 在底部添加配置, 创建一个名为 `px2rpx` 的命令， 并指向 `px2rpx.js` 文件

```JSON
"ego.power-tools": {
      "commands": {
          "px2rpx": {
              "script": "px2rpx.js",
              "button": {
                  "text": "Click here to start the command."
              },

          }
      }
  }
```
![](https://static.wzdxy.com/img/Code_h8RO4tBXrJ.png)

### 在项目目录下的 .vscode 文件夹下创建 `px2rpx.js` 文件, 内容如下:

```JS
exports.execute = async (args) => {
  // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.buttonactionscriptarguments.html

  // s. https://code.visualstudio.com/api/references/vscode-api
  const vscode = args.require('vscode');
  const activeTextEditor = vscode.window.activeTextEditor;
  const selection = activeTextEditor.selection
  const oldText = activeTextEditor.document.getText(selection)
  const r = /^(\d+)px$/.exec(oldText)
  if (r!==null) {
    const newText = r[1] * 2 + 'rpx'
    activeTextEditor.edit(builder => {
      builder.replace(selection, newText);
    })
    vscode.window.showInformationMessage(`${oldText} => ${newText}`)
  } else {
    vscode.window.showInformationMessage(`没有选中PX值`);
  }
};

```

![](https://static.wzdxy.com/img/CwL4GYcTIr.png)

## 三、试用

配置完成后, 在 VSCode 左下角会出现一个按钮, 选中代码中的 `12px`, 点击按钮, `12px` 就会被替换成 `24rpx` 了.
![](https://static.wzdxy.com/img/vUvwZNo4dq.png)

## 四、配置快捷键

点击鼠标很不方便, 我们可以为这段脚本配置一个快捷键.
在 `File-Preference-Keyborad Shorcuts` 中, 搜索 `px2rpx`, 双击设置一个快捷键, 我设置为了 `Ctrl + Alt + Shift + A`.
现在就可以流畅快速的操作了, 只需要`双击鼠标-按快捷键-双击鼠标-按快捷键`.

![](https://static.wzdxy.com/img/px2rpx.gif)