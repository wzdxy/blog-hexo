---
title: Express入门学习笔记
date: 2016-11-16 16:20:36
tags: 
- Node
- Javascript
permalink: express-start
---

#### 1、 新建Express项目

`npm init`

`npm install express --save`

<!-- more -->

#### 2、 使用Express应用生成器快速创建

`npm install express-generator -g`  安装

`express -myapp` 生成myapp项目

`npm install` 安装依赖

#### 3、 运行项目

`DEBUG=myapp npm start`

#### 4、 托管静态文件
```js
app.use('/static',express.static('public'));   //'第一个参数可选'
```

#### 5、 基本路由
- 用法：

```js
app.METHOD(path, [callback...], callback)
```
```js
app.get('/',function(req,res){
    res.send('Hello Express');
})
```
- 路径可以采用 **字符串模式** 或 **正则表达式** ，如：

```js
app.get('/ab(cd)?e', function(req, res) {
 res.send('ab(cd)?e');
});
```
```js
app.get(/.*fly$/, function(req, res) {
  res.send('/.*fly$/');
});
```

- 路由句柄：多种处理路由的方式：**多个回调函数**、**回调函数数组**

```js
var cb0 = function (req, res, next) {
  console.log('CB0');
  next();
}

var cb1 = function (req, res, next) {
  console.log('CB1');
  next();
}

app.get('/example/d', [cb0, cb1], function (req, res, next) {
  console.log('response will be sent by the next function ...');
  next();
}, function (req, res) {
  res.send('Hello from D!');
});

```

#### 6、路由响应

```js
res.download() 	        //提示下载文件。
res.end() 	            //终结响应处理流程。
res.json() 	            //发送一个 JSON 格式的响应。
res.jsonp() 	        //发送一个支持 JSONP 的 JSON 格式的响应。
res.redirect() 	        //重定向请求。
res.render() 	        //渲染视图模板。
res.send() 	            //发送各种类型的响应。
res.sendFile 	        //以八位字节流的形式发送文件。
res.sendStatus()        //设置响应状态代码，并将其以字符串形式作为响应体的一部分发送。
```

#### 7、链式路由句柄 **`app.router`**

```js
app.route('/book')
  .get(function(req, res) {
    res.send('Get a random book');
  })
  .post(function(req, res) {
    res.send('Add a book');
  });
```

#### 8、模块化路由句柄 **`express.Router`**

```js
var express = require('express');
var router = express.Router();
router.use(function timeLog(req, res, next) {       // 该路由使用的中间件
  console.log('Time: ', Date.now());
  next();
});
router.get('/', function(req, res) {                // 定义网站主页的路由
  res.send('Birds home page');
});
router.get('/about', function(req, res) {           //定义birds
  res.send('About birds');
});
module.exports = router;
```
```js
var birds = require('./birds');
app.use('/birds', birds);                            //可处理birds页面和birds/about页面
```

#### 9、中间件
- 分类：应用中间件，路由中间件，错误处理中间件，内置中间件，第三方中间件
- 应用级中间件：`app.use()`、`app.METHOD`
```js
var app=express();
app.use(function(req,res,next)){          //无挂载路径，app的每个请求都会执行
  console,log('Time',Date.now);
  next();
}
app.get('/user/:id',function(req,res,next){     //处理 /user/:id 的GET请求
  res.send('USER');
})
```

- 路由级中间件 `router.use()`、`route.METHOD`
```js
var app=express();
var Router=express.Router();
router.use(function (req, res, next) {
  console.log('Time:', Date.now());
  next();
});
router.get('/user/:id', function (req, res, next) {
  console.log(req.params.id);
  res.render('special');
});
```
- 错误处理中间件
```js
  app.use(function(err, req, res, next) {
    console.error(err.stack);
    res.status(500).send('Something broke!');
  });
```

- 内置中间件 `express.static(root,[options])`，负责托管静态资源

- 第三方中间件
```
$ npm install cookie-parser
```
```js
var express = require('express');
var app = express();
var cookieParser = require('cookie-parser');
app.use(cookieParser());        // 加载用于解析 cookie 的中间件
//第三方中间件既可以在应用级加载，也可以在路由级加载
```

#### 10、模版引擎 `Jade`

```js
/*index.jade*/
html
  head
    title!= title
  body
    h1!= message
```

```js
app.get('/', function (req, res) {
  res.render('index',{title:req.query.t,message:req.query.m});
});
//访问http://localhost:3000/?t=hey&m=hello_Jade
```


[书签:Express路由](http://www.expressjs.com.cn/guide/using-middleware.html)