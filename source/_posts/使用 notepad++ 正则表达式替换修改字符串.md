---
title: 使用 notepad++ 正则表达式替换修改字符串
date: 2017-08-20 06:20:02
tags: 
- software
- notepad++
permalink: npp-reg-replace-string
---

### 1. 查找目标

正则查找要替换的字符串 , 如 :

```
^(?!.*MaxCount="\d+")+<IO .+\/>
```

<!-- more -->

查找不包含 `MaxCount`属性的 `<IO/>` 节点 , 如 :

```xml
<IO Name="输入" Type="0" Count="1"/>
<IO Name="输出" Type="1" Count="1"/>
<IO Name="入出" Type="2" Count="2" MaxCount="0"/>
```

第一个节点会被匹配

### 2. 分组

但是 , 匹配到一整个字符串之后 , npp 怎么知道在什么位置插入哪些字符呢 ? 下面就需要对表达式进行分组 , 使用**括号**(group)将表达式分为两组

```
(^(?!.*MaxCount="\d+")+<IO .+)(\/>)
```

则匹配到的字符串也会被对应地分为两组 , 如

`(<IO Name="输入" Type="0" Count="1")` 和 `(/>)`


### 3. 替换

将 `替换目标` 中正则的分组使用 `\1` , `\2` 代替 , 如 :

```
\1 MaxCount="0"\2
```

其中
- `\1` 代表 `(^(?!.*MaxCount="\d+")\t+<IO .+)` 
- `\2` 代表 `(\/>)`

对应的 , 在匹配到的字符串中
 - `\1` 代表 `<IO Name="输入" Type="0" Count="1"` 
 - `\2` 代表 `/>`

这样 , 最终的结果就是在 `\1` 和 `\2` 之间插入字符串 ` MaxCount="0"` ( 字符 `M` 前面有空格 ) :

```xml
<IO Name="输入" Type="0" Count="1" MaxCount="0"/>
<IO Name="输出" Type="1" Count="1" MaxCount="0"/>
<IO Name="入出" Type="2" Count="2" MaxCount="0"/>
```

如果要批量将某部分删除 , 在 `替换为` 的表达式中不写某一组即可, 如只写 `\1` 就会把 `/>` 删除 , 留空就会删除整个匹配的字符串