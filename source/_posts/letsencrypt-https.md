---
title: Let's Encrypt 申请通配符证书
date: 2018-07-28 18:16:16
tags:
- Linux
- HTTPS
permalink: letsencrypt-ssl
---

从2018年3月开始, [Let's Encript](https://letsencrypt.org/) 支持通配符证书, 也就是一个域名下的多个子域名, 只需要申请一个证书.
免去了每增加一个新(xiao)站(ye)点(mian)就要申请一次证书的麻烦.

<!-- more -->

1. 安装 certbot 和 python-certbot-nginx
```bash
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx 
```

2. 安装 certbot dnspod 插件
```bash
# 需安装 pip3
pip3 install certbot-dns-dnspod
```
3. 执行脚本
```bash
# 其中 wzdxy.com 就是自己的域名
sudo certbot certonly -a certbot-dns-dnspod:dns-dnspod --certbot-dns-dnspod:dns-dnspod-credentials ~/dnspod/credentials.ini -d wzdxy.com -d "*.wzdxy.com"
``` 

3. 记住生成的证书和 key, 在服务器里配置 ssl
```ini
server{
    listen 80;
    listen [::]:80;
    server_name blog.wzdxy.com;
    root /var/www/blog-hexo/public;
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/wzdxy.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/wzdxy.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    if ($scheme != "https") {
        return 301 https://$host$request_uri;
    }
}
```

4. 自动续订
```
certbot-auto renew
```