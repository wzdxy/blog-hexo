---
title: package-lock机制
date: 2018-11-10 09:25:57
tags:
permalink:
---

## 操作环境
- MacOS
- Node v8.11.1
- NPM 5.6.0

## 实验方法
1. 使用私有源
2. 在私有源发布一个包 `lock-test-wzdxy` , 并在一个项目中安装 1.0.0, 并生成 package-lock 文件
3. 更新这个包为 `1.0.1`, 执行 `npm i`
    预期: 包版本仍然为 `1.0.0`
4. 更新包为 `1.0.2`, 删除 `node-modules` 文件夹, 执行 `npm i`
    预期: 包版本仍为 `1.0.0`
5. 更新包为 `1.0.3`, 执行 `npm update lock-test`
    预期: 包版本更新为 `1.0.3`, 且 `package-lock` 中的依赖也更新为 `1.0.3`
6. 删除 `package-lock` 文件, 执行 `npm i`
    预期: 包版本更新为`1.0.3`
7. 切换源为 `npm`, 删除 `node_modules`, 保持 `package-lock` 存在, 执行 `npm i`
    预期: 包无法正常安装
8. 删除 `node_modules`, 删除 `package-lock`, 执行 `npm i`
    预期: 包无法正常安装
9. 在 `npm` 源发布包 `1.0.3`, 执行 `npm i`, 删除 `node_modules`, 删除 `package-lock` , 执行 `npm i`
    预期: 包正常安装

## 开始实验
1. nrm ls 到私有源
2. 发布包并安装
3. 更新包为 1.0.1 后执行 npm i
    结果: 符合预期
    ![]()
4. 更新包为 1.0.2, 删除 `node-modules` 文件夹, 执行 `npm i`
    结果: 符合预期
    ![]()
5. 更新包为 `1.0.3`, 执行 `npm update lock-test-wzdxy`
    结果: 符合预期
    ![]()
6. 删除 `package-lock` 文件, 执行 `npm i`
    结果: 符合预期
7. 切换源为 `npm`, 删除 `node_modules`, 保持 `package-lock` 存在, 执行 `npm i`
    结果: 和预期不符, 包可以正常安装
    ![]()
    原因: 直接下载了 package-lock.json 中指向的文件, 即私有源上的包URL: `http://172.16.16.242:4873/lock-test-wzdxy/-/lock-test-wzdxy-1.0.3.tgz`
8. 删除 `node_modules`, 删除 `package-lock`, 执行 `npm i`
    结果: 符合预期
    ![]()
9. 在 `npm` 源发布包 `1.0.3`, 执行 `npm i`, 删除 `node_modules`, 删除 `package-lock` , 执行 `npm i`