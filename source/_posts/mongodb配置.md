---
title: mongodb配置远程访问
date: 2019-03-16 20:49:09
tags:
- Linux
- MongoDB
permalink: mongo-db-start
---

## 安装
按照官方文档即可

## 配置文件
默认的配置是无验证但仅限本机IP (127.0.0.1) 访问
```yaml
net:
  bindIp: 0.0.0.0
security:
  auth: true
```

<!-- more -->

## 创建用户
```bash
# 创建管理员用户
> db.createUser({user: 'root', pwd:'YOUR PASSWORD', roles:['root']})
Successfully added user: { "user" : "root", "roles" : [ "root" ] }
# 验证测试
> db.auth('root', 'PASSWORD')
1
# 创建数据库用户 ( 以 test 数据库为例)
> db.createUser({user:'rocket',pwd:'YOUR ANOTHER PASSWORD',roles:[{role:'readWrite',db:'test'}]})
Successfully added user: {
	"user" : "rocket",
	"roles" : [
		{
			"role" : "readWrite",
			"db" : "test"
		}
	]
}
```

## 远程连接数据库
以 `MongoDB Compass` 为例
![](https://static.wzdxy.com/img/20190316210520.png)

