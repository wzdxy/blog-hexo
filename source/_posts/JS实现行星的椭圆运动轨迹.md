---
title: JS实现行星的椭圆运动轨迹
date: 2018-10-14 10:16:48
tags:
- Javascript
- CSS
- HTML
permalink: galaxy
---

使用椭圆的参数方程, 以时间为参数, 再把极坐标转化成直角坐标
用 `setTimeout` 控制关键帧的坐标变化, 再用 CSS3 的 transition 属性, 缓动补间
实际上行星的运动轨迹是个和椭圆接近的多边形, 控制关键帧的时间间隔, 就可以让轨迹比较贴近椭圆

![](https://static.wzdxy.com/img/rotate.gif)

<!-- more -->

## 核心公式
```Javascript
// a,b 椭圆长轴
// x,y 中心坐标
// sin 轨道旋转角度的 sin 值
// sin 轨道旋转角度的 cos 值
// α 行星当前位置角度
x = this.a * sin * Math.cos(α) + this.b * cos * Math.sin(α) + this.x,
y = this.a * cos * Math.cos(α) - this.b * sin * Math.sin(α) + this.y
```

## 代码
```html
<div class="sun"></div>
<div class="earth" id='earth1'>1</div>
<div class="earth" id='earth2'>2</div>
<div class="earth" id='earth3'>3</div>
<div class="earth" id='earth4'>4</div>
<div class="earth" id='earth5'>5</div>
<div class="earth" id='earth6'>6</div>
<div class="earth" id='earth7'>7</div>
```
```js
var windowHeight = window.innerHeight
var windowWidth = window.innerWidth
function Planet(option) {
    this.$earth = $(option.selector || '.earth#earth1')           // 行星的 DOM 元素
    this.radian = option.radian || 0                    // 初始弧度位置 (0在最下方, 2 * PI 为最大值)
    this.rotate = option.rotate || 0                    // 长短轴的偏转角度 (斜椭圆)
    this.step = option.step || 0.15                     // 每个关键帧转动的弧度 (一整圈是 2 * PI 不能太大否则轨迹不是圆弧)
    this.a = option.a || 1.1 * window.innerWidth / 2    // 椭圆参数 a
    this.b = option.b || 0.7 * window.innerWidth / 2    // 椭圆参数 b
    this.x = option.x || 0                              // 椭圆中心 x 坐标
    this.y = option.y || 0                              // 椭圆中心 y 坐标

    this.coord = {}                                     // 当前坐标      

    // 启动
    this.start = function () {
    this.$earth.addClass('transition')
    this.timer = setInterval(function () {
        this.setOnOval(this.radian += this.step)
    }.bind(this), 200)
    }
    // 在椭圆上定位
    this.setOnOval = function (α) {
    var cos = Math.cos(this.rotate * Math.PI / 180)
    var sin = Math.sin(this.rotate * Math.PI / 180)
    this.coord = {
        x: this.a * sin * Math.cos(α) + this.b * cos * Math.sin(α) + this.x,
        y: this.a * cos * Math.cos(α) - this.b * sin * Math.sin(α) + this.y
    }
    this.$earth.css('transform', 'translate(' + (windowWidth / 2 + this.coord.x - 20) + 'px,' + (windowHeight / 2 + this.coord.y - 20) + 'px)')
    }
    return this
}
$(function () {
    // 恒星位于中心
    $('.sun').css('transform', 'translate(' + (windowWidth / 2 - 37) + 'px,' + (windowHeight / 2 - 37) + 'px)')
    // 创建多个行星      
    new Planet({selector: '#earth1',}).start()
    new Planet({selector: '#earth2', radian: 1.0, rotate: -15}).start()
    new Planet({selector: '#earth3', radian: 1.8, rotate: -15}).start()
    new Planet({selector: '#earth4',radian: 2.7,rotate: -15}).start()
    new Planet({selector: '#earth5',radian: 3.7,rotate: -15}).start()
    new Planet({selector: '#earth6',radian: 4.7,rotate: -15}).start()
    new Planet({selector: '#earth7',radian: 5.7,rotate: -15}).start()
})
```

```css
/* 部分代码 */
.sun,
.earth {
    position: absolute;
    display: inline-block;
    color: #fff;
}

.sun {
    width: 20vw;
    height: 20vw;
    background-color: #c92;
    border-radius: 50%;
}

.earth {
    width: 10vw;
    height: 10vw;
    background-color: #46c;
    border-radius: 50%;
    line-height: 10vw;
    text-align: center;
}

.transition {
    transition: .2s all linear;
}
```

## 问题

这样用定时器去控制是不太好的, 运行一段时间之后, 行星直接的距离就会变化(行星会追尾, 当然如果每个轨道上只有一个行星的话也没关系)

<p data-height="615" data-theme-id="0" data-slug-hash="bmoBmp" data-default-tab="html,result" data-user="wzdxy" data-pen-title="bmoBmp" class="codepen">See the Pen <a href="https://codepen.io/wzdxy/pen/bmoBmp/">bmoBmp</a> by wzdxy (<a href="https://codepen.io/wzdxy">@wzdxy</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

[线上例子 Demo, 建议手机模式预览](https://doc.wzdxy.com/rotate.html)