---
title: 如何优雅的在windows下开发之 ---- powershell配置
date: 2018-12-08 22:58:39
tags: [powershell, windows, vscode, notepad++]
permalink: windows-powershell-start
---

## 安装更纱字体
更纱字体一个很适合终端/编程并且对中文和日文都支持很好的字体系列, 还支持 PowerLine 字体.

下载ttf 文件并选择喜欢的安装即可, 我使用的是 `'Sarasa Term SC'`

安装后在 Powershell 标题右键属性即可配置

## 安装终端增强的软件 (需在管理员模式的 Powershell 窗口运行)
1. `DirColors` 让 ls (Get-ChildItem) 像 Unix 系终端一样具有多彩色 
    ```powershell
    Install-Module DirColors
    ```

2. `Post-Git` 和 `Git-Aliases` 可以实现类似 `oh-my-zsh` 一样的 Git 增强(命令别名和显示分支等信息)
<!-- more -->
    ```powershell
    Install-Module posh-git
    Install-Module -Name git-aliases -RequiredVersion 0.0.1 -AllowClobber
    ```
3. `pshazz` (可选) 
    - 一个软件可用代替前面两个, 实现 git 增强和别名
    - 优点是解决了前者在 vscode 中光标容易错位的 bug
    - 但UI不如前面好看
    - 安装 (使用 scoop 安装, 如果没有, 需先安装 scoop)
    ```powershell
    scoop install pshazz
    ```

4. 创建  Microsoft.PowerShell_profile.ps1
    ```powershell
    $PROFILE    // 查看配置文件的全路径
    code $PROFILE // 使用 vscode 打开(或创建)配置文件, notepad 也可以
    ```
    ```powershell
    # 写入以下内容 , 保存后新开一个 Powershell 即可看到效果
    Import-Module DirColors
    Import-Module posh-git
    Import-Module git-aliases -DisableNameChecking
    ```
    
## 在 vscode 中调用

1. 设置默认终端
    - `F1` 调出命令窗口, `Terminal: select default shell`, 选择 `Powershell`
2. 给终端设置字体
    - 在设置中找到 `Terminal › Integrated: Font Family`
    - 设置为 `'Sarasa Term SC'`

## 在终端中调用编辑器
1. **VS Code**: `code` 即可新开 一个 vscode , 参数可以是文件(编辑文件) 或 路径 (打开为工作区).
2. **NotePad++**: 将安装目录加入环境变量, `notepad++.exe` 即可, 想偷懒的话可以将 `notepad++.exe` 复制一个为 `npp.exe`, 就可以用 `npp` 调用了

## 使用VSCode调试 Powershell 脚本 
- **安装扩展** `PowerShell`
- **创建文件** Powershell 脚本使用 `ps1` 作为文件后缀
    ```powershell
    # 1.ps1
    "Hello PowerShell"
    "Now Is "+(Get-Date)
    ```
- **开始调试**
    按F5即可执行, 支持断点
- 如果无法重复调试, 在 VSCode 的设置中勾选 `Create Temporary Integrated Console`

## 在 Powershell 中使用 SS 代理
1. 在 ss 中允许局域网的连接/允许其他设备连入
2. 在终端执行
    ```powershell
    netsh winhttp import proxy source=ie
    # 如果成功会返回下面内容
    当前的 WinHTTP 代理服务器设置:
    代理服务器:  127.0.0.1:1080
    ...
    ```    

## 常用命令

### TBC...