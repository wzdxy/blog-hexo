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

### Dart Devtools 可视化调试
![20190720115515.png](https://static.wzdxy.com/img/20190720115515.png)