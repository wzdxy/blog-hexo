---
title: 修改 Next 主题配色
date: 2018-09-15 10:31:53
tags:
- hexo
permalink: next-theme-edit
---

## 审美是个主观的事
<!-- more -->
![](https://static.wzdxy.com/img/Xnip2018-09-15_11-04-08.png)

## 修改方法(以 Next 的 Pisces 模板为例)

### 定位样式文件
在浏览器中右键想要修改的元素, 点击检查即可查看类名
如 `.site-meta`

![](https://static.wzdxy.com/img/Xnip2018-09-15_10-48-09.png)

在编辑器中全局搜索 `.site-meta`, 可以找到上方标题位的样式文件是 `themes/next/source/css/_schemes/Pisces/_menu.styl`

(可能找到多个文件, 不确定的话多修改几次即可试出来)

![](https://static.wzdxy.com/img/Xnip2018-09-15_10-49-55.png)



### 修改样式表

Next 主题使用 `Stylus` 定义样式

将 `.site-meta` 下的 `background: $black-deep;` 改成 `background: #284498;` , 即替换了标题的背景色为蓝色

## 用同样方法修改菜单的配色
在 `themes/next/source/css/_schemes/Pisces/_menu.styl` 文件, 在 `.menu .menu-item` 下添加样式: 

```styl
&:nth-child(1) {
  a {
    color #3b91f7;
  }
}
&:nth-child(2) {
  a {
    color #70c040;
  }
}
&:nth-child(3) {
  a {
    color #ff6360;
  }
}
&:nth-child(4) {
  a {
    color #fbab25;
  }
}
&:nth-child(5) {
  a {
    color #cf75dc;
  }
}
```

具体代码修改可参考 [wzdxy/hexo-theme-next/commit/2b16e6](https://github.com/wzdxy/hexo-theme-next/commit/2b16e66ed5870393447368813122b8a2fc2891a5)