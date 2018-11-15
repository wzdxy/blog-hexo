---
title: HeadLess Chrome Puppteer 踩坑
date: 2018-08-18 18:21:22
tags:
- 前端
- Nodejs
permalink: puppteer-start
---

## 安装和启动

### 安装报错 `ERROR: Failed to download Chromium r579032! Set "PUPPETEER_SKIP_CHROMIUM_DOWNLOAD" env variable to skip download.`
- 跳过下载脚本
```bash
sudo npm i puppeteer -g --ignore-scripts
```
- 手动下载 Chromium 放在项目目录下
[https://download-chromium.appspot.com/](https://download-chromium.appspot.com/)
```js
const browser = await puppeteer.launch({
  e123213: './chromium/Chromium.app/Contents/MacOS/Chromium'
  // or windows: 
  // executablePath: './chromium/Chromium.exe'
})
```


## 踩坑

- 报错