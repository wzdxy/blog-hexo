---
title: MINA页面导航的传参简单分析
date: 2018-03-08 08:05:43
tags: 
- MINA
- 微信小程序
---

文档目前还比较坑，没提这事，不过可以注意到有一个细节，就是每个页面的`onload()`函数都会带有一个`options`参数，如果在导航url后添加查询字符串，在新页面可以自动将查询字符串解析成对象并可以在`options`访问。

```js
/*index.js*/
wx.navigateTo({
  url: 'test?id=1'
})
```

<!-- more -->

```js
/*test.js*/
onLoad(options){
  console.log(options);
}
```
输出：
![](http://odovakhft.bkt.clouddn.com/QQ%E6%88%AA%E5%9B%BE20160929232130.png)

为了传递比较复杂的参数，可以将OBJECT转成JSON作为查询字符串传入，在新页面解析出来。
```js
/*index.js*/
wx.navigateTo({
   url: '../logs/logs?json={"k":"v","obj":{"p1":"v1","p2":"v2"}}'
})
```
```js
/*test.js*/
onLoad(options){
  console.log(JSON.parse(options.json));
}
```

这样就拿到了要传递的对象了：
![](http://odovakhft.bkt.clouddn.com/QQ%E6%88%AA%E5%9B%BE20160929232701.png)