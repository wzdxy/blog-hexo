---
title: post
date: 2019-09-28 22:44:42
tags:
- Flutter
permalink: flutter-alignment
---

# Flutter Alignment 属性总结和应用(雪碧图)

## 一. 需求分析
实现一个等级标识组件
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569597600342-be0f8973-79d8-4fb1-bf49-245fee8baf76.png#align=left&display=inline&height=34&name=image.png&originHeight=68&originWidth=139&size=5921&status=done&width=69.5)
提供的图片是一张水平方向的雪碧图
![level-ver750.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569597656558-9ec3f158-cd18-442f-b235-a48d4d95fedb.png#align=left&display=inline&height=28&name=level-ver750.png&originHeight=28&originWidth=1374&size=27187&status=done&width=1374)
## 二. Alignment 属性
这个属性可以让图片的显示位置偏移, 功能类似 css 中的 background-position 
**调用: Alignment(x, y) , x y 分别表示水平和垂直方向的偏移 , 初始值均为 0**
**-1 表示图片最左侧 , 1表示图片最右侧**
**虽然实际上容器是不动的 , 偏移的是图片, 但为了便于理解, 可以认为图片静止, 容器是一个移动的选区 , 确定位置后"抠"出图来显示到界面, 如下图 (虚线框代表容器) :**
![11123334.gif](https://cdn.nlark.com/yuque/0/2019/gif/170329/1569601470711-6528bd66-3315-45bd-bd18-2fc8627cbe02.gif#align=left&display=inline&height=184&name=11123334.gif&originHeight=184&originWidth=709&size=388726&status=done&width=709)

[官方文档](https://api.flutter.dev/flutter/painting/Alignment-class.html)

### 基本用法
![2.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569598215330-9ab4d667-9a96-442b-abe4-790941dca7cb.png#align=left&display=inline&height=55&name=2.png&originHeight=100&originWidth=1000&size=8102&status=done&width=553)
**先用这张规则的图片做一些尝试**
首先设定图片的宽高
```dart
String imageUrl = 'https://static.soyoung.com/sy-pre/2-1569589803824.png';
double width = 400;
double height = 40;
```

配置 Container 的 decoration 属性 , 用 BoxDecoration 和 DecorationImage 组件实现.
如下代码, 会将图片完全渲染
```dart
Container(
  width: width,
  height: height,
  decoration: new BoxDecoration(
    image: DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.fitHeight,
      alignment: Alignment(0, 0),
  )),
```

![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569598428717-ef5abf70-231d-466a-adf6-79836b903c03.png#align=left&display=inline&height=122&name=image.png&originHeight=243&originWidth=1067&size=24488&status=done&width=534)

**控制宽度**
```dart
Container(
  width: width * 0.2, // 修改容器宽度即可
  height: height,
  decoration: new BoxDecoration(
    image: DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.fitHeight,
      alignment: Alignment(0, 0)),
  )),
```

![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569598521437-fc77272f-24f3-412f-acd1-6a3aba5e1693.png)










```dart
Container(
  width: width * 0.1, // 同上, 再次修改容器宽度
  height: height,
  decoration: new BoxDecoration(
    image: DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.fitHeight,
      alignment: Alignment(0, 0)),
  )),
```
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569598646159-8a65607f-8720-4c7f-aa64-5c6014dfbd6f.png#align=left&display=inline&height=126&name=image.png&originHeight=251&originWidth=487&size=11883&status=done&width=243.5)

**增加简单的偏移**
```dart
Container(
  width: width * 0.1,
  height: height,
  decoration: new BoxDecoration(
    image: DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.fitHeight,
      alignment: Alignment(-1, 0)), // (1, 0) 即可仅显示10
  )),
```
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569598751987-91c59910-dd4a-4d57-b5f7-a90b92535fdc.png#align=left&display=inline&height=121&name=image.png&originHeight=241&originWidth=284&size=5436&status=done&width=142)![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569598848127-602eb0f4-2f51-4c9a-b5e2-6ce0ef728811.png#align=left&display=inline&height=114&name=image.png&originHeight=228&originWidth=274&size=7188&status=done&width=137)

以上是简单的偏移,  这仅能控制左右对齐 , 想偏移到更多的位置, 就需要增加一点计算:
**显示5和6的位置**
```dart
// 5
Container(
  width: width * 0.1,
  height: height,
  decoration: new BoxDecoration(
    image: DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.fitHeight,
      alignment:
      Alignment( 0.05/0.45, 0)),
  )),
// 6
Container(
  width: width * 0.1,
  height: height,
  decoration: new BoxDecoration(
    image: DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.fitHeight,
      alignment:
      Alignment(-0.05/0.45, 0)),
  )),
```
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569599075107-0c8b586a-dea8-4093-be9c-0167089311d9.png#align=left&display=inline&height=120&name=image.png&originHeight=240&originWidth=244&size=6481&status=done&width=122)![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569599089699-f1b24526-1f48-4d56-b9f0-325cc8c4bfc5.png#align=left&display=inline&height=118&name=image.png&originHeight=236&originWidth=211&size=6701&status=done&width=105.5)
此时传给 Alignment  的 x 值 , 是十分诡异的 ±0.05/0.45 ≈ ±0.111111
为什么这样算呢? x 值的获取可以总结为一个公式:
**x = d1/d2**
d1 = **初始状态**时**图片左边界**到**容器左边界**的距离
d2 = **目标状态**时图片的偏移量
初始状态 (未偏移时, 选框居中) 如下图 , d1 = width * 0.45
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569599738181-0c8e10e3-3c43-40d4-98c2-8d2be38c6825.png#align=left&display=inline&height=75&name=image.png&originHeight=150&originWidth=710&size=10677&status=done&width=355)

目标状态 , 选框 (相对上图中的选框) 从中心往左移动了半个格, 则 d2 = width * -0.05

![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569599882826-fa396454-74a2-4bd7-a1c4-4e18cff7dfc1.png#align=left&display=inline&height=88&name=image.png&originHeight=175&originWidth=697&size=11215&status=done&width=348.5)

同理 , 若要展示2 , d2 为 width * -0.35 , x = -0.35/0.45 ≈ -0.777777777777778
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569600493784-11614a4f-bd3b-4338-816a-6029dea5cf9b.png#align=left&display=inline&height=81&name=image.png&originHeight=161&originWidth=705&size=11164&status=done&width=352.5)

同理,  若要展示8,  d2 为 width * 0.25 , x = 0.25/0.45 ≈  0.555555555555556
![image.png](https://cdn.nlark.com/yuque/0/2019/png/170329/1569603413976-543a6185-0a39-42ea-a51e-ba44796c8e8f.png#align=left&display=inline&height=66&name=image.png&originHeight=132&originWidth=695&size=10487&status=done&width=347.5)

### 三. 实际应用
回到等级标识的问题 , 现在可以封装一个方法计算每个 level 的偏移量
```dart
// 考虑到不同等级的图片宽度是不同的, 还需要提供每个等级图片的宽度
List<double> itemWidthList = [60, 60, 60, 60, 60, 60, 62, 62, 62, 62, 66, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70]; // 横向雪碧图中每个小图的宽度
Map getLevelStyle(int level) {
    double totalWidth = 0; // 图片总宽度
    double positionX = 0; // 图片左边的位置
    double width; // 当前等级图片的宽度
    int i;
    // 循环计算出 整个图片的宽度 和 需要的图片所在位置
    for (i = 0; i < itemWidthList.length; i++) {
      if (i < level) positionX += itemWidthList[i];
      if (i == level) width = itemWidthList[i];
      totalWidth += itemWidthList[i];
    }
  	// 初始状态(图片和容器中心点重合) 图片左边界到容器左边界的距离, 即 d2
    double zeroPosition = totalWidth/2 - width / 2;
  	// 目标状态时, 图片的偏移量, 即 d1
    double distanceToCenter = positionX - zeroPosition;
  	// x = d1/d2
    double alignmentX = (distanceToCenter / zeroPosition);
    print('level $level, $positionX, $distanceToCenter, $alignmentX, $totalWidth');
    return {
      "x": alignmentX,
      "width": width
    };
  }
```