---
title: 'electron踩坑记录之一:开发环境搭建'
date: 2019-12-16 21:05:44
tags:
- electron
- node
permalink: electron-start-1
---

## 环境要求
- Node.js
- VSCode (建议)

## 新建项目, 安装依赖
```shell
npm init # 在空文件夹中初始化项目
npm i electron -D # 安装 electron 依赖, 注意需要安装为 devDependencies
```
-
## 创建主进程和渲染进程文件

```js
const { app, BrowserWindow } = require('electron')
let win
app.on('ready', () => {
  // 创建一个新窗口
  win = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true // 在这个窗口(渲染进程)中启用Node
    }
  })
  win.loadFile('index.html') // 加载一个 html
})

```

```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Document</title>
</head>

<body>
  <p>Hello Electron</p>
  <pre><script>
    const fs = require('fs')
    document.write(fs.readFileSync('package.json'))
  </script></pre>
</body>

</html>
```

- 项目结构

![](https://static.wzdxy.com/img/20191216222720.png)

## 运行项目
- 编辑 `package.json`, 添加一条 `script`
```JSON
"start": "electron .",
```
![](https://static.wzdxy.com/img/20191216225351.png)

## 调试代码
### 调试主进程(main.js)
- 使用VSCode调试, 创建以下配置文件, 按F5即可在编辑器中打断点调试
![](https://static.wzdxy.com/img/20191216232113.png)
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Main Process",
      "type": "node",
      "request": "launch",
      "cwd": "${workspaceFolder}",
      "runtimeExecutable": "${workspaceFolder}/node_modules/.bin/electron",
      "windows": {
        "runtimeExecutable": "${workspaceFolder}/node_modules/.bin/electron.cmd"
      },
      "args" : ["."],
      "outputCapture": "std"
    }
  ]
}
```

### 调试渲染进程
- **调试普通页面**: 在窗口中按快捷键 `Ctrl/Command + Shift + I` 启动 Chrome Dev Tools, 即可像在Chrome中一样调试
- **使用框架的Devtools调试Vue/React**: Electron支持加载常用前端框架的调试扩展, 如 [vue-devtools](https://github.com/vuejs/vue-devtools), 可以按照[官网提供的方法](https://electronjs.org/docs/tutorial/devtools-extension)加载, (要求电脑上的 Chrome 安装这个扩展)