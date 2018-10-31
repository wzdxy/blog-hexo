---
title: 无聊向 —— RGB彩虹色渐变算法
date: 2016-09-19 08:03:30
tags: 
- 前端
permalink: rainbow-colors-grndient
---

最近在做IFE的课程，其中有一道题是展示队列排序的可视化过程，做好了之后是酱婶的：
![](https://static.wzdxy.com/img/772107-20160402085414910-1600247409.png)
有序的部分灰度按照大小排列，感觉有点丑，突然想炫酷一下，做成彩虹色渐变的，红橙黄绿青蓝紫

<!-- more -->

先搜集到七种颜色的RGB值，放到Excel里统计一下
![](https://static.wzdxy.com/img/772107-20160402085819238-2080422995.png =100*100)
然后做个图
![](https://static.wzdxy.com/img/772107-20160402085837910-1763180542.png)
这个色彩规律看起来还是出乎意料的明朗嘛，全都是线性的
按照初中数学的方法，把图像分成五部分，分段求解，很容易就列出方程来了：

```
/*省略了外部的setInterval*/
var i=0;                    //当前数据位置
var full=arrData.length;    //数据总数
var r=0;
var g=0;
var b=0;
if(i<full/3){
    r=255;
    g=Math.ceil(255*3*i/full);
    b=0;
}else if(i<full/2){
    r=Math.ceil(750-i*(250*6/full));
    g=255;
    b=0;
}else if(i<full*2/3){
    r=0;
    g=255;
    b=Math.ceil(i*(250*6/full)-750);
}else if(i<full*5/6){
    r=0;
    g=Math.ceil(1250-i*(250*6/full));
    b=255;
}else{
    r=Math.ceil(150*i*(6/full)-750);
    g=0;
    b=255;
}
nLi[i].style.backgroundColor='rgb('+r+','+g+','+b+')';         //将柱体按照算好的RGB值填充
nLi[i].style.color='rgb('+(r-80)+','+(g-80)+','+(b-80)+')';    //柱体上的数字用稍暗的颜色
++i;
```
完工：
![](https://static.wzdxy.com/img/772107-20160402090941035-2027216672.png)
演示地址：http://wzdxy.github.io/ife/t19.html

###### UPDATE:
原来用 CSS3的HSL 可以直接实现，囧
![](https://static.wzdxy.com/img/772107-20160406233005562-836110171.gif)