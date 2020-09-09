---
title: vscode中的油猴--powertools插件试用
date: 2020-09-09 09:43:38
tags:
permalink: powertools-start
---

## 简介
PowerTools 是一个 VSCode 插件, 可以让用户随时编写自己的脚本, 并能很方便地在 VSCode 中运行, 而且支持 VSCode 扩展的 API.
下面来使用 PowerTools 实现一个半自动 px 转 rpx 的快捷功能.

## 使用条件
- vscode

## 一、 安装
[ego-digital.vscode-powertools](https://marketplace.visualstudio.com/items?itemName=ego-digital.vscode-powertools)

![](https://static.wzdxy.com//img/Code_VCt9E3tfVC.png)

## 二、 配置

### F1启动命令窗口， 输入 settings 搜索， 选择 settings（JSON）

![](https://static.wzdxy.com/img/M8MeV2WaSw.png)

### 在底部添加配置

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

配置完成后, 在 vscode 左下角就可以看到一个按钮, 首先选中代码中的 `12px`, 点击按钮, `12px` 就会变成 `24rpx` 了.
![](https://static.wzdxy.com/img/vUvwZNo4dq.png)

## 四、配置快捷键

点击鼠标很不方便, 我们可以为这段脚本配置一个快捷键.
在 `File-Preference-Keyborad Shorcuts` 中, 搜索 `px2rpx`, 双击即可设置快捷键, 我们设置为 `Ctrl + Alt + Shift + A`.
现在就可以流畅快速的操作了.
![](https://static.wzdxy.com/img/px2rpx.gif)