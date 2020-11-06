---
title: uniapp微信小程序自动页面埋点和曝光埋点踩坑
date: 2020-10-26 11:17:58
tags:
permalink: uniapp-st
---

## 基本功能介绍
### 页面埋点

在页面的 onShow 勾子函数中上传埋点数据

### 曝光埋点

利用小程序提供的 `createIntersectionObserver`  API, 监听元素露出屏幕的事件，并触发回调（参数为元素的相关信息），由业务组件在回调中自己上传埋点数据。

```js
export class Exposure {
  constructor(selector, callback, vm, options) {
    this.callback = callback
    this.selector = selector
    this.lockTimer = null
    if (options) {
      this.bottom = options.bottom || 0
      this.top = options.top || 0
    }
    this.init(vm) // 为什么把vm传来传去而不用this.vm：因为会出现循环引用导致报错
  }

  /**
	 * 初始化
	 * @param vm 组件的 $vm 实例 (vue 实例)
	 */
  init(vm) {
    // 创建 IntersectionObserver 的实例
    this.ob = vm
      ? vm.createIntersectionObserver({ observeAll: true })
      : uni.createIntersectionObserver(null, { observeAll: true })
    // 开始监听，当露出时触发回调
    this.ob
      .relativeToViewport({
        bottom: this.bottom,
        top: this.top
      })
      .observe(this.selector, (result) => {
        if (result.intersectionRatio > 0) {
          this.callback(result)
        }
      })
  }
}

```

### 由于业务需求，页面埋点和曝光埋点还需要有以下逻辑
#### 1. 进入页面时（用户未操作），立即触发**页面埋点**和**曝光埋点**
#### 2. 跳到其他页面再返回时，需要再次触发**页面埋点**和**当前在屏幕露出的元素的埋点**

页面埋点很容易处理，而曝光埋点很麻烦，因为 `IntersectionObserver` 只能监听元素可见性变化，无法静态获取是否露出元素，因此需要在每个页面监听 `onHide` 和 `onShow` 事件，在 `onHide` 时销毁所有监听实例，在 `onShow` 时重新监听（因为 `IntersectionObserver` 创建时会默认触发一次事件，即可达到重新触发曝光的目的）
但如果这些逻辑放在业务代码中，非常繁琐且重复，因此使用全局 mixin 处理。

## 二、 全局 mixin

- 页面埋点

  每次 onShow 时都触发一次页面埋点

- 曝光埋点

  首次 onShow 时初始化曝光埋点（初始化不在此控制，因为加载时机不同，所以放在在业务逻辑中）并将曝光埋点实例存在 exposureObservers 中以备后用；同时标记 isPageFirstLoad 为 false

  每次 onHide 时销毁所有曝光埋点

  下次 onShow 时，遍历并调用 `exposureObservers` 中的所有实例的 `reInit` 方法


**Mixin代码**：

```js
/**
 *
 */
import { reportData } from '@/common/report-data'

/**
 * 曝光埋点
 */
export const pageAndExposureObservers = {
  data() {
    return {
      exposureObservers: [], // 用于存储曝光埋点
      isPageFirstLoad: true // 标记页面是否第一次加载
    }
  },
  onShow() {
    console.log(
      this.route,
      '=====================onShow 前========================'
    )
    console.log(
      this.route,
      '=====================onShow 后========================'
    )
    // 1. 首次和之后每次显示页面。发送页面埋点（从页面组件的 pageTrackConfig 中读取数据）
    if (typeof this.pageTrackConfig === 'undefined') {
      const pageTrackConfig = this.$options.pageTrackConfig
      let dataForReport
      if (typeof pageTrackConfig === 'function') {
        dataForReport = { type: 3, ...pageTrackConfig.call(this) }
      } else if (typeof pageTrackConfig === 'object' && pageTrackConfig.info) {
        dataForReport = { type: 3, ...pageTrackConfig }
      } else if (typeof pageTrackConfig === 'string') {
        dataForReport = { type: 3, info: pageTrackConfig }
      }
      dataForReport && reportData(dataForReport)
    }
    // 2.如果是从其他页面切换，重新初始化曝光埋点
    if (!this.isPageFirstLoad) {
      this.exposureObservers.forEach((item) => item.reInit(this))
    }
    this.isPageFirstLoad = false
  },
  onHide() {
    // 2.页面隐藏时，销毁所有曝光
    this.exposureObservers.forEach((item) => item.disconnect(this))
  }
}

```

**Exposure修改为：**

```js
export class Exposure {
  constructor(selector, callback, vm, options) {
    this.callback = callback
    this.selector = selector
    this.lockTimer = null
    if (options) {
      this.bottom = options.bottom || 0
      this.top = options.top || 0
    }
    this.init(vm) // 为什么把vm传来传去而不用this.vm：因为会出现循环引用导致报错
  }

  /**
	 * 初始化
	 * @param vm 组件的 $vm 实例 (vue 实例)
	 */
  init(vm) {
    // 创建 IntersectionObserver 的实例
    this.ob = vm
      ? vm.createIntersectionObserver({ observeAll: true })
      : uni.createIntersectionObserver(null, { observeAll: true })
    // 切断循环引用，防止报错
    this.ob._component = null
    // 开始监听，当露出时触发回调
    console.log({ bottom: this.bottom, top: this.top })
    this.ob
      .relativeToViewport({
        bottom: this.bottom,
        top: this.top
      })
      .observe(this.selector, (result) => {
        if (result.intersectionRatio > 0) {
          this.callback(result)
        }
      })
    // push 到当前页面组件的 exposureObservers 数组中
    this.getRootPageComponent(vm).exposureObservers.push(this)
  }

  /**
	 * 销毁所有监听
	 */
  disconnect(vm) {
    this.ob.disconnect()
    const rootPageComponent = this.getRootPageComponent(vm)
    const index = rootPageComponent.exposureObservers.indexOf(this)
    if (index) {
      rootPageComponent.exposureObservers.splice(index, 1)
    }
  }

  /**
	 * 重新监听所有曝光埋点
	 * @param vm
	 */
  reInit(vm) {
    this.disconnect(vm)
    this.init(vm)
  }

  /**
	 * 获取组件所属的最上层组件(页面组件)
	 * @param vm
	 * @returns {*}
	 */
  getRootPageComponent(vm) {
    if (vm.mpType === 'component') {
      return this.getRootPageComponent(vm.$parent)
    } else if (vm.mpType === 'page' || vm.$parent === undefined) {
      return vm
    } else {
      return vm
    }
  }
}
```

## 三、坑：iOS微信bug导致页面和曝光不准

### 1. 问题描述

iOS版本微信存在一个问题：从一个非TabBar页面A切换到TabBar页面B时，如果TabBar当前不处于目标页面B，会先短暂展示一下当前TabBar所在页面C，然后再切换到B。

结果就是页面C的 `onShow` 和 `onHide` 被执行，导致多发送一次页面和一批曝光事件。

除此之外，当二次复现此路径时，还会额外多触发一次B埋点，也就是发送2次B埋点。

相关链接
[https://developers.weixin.qq.com/community/develop/doc/000ea812d54ab0cfea3a23eaf51400]()

### 2. 解决方案

#### 过滤页面埋点
在调用 `switchTab` 前，记录全局变量 `isSwitchingTab`（表示当前正在切换TAB）
```js
Vue.prototype.isSwitchingTab = 'pages/shopping-cart'
```

在全局 mixin 的 onShow 方法中，判断这个变量，如果当前页面路由和 `isSwitchingTab` 的值相同，才认为当前是真正想跳转的页面，而不是由于 bug 短暂展示的页面。这样就过滤掉了本就不应该触发的C页面的 onShow。
同时，在进入B页面 onShow 后，延迟2s清除 isSwitchingTab ，防止影响下次跳转。

```js
if (
  Vue.prototype.isSwitchingTab === undefined ||
  this['__route__'] === Vue.prototype.isSwitchingTab
) {
  setTimeout(() => (Vue.prototype.isSwitchingTab = undefined), 2000)
  // 下面继续埋点逻辑
}
```

此处还有一个点需要注意：在使用 `getCurrentPages()` 获取的页面栈中，并不包含C页面，只能在 `this[__route__]` 中读取当前页面的 route 属性。这说明**对于微信小程序来说，C页面的意外展示是不被承认的**，毕竟它连一个痕迹都木有留下。

#### 过滤重复发送的B埋点

在发送埋点时，判断当前页面是否刚刚发送埋点，如果2s内有发送过，就不再发送

```js
// 防止重复曝光
if (
  dataForReport &&
  Vue.prototype.CurrentPageForMaidian !== dataForReport.info
) {
  dataForReport && reportData(dataForReport)
  Vue.prototype.CurrentPageForMaidian = dataForReport.info
  setTimeout(() => {
    Vue.prototype.CurrentPageForMaidian = undefined
  }, 2000)
}
```


## 四、最终代码

**Mixin代码**

```js
import { reportData } from '@/common/report-data'
import Vue from 'vue'

/**
 * 曝光埋点
 */
export const pageAndExposureObservers = {
  data() {
    return {
      exposureObservers: [], // 用于存储曝光埋点
      isPageFirstLoad: true // 标记页面是否第一次加载
    }
  },
  onShow() {
    console.log(
      '当前页面栈',
      getCurrentPages()
        .map((i) => i.route)
        .join(' ====> ')
    )
    const currentPages = getCurrentPages()
    const currentPage = currentPages[currentPages.length - 1]
    const currentRoute = currentPage ? currentPage.route : false
    console.log(currentRoute, '===========onShow==========')
    if (
      Vue.prototype.isSwitchingTab === undefined ||
			this['__route__'] === Vue.prototype.isSwitchingTab
    ) {
      // 为了处理 ios switch tab 的bug，记录当前正在切换的页面
      setTimeout(() => (Vue.prototype.isSwitchingTab = undefined), 2000)
      // 1. 首次和之后每次显示页面。发送页面埋点（从页面组件的 pageTrackConfig 中读取数据）
      if (typeof this.pageTrackConfig === 'undefined') {
        const pageTrackConfig = this.$options.pageTrackConfig
        let dataForReport
        if (typeof pageTrackConfig === 'function') {
          dataForReport = { type: 3, ...pageTrackConfig.call(this) }
        } else if (
          typeof pageTrackConfig === 'object' &&
					pageTrackConfig.info
        ) {
          dataForReport = { type: 3, ...pageTrackConfig }
        } else if (typeof pageTrackConfig === 'string') {
          dataForReport = { type: 3, info: pageTrackConfig }
        }

        // 防止重复曝光
        if (
          dataForReport &&
					Vue.prototype.CurrentPageForMaidian !== dataForReport.info
        ) {
          dataForReport && reportData(dataForReport)
          Vue.prototype.CurrentPageForMaidian = dataForReport.info
          setTimeout(() => {
            Vue.prototype.CurrentPageForMaidian = undefined
          }, 2000)
        }
      }
      // 2.如果是从其他页面切换，重新初始化曝光埋点
      if (!this.isPageFirstLoad) {
        this.exposureObservers.forEach((item) => item.reInit(this))
        console.log('reInit this.exposureObservers', this.exposureObservers)
      }
    }

    this.isPageFirstLoad = false
  },
  onHide() {
    // 2.页面隐藏时，销毁所有曝光
    this.exposureObservers.forEach((item) => item.disconnect(this))
  }
}
```

**Exposure**

```js
export class Exposure {
  constructor(selector, callback, vm, options) {
    this.callback = callback
    this.selector = selector
    this.lockTimer = null
    if (options) {
      this.bottom = options.bottom || 0
      this.top = options.top || 0
    }
    this.init(vm) // 为什么把vm传来传去而不用this.vm：因为会出现循环引用导致报错
    this.getRootPageComponent(vm).exposureObservers.push(this) // push 到当前页面组件的 pageAndExposureObservers 数组中
  }

  /**
	 * 初始化
	 * @param vm 组件的 $vm 实例 (vue 实例)
	 */
  init(vm) {
    // 创建 IntersectionObserver 的实例
    this.ob = vm
      ? vm.createIntersectionObserver({ observeAll: true })
      : uni.createIntersectionObserver(null, { observeAll: true })
    // 开始监听，当露出时触发回调
    // 开始监听，当露出时触发回调
    this.ob
      .relativeToViewport({
        bottom: this.bottom,
        top: this.top
      })
      .observe(this.selector, (result) => {
        if (result.intersectionRatio > 0) {
          this.callback(result)
        }
      })
    // 切断循环引用，防止报错（此语句必须放在.observe之后，否则会找不到组件内的元素）
    this.ob._component = null
  }

  /**
	 * 销毁所有监听
	 */
  disconnect() {
    this.ob.disconnect()
  }

  /**
	 * 重新监听所有曝光埋点
	 * @param vm
	 */
  reInit(vm) {
    this.init(vm)
  }

  /**
	 * 获取组件所属的最上层组件(页面组件)
	 * @param vm
	 * @returns {*}
	 */
  getRootPageComponent(vm) {
    if (vm.mpType === 'component') {
      return this.getRootPageComponent(vm.$parent)
    } else if (vm.mpType === 'page' || vm.$parent === undefined) {
      return vm
    } else {
      return vm
    }
  }
}

```

## 五、调用方法

### 页面埋点

在页面组件中定义 `pageTrackConfig` 属性即可，无需额外处理
支持 `String` 和 `Function`

```js
// string
export default {
  pageTrackConfig: 'hnav_home_page',
}
// function，返回复杂的埋点信息
export default {
  pageTrackConfig() {
    return { info: 'plist_product_detail_page', ext: { product_id: this.pid }}
  },
}
```

### 曝光埋点
```js
// 参数：选择器（支持多个），曝光回调，当前组件实例（即this）
// 可以在回调参数中读取 dom 的 dataset 等属性
this.$registerExposure(
  '.tofu .leaf-node',
  (result) => {
    // 在回调中发送埋点，可以通过 result 的 id和 dataset 获取信息，dataset就是DOM上的 data-xx=xx
    this.$reportData({
      info: 'hnav_homepage_tofu_exposure',
      ext: {
        serial_num: result.dataset.num
      }
    })
  },
  this
)

// 支持传递触发阈值，如被吸底的价格条遮挡的情况：
this.$registerExposure(
  '.section.rights',
  () => {
    this.$reportData({ info: 'plist_productdetail_policy_exposure' })
  },
  this,
  { bottom: -60 }
)
```