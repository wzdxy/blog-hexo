---
title: flutter入门填坑记录
date: 2019-07-20 11:10:57
tags:
permalink:
---

### 配置国内Pub镜像
参考官网的指南 [在中国使用Flutter]https://flutter.dev/community/china
```bash
# Mac / Linux
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
git clone -b dev https://github.com/flutter/flutter.git
export PATH="$PWD/flutter/bin:$PATH"
cd ./flutter
flutter doctor
# Windows
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### Dart Devtools 可视化调试
<!-- more -->
![20190720115515.png](https://static.wzdxy.com/img/20190720115515.png)


### 安卓release打包后不能访问网络
需要在 `android/app/src/main/AndroidManifest.xml` 中配置网络权限
```xml
<!-- others -->
  </application>
  <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
<!-- others -->
```

### `No implementation found for method create on channel flutter.io/videoPlayer`
此报错出现于添加新插件(视频播放组件)之后.
原因是对于带有特定平台代码的包, 热更新无法处理, 需要重启应用.
[Adding a package dependency to an app](https://flutter.dev/docs/development/packages-and-plugins/using-packages#adding-a-package-dependency-to-an-app)
