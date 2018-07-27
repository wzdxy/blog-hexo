---
title: Web安全学习笔记----注入攻击
date: 2017-06-27 23:08:05
tags: 
- 前端
---

## 关键条件:
1. 用户能控制输入
2. 原本要执行的代码被拼接了用户的输入

## 总体原则
- 数据和代码分离

## 分类
- SQL 注入
- XML 注入
- 代码注入
- CRLF 注入

<!-- more -->

## SQL 注入
### 示例
```js
sql = "select * from OrderTable where ShipCity='"+name+"'"
```
- 若用户提交 name 为 `Beijing';drop table OrderTable` , 则原本的SQL语句变为:

```js
sql = "select * from OrderTable where ShipCity='Beijing';drop table OrderTable"
```

### 盲注

- 关闭了错误回显的网站 , 用户不能直接得知数据库的结构, 会增加注入的难度
- 但可以通过改变页面上返回的数据来验证对应位置是否有漏洞

### 防御 SQL 注入

#### 错误的防御 : 
- 简单地过滤特殊符号 . 因为 SQL 注入可以只用数字+字母来完成, 只用黑名单是无法完全防御的 , 如 `SELECT pw from users where user=0x61646D696E` (admin的十六进制编码)

#### 有效的方法 :
- 使用预编译语句
- 使用安全的存储过程
- 检查数据类型
- 使用安全函数
- 最小权限原则 , 避免 APP 使用 root 账户连接数据库

## XML 注入

### 示例
和 SQL 类似, 用户输入带 XML 标签的字符串

### 防御
对XML保留字符转义, 如 `<` , `>` , `\` , `"` , `&` 


## 代码注入
一般由不安全的函数或方法引起 , 实际上可以相当于是后门
### 代码注入示例
如 
```php
$var='varname';
$x=$_GET['arg'];
eval("\$var=$x;");
```
用户输入 `/index.php?arg=1;phpinfo()` 即可执行 `phpinfo()` 语句

### 代码注入的防御

- 养成安全的编程习惯 , 避免使用 evel 之类可以动态执行命令的函数 , 避免动态 include 远程文件

## CRLF 注入

利用换行符 `\r`,`\n` 对依赖换行符作为分隔符的位置进行注入 , 如单行的日志和 HTTP 头

### CRLF注入的防御

处理 `\r` 和 `\n`