---
title: flutter入门踩坑指南
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

```
Launching lib/main.dart on zhangchi in debug mode...
Signing iOS app for device deployment using developer identity: "iPhone Developer: zc_93@qq.com (6KUT83BFYR)"
Xcode build done.                                           97.7s
Could not install build/ios/iphoneos/Runner.app on 76a7163468ad9de7cc62150b518bfc551b99664d.
Try launching Xcode and selecting "Product > Run" to fix the problem:
  open ios/Runner.xcworkspace

Error launching application on zhangchi.
Exited (sigterm)
```

### Dart Devtools 可视化调试
![20190720115515.png](https://static.wzdxy.com/img/20190720115515.png)