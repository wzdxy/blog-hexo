---
title: Ubuntu 部署 Yii2 遇到的坑
date: 2018-03-26 16:03:29
tags: 
- Linux
- Yii2
- Apache
permalink: ubuntu-yii2
---

## `var/www` 目录下 `git clone` 没有权限

[amazon教程](http://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/install-LAMP.html)

## apache vhosts 配置

<!-- more -->

```
<VirtualHost *:80>
        ServerName test.zchi.me
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/vue2-in-yii2/frontend/web      
</VirtualHost>
<VirtualHost *:80>
        ServerName admin.zchi.me
        ServerAdmin i@zchi
        DocumentRoot /var/www/html/vue2-in-yii2/backend/web
</VirtualHost>
```

## apache rewrite 模式未开启

`sudo a2enmod rewrite`
