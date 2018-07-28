---
title: attr(),data(),dateset 之间的差异
date: 2017-03-21 09:45:49
tags: 
- Javascript
- 前端
- HTML
permalink: attr-data-dateset
---

- 使用`jquery`的`data()`函数写入的属性，用dataset属性和attr()方法均不能读取，除此之外都可以相互读取。
- dataset属性等同于attr('data-xx')，是对html的attribute属性进行操作，在标签中可以看到
- `jquery`的`data()`方法，没有写入到html属性中
![](http://odovakhft.bkt.clouddn.com/TIM%E6%88%AA%E5%9B%BE20170321175950.png)
![运行结果](http://odovakhft.bkt.clouddn.com/attr_data_dataset_result.png)