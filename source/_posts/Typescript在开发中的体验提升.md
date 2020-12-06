---
title: Typescript在开发中的体验提升
date: 2020-11-06 11:06:01
tags:
permalink: typescript-efficient
---

## 1. 标记参数和返回值，方便维护

```js
// login
function checkUserLogin() {
  const configData = this.getUserConfig()
  if (configData.username) {

  }
}

// user-config.js
function getUserConfig() {
  // do something and return userConfig
}
```

```ts
interface UserConfig {
  username: String
  uid: Number
}

function checkUserLogin() {
  const userConfig:UserConfig = this.getUserConfig()
  console.log(configData.name)
}

// user-config.js
function getUserConfig:UserConfig() {
  // do something and return userConfig
}
```

# 2. 代码补全

## 声明文件 d.ts
其实我们一直在用 ts

### VSCode 对 d.ts 的支持
`Automatic Type Acquisition` 功能，会将自动下载社区中流行的 @types

### Webstorm 对 d.ts 的支持
自动

对于自己的库，可以编写自己的 d.ts，发布到 `@types/` 下

```ts
// @types/xxx/index.d.ts
declare namespace $ACS {
  /**
    * 工具方法
    */
  export const utils: {
    /**
      * 是否处于微信小程序
      */
    isMini(): Boolean
    /**
      * 当前是否处于APP内
      */
    isApp(): Boolean
    /**
     * 获取当前所在的联调、测试、本地、线上、预发布等环境及域名信息
     */
    getEnv(): {
      env: 'local-dev'|'online'|'pre'|'test'
      mHost: String
    }
  }
}
```

![](https://static.wzdxy.com/img/20201206002435.png)

![](https://static.wzdxy.com/img/20201206212158.png)

