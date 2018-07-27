---
title: SQL Server 远程连接配置
date: 2017-03-27 03:51:32
tags: 
---

1. sql server 配置管理器：
   	- SQL Server 服务 —— SQL Server Browser —— 启动；
   	- SQL Server 网络配置 —— MSSQLSERVER 的协议 —— TCP/IP —— 启用
2. windows 防火墙：
   	- 高级设置 —— 入站规则 —— 新建规则 —— 端口，添加 TCP 1433 端口
3. SSMS 数据库属性
   	- 服务器属性 —— 安全性 —— 服务器身份验证 —— 选择 SQL server 和 windows 验证模式
