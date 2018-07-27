---
title: 修复 Windows 10 的下载文件夹被迅雷变成 Downloads
date: 2017-07-11 12:52:39
tags: 
- windows
- software
---

1. 不可直接重命名
2. 如果存在 `desktop.ini` 文件, 则修改为以下内容

<!-- more -->

```
[.ShellClassInfo]
LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798
IconResource=%SystemRoot%\system32\imageres.dll,-184
```

3. 如果不存在, 创建 `desktop.ini` 并设置为系统文件 (具有隐藏属性) :
    
```ps
attrib desktop.ini +s +h
```