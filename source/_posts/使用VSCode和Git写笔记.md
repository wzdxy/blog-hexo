---
title: 使用VSCode和Git写笔记
date: 2019-05-25 10:44:34
tags:
- VSCode
- Git
permalink: note-with-vscode-and-git
---

## 原因
各种云笔记用来用去, 写Markdown体验最好的还是 VSCode, 所以决心折腾一下, 把 VSCode 打造成一款Markdown笔记工具.


## 优势
- VSCode 强大的编辑功能
- Git 自带更完善的版本控制
![20190525113212.png](https://static.wzdxy.com/img/20190525113212.png)

- 自建同步, 不受第三方控制
- 迁移方便

## 解决痛点
- 图片的插入, 代码编辑器不像云笔记软件, 可以方便的上传图片, 且无需关心存储.
- 分享和演示
- 笔记管理, 搜索, 标签, 归档等功能

<!-- more -->

✔ 图片插入的问题, 使用VS-Picgo插件解决.
✔ 使用 `vscode-reveal` 插件实现演示, 使用 `Marp` 插件实现导出PDF
✖ 暂未解决, 也许可以在 Tree View 的位置开发一个管理笔记的 VSCode 扩展

## 图片插入
PicGo 是一个专门上传图片的工具, 支持又拍云, 七牛云, 阿里云等私有云存储, 也支持 sm.ms 等免费图床. 很早就发布了桌面版本, 现在也推出了 VSCode 扩展.

### 安装和配置
首先需要在 VSCode 扩展商店里安装 PicGo.
![20190525111915.png](https://static.wzdxy.com/img/20190525111915.png)

如果你已经配置过 PicGo 的桌面版软件, 只需导入其配置文件文件即可开始使用.
![20190525112420.png](https://static.wzdxy.com/img/20190525112420.png)
如果没有现成的配置文件, 就需要在 VSCode 的 `Settings` 里手动配置 (建议安装一个桌面版, 先在桌面版里配置, 这样两个平台就可以同步一份配置)

### 使用方法
PicGo 支持剪贴板上传, 文件上传, 路径上传, 以及自定义文件名, 十分方便
![20190525112620.png](https://static.wzdxy.com/img/20190525112620.png)

## 同步
Github 最近推出了私有仓库, 可以用来同步笔记.
这个操作就很简单了, 直接创建私有仓库, clone 下来用 VSCode 打开即可随意创建文件.

按照 Git 的方式提交和同步即可.


## 编写
建议采用 Hexo 的规范, 每篇笔记定义 `Title`, `Tag`, `Data` 和等信息.
这种笔记方式也是受到了 Hexo 的启发, 后续的完善也会更多的借鉴 Hexo.
```
---
title: 使用VSCode和Git写笔记
date: 2019-05-25 10:44:34
tags:
- VSCode
- Git
permalink: note-with-vscode-and-git
---
```

## 演示
`Reveal.js` 是一个基于 HTML 技术的幻灯片工具, 可以用 HTML 或 Markdown 的语法创建幻灯片, `vscode-reveal` 是基于 `Reveal.js` 的VSCode 插件, 可以实现以幻灯片形式直接演示 Markdown 文件.
- 安装插件
![20190525165728.png](https://static.wzdxy.com/img/20190525165728.png)
- 根据`Reveal.js` 的语法, 用 `---` 给笔记分节, 每节在幻灯片中会展示为一页.
- `F1` 打开命令, 输入 Revealjs 可以看到所有命令
![20190525170152.png](https://static.wzdxy.com/img/20190525170152.png)
- 选择 `Open presentation in browser` 即可启动一个服务, 并在浏览器中展示生成的幻灯片. 同时在 VSCode 的状态栏可以看到幻灯片和服务的状态, 也可以点击按钮停止服务.
![20190525170513.png](https://static.wzdxy.com/img/20190525170513.png)