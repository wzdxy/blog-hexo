---
title: 配置Apache+PhpStorm开发环境的php断点调试
date: 2016-11-02 14:05:15
tags: 
- Yii2
- PHP
permalink: phpstorm-debug
---

给PHP打断点调试，需要PHP、浏览器，IDE三个方面的同时协作，所以整个配置也就需要三个方面。

## 一、准备的材料

1. xampp（Apache+Php）
2. PhpStorm
3. xdebug
4. chrome浏览器

<!-- more -->

## 二、详细步骤
### 1. 配置PHP的Xdebug扩展
- xampp中的php默认已经启用了xdebug，只需在php.ini末尾添加idekey等配置即可。
- 开启后，可以在页面中输出`phpinfo()`来检查xdebug是否成功开启，以及idekey是否配置正确。
- 如果没有开启，可以将zend_extension一行的xdebug注释取消
```
/*php.ini*/
zend_extension = "D:\xampp\php\ext\php_xdebug.dll"
xdebug.remote_enable = on
xdebug.remote_port = 9000
xdebug.remote_handler = "dbgp"
xdebug.remote_host = "127.0.0.1"
xdebug.idekey=PHPSTORM

```

### 2. 设置PhpStorm

1.  `File > settings > Languages&Framworks > PHP > Debug`，配置如图

![](https://static.wzdxy.com/img/PhpStorm%E9%85%8D%E7%BD%AE1.png?imageView/2/w/800)

2.  `Run > Edit Configurations`

- 左上角加号添加 `PHP Remote Debug`

![左上角加号添加 `PHP Remote Debug`](https://static.wzdxy.com/img/%E9%A1%B9%E7%9B%AEdebug1.png?imageView/2/w/800)

- 设置`Servers`和`idekey`，并命名为`T1`

![设置`Servers`和`idekey`](https://static.wzdxy.com/img/%E9%A1%B9%E7%9B%AEdebug2.png?imageView/2/w/800)

点击上图的 `Servers` 右侧的三点按钮，在下图中点击左上角加号，添加Server

![设置`Servers`和`idekey`](https://static.wzdxy.com/img/%E9%A1%B9%E7%9B%AEdebug3.png?imageView/2/w/800)

### 3. 配置Chrome的Xdebug扩展

- 下载Xdebug helper 

![](https://static.wzdxy.com/img/chrome%E4%B8%8B%E8%BD%BDxdebug.png?imageView/2/w/800)

-  `右键扩展图标 > 选项` ，配置 `IDE key`

![](https://static.wzdxy.com/img/xdebug%E6%89%A9%E5%B1%951.png?imageView/2/w/800)

### 4. 开始调试

 - 启动Apache
 - 在`Phpstoem`中给PHP文件添加断点，`Run > Debug 'T1'`
 - 使用Chrome打开localhost,单击Xdebug图标，点击Debug启用

 ![](https://static.wzdxy.com/img/xdebug%E5%90%AF%E5%8A%A8.png)