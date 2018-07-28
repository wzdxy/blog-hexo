---
title: Let's Encrypt 申请通配符证书
date: 2018-07-28 18:16:16
tags:
permalink: letsencrypt-ssl
---

从2018年3月开始, [Let's Encript](https://letsencrypt.org/) 支持通配符证书, 也就是一个域名下的多个子域名, 只需要申请一个证书.
免去了每增加一个新(xiao)站(ye)点(mian)就要申请一次证书的麻烦.

<!-- more -->

1. 下载脚本, 并配置权限
```bash
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto 
```
2. 执行脚本
```
./certbot-auto certonly  -d *.zchi.me --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory
```
    - 其中 *.zchi.me 就是自己的域名
    - 执行脚本后,  会安装一些依赖, 需要点击一下 Y 允许
    - 然后会有所有权验证, 在自己域名的 DNS 里添加一个 TEXT 解析
    - 完成

3. 记住生成的证书和 key, 在服务器里配置 ssl
```ini
server{
    listen 80;
    listen [::]:80;
    server_name blog.zchi.me;
    root /var/www/blog-hexo/public;
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/zchi.me/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/zchi.me/privkey.pem;
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