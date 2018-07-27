---
title: 配置 weex 的 android 开发环境
date: 2017-11-13 16:46:15
tags: 
- 前端
- weex
- Android
---

## 准备 weex 

- 推荐 `npm@>=5`

### 安装 weex

```bash
npm i -g weex-toolkit
```

<!-- more -->

(漫长的等待)
安装完成后, 使用 `weex` 命令验证安装, 如果成功, 可以看到帮助和配置信息

### 初始化项目

```bash
weex create WeexHello
```

- 第一次执行此命令会先自动安装 `weexpack` (漫长的等待)
- 等待安装完成后, 切换到生成的目录, `npm i` 安装依赖.

### 创建安卓项目

```bash
weex platform add android
```
很快就创建成功, 可以在根目录下看到 `platform` 文件夹 , 里面包含 `android` 目录.
`android\app\src\main\assets` 路径下的 `index.js` 就是安卓项目的入口文件.

## 准备 Android Studio

### 下载安装

[https://developer.android.google.cn/studio](https://developer.android.google.cn/studio/index.html)

### 下载SDK

首次启动时会开始SDK下载向导 , 可能需要科学上网 (或者漫长的等待)

### 打开项目

1. 使用 Android Studio 打开 `platform` 下的 `android` 文件夹
2. 首次打开会开始配置 Gradle, 可能需要科学上网 (或者漫长的等待) , 打开之后会报很多错, 依次按照提示安装相应的东西 . 提示 Gradle 升级的时候要升, 否则无法 Build (
如果没有升级, 后续可在 Files -> Project Structure -> Project 配置 Gradle 版本 )

### 生成 APK
Build -> Build APK(s), 生成的包在 `android\app\build\outputs\apk` 路径下


