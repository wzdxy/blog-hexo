---
title: 使用 Symbol SVG 图标
date: 2017-11-26 11:33:22
tags: 
- 前端
- HTML
- SVG
permalink: icon-font-svg
---

### 一. 绘制图标 , 得到多个 SVG 文件

### 二. 用 IcoMoon 生成 SVG Sprite

1. 打开 [IcoMoon](https://icomoon.io/app) 网站 , 导入 SVG

2. 选择要包含的图标 , 点击 `Generate SVG & More`

<!-- more -->

3. 设置导出选项, 点击 `download `保存

    - `Minify JS code (for SVG <use> polyfill)` IE 浏览器 external polyfill

    - `Class Prefix` 类名前缀
    - `Use class selector ` 给 svg 标签加上类名

### 三. 在页面上使用

- 在 html 中直接加载 svg 标签
    1. 将 SVG 内容复制到 html 文件中
    2. 使用:
        ```html
        <svg class="icon icon-相机"><use xlink:href="#icon-相机"></svg>
        ```

- 使用 external svg
    1. 将 symbol-defs.svg 放在网站目录下 (需要有服务器环境才能加载)
    2. 引入 svgxuse.min.js (可选, IE 的 pollyfill)
    3. 使用 (以和 html 放在同一录下为例):
    ```html
    <svg class="icon icon-相机"><use xlink:href="symbol-defs.svg#icon-相机"></use></svg>
    ```

### 四. 完善

- 为了代替图标字体, 需要将字体宽和高置为 `1rem` , 并使用 `color` 样式填充
    ```css
    svg.icon {
        display: inline-block;
        width: 1em;
        height: 1em;
        stroke-width: 0;
        stroke: currentColor;
        fill: currentColor;
    }
    ```