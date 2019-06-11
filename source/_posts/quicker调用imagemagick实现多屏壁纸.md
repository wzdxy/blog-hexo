---
title: quicker调用imagemagick实现多屏壁纸
date: 2019-06-12 00:40:02
tags:
permalink: imagemagick-cross-wallpaper
---

## 实现步骤
- 如果未下载过 `imagemagick` 则先下载可执行文件
- 获取多屏幕的宽高
```powershell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Screen]::AllScreens

BitsPerPixel : 32
Bounds       : {X=2560,Y=255,Width=1920,Height=1080}
DeviceName   : \\.\DISPLAY1
Primary      : False
WorkingArea  : {X=2560,Y=255,Width=1920,Height=1040}

BitsPerPixel : 32
Bounds       : {X=0,Y=0,Width=2560,Height=1440}
DeviceName   : \\.\DISPLAY2
Primary      : True
WorkingArea  : {X=0,Y=0,Width=2560,Height=1400}
```

- 调用 Powershell 执行 magick 命令, 将选中的2张图片合并为一张大图
```powershell
 magick.exe convert -size 757x388 -strip xc:none .\1.jpg -geometry +0+0  -composite .\2.jpg -geometry +369+0 -composite  c2.jpg
 # 总宽度 x 总高度     第一张图的起始位置 0 x 0     第二张图的起始位置  +x+y
```

- 调用 .Net 设置桌面背景
```powershell
function Set-Wallpaper
{
    param(
        [Parameter(Mandatory=$true)]
        $Path,

        [ValidateSet('Center', 'Stretch', 'Cross')]
        $Style = 'Stretch'
    )

    Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
public enum Style : int
{
Center, Stretch, Cross
}
public class Setter {
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path, Wallpaper.Style style ) {

RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
// Console.WriteLine(style);
switch( style )
{
case Style.Stretch :
key.SetValue(@"WallpaperStyle", "2") ;
key.SetValue(@"TileWallpaper", "0") ;
break;
case Style.Center :
key.SetValue(@"WallpaperStyle", "0") ;
key.SetValue(@"TileWallpaper", "0") ;
break;
case Style.Cross :
key.SetValue(@"WallpaperStyle", "22") ;
key.SetValue(@"TileWallpaper", "0") ;
break;
}
key.Close();
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
}
}
}
"@

    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )
}

Set-Wallpaper -Path 'C:\Users\zchi\Pictures\gg1.png'
```