---
title: 修复 Windows 10 的下载文件夹被迅雷变成 Downloads
date: 2017-07-11 12:52:39
tags: 
- windows
- software
permalink: win10-xunlei-folder-icon
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

4. 在管理员模式执行下面命令
    ```
    attrib +R C:\Users\{用户}\Downloads
    ```

5. 在任务管理器中重新启动资源管理器