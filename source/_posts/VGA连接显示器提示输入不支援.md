---
title: VGA连接显示器提示输入不支援的原因和解决方法
date: 2019-01-08 21:39:53
tags:
- windows
- hardware
permalink: vga-display-error
---

笔记本用 `Dell DA200` type-c hub 转接的 VGA 连接到 HP 外置显示器时, 出现了`输入不支援`的提示
但设备管理器和显示设置中都已经发现了外接显示器, 这原因可能是电脑错误的输出了显示器不支持的分辨率和频率
![](https://static.wzdxy.com/img/20190108215132.png)
<!-- more -->
win10 可以通过以下步骤来修复:
1. 在 `设置` - `显示` 底部, 点击 `高级显示设置` , 选择外接显示器的适配器属性
![](https://static.wzdxy.com/img/20190108213418.png)
![](https://static.wzdxy.com/img/20190108213626.png)
2. 在弹出的菜单中点击 `列出所有模式`, 选择适合自己显示器的配置, 常见的刷新率是60Hz , 如果不确定, 就先选择最低的
![](https://static.wzdxy.com/img/20190108213749.png)

3. 如果配置正确, 外接显示器就可以正常工作了
![](https://static.wzdxy.com/img/20190108215440.png)