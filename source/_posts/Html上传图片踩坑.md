---
title: Html上传图片踩坑(压缩, 旋转, 无法读取图片等问题)
date: 2018-10-27 10:53:25
tags:
- JavaScript
- 前端
permalink: img-upload
---

## 基本流程
- 使用 input 调起文件选择器/系统相机
- 监听 change 事件, 并用 `Filereader` 读取 base64
- 将 base64 直接发送给后端
- 后端进行写入文件/发送给CDN等操作

<!-- more -->

## 踩坑记录
### 图片压缩
现在手机相机的像素较高, 前置摄像头也可能达到1M, 为了加快传输和节省带宽资源, 使用 canvas 进行压缩
- 根据限定的最大尺寸, 等比创建一个 canvas , 将图片直接绘制到 canvas 上, 再导出为 base64

### 照片方向错误
有些手机(比如 iPhone)的前置摄像头拍出来的照片读取出来是水平翻转或者旋转90度的, 需要纠正方向后上传
- 使用 exif.js 读取照片元数据, 根据照片的被旋转方向反向绘制到 canvas

### 安卓 webview 中无法唤起相机直接拍照
这是一个比较隐蔽的坑, 当时测试时在有些机型复现, 有些没有复现, 所以起初怀疑是 webview 的限制或兼容性问题.
原因就是在安卓系统中APP要调用相机需要和系统申请权限, APP 内置的 webview 也同样需要, 如果用户安装 APP 后从未获取过相机权限, 直接调用这个功能就会出错. 有些机器没有复现就是因为在那个台机器的 APP 上使用过拍照功能, 已经有权限了.
这个问题需要 native 对此提供支持.
一种方法是检测 webview 中调起相机的行为或提供 bridge 接口, 提前向系统申请权限.
二是在 APP 首次启动时就申请拍照权限 (不够友好).

### 美图手机自带相机不可用
无论是在 webview 还是在普通浏览器, 美图系统自带的相机拍照之后, 都不能触发 input 的 change 事件, 更无法获取到照片.
但下载一个第三方相机比如 Camare360, 却可以正常读取.
没找到解决方案, 怀疑是 ROM 问题.

## 前端代码

### 文件读取
```js
let file = input.files[0]
let reader = new window.FileReader()
reader.onload = function () {  
  upload(this.result)
}
reader.readAsDataURL(file)
```

### upload 方法
```js
// 创建图片对象写入 base 64
const imgObj = new window.Image()
imgObj.src = base64
// 如果图片的尺寸没有超过预设的最大值, 可以直接上传
if (imgObj.height <= this.options.maxSize && imgObj.width <= this.options.maxSize) {
  post(base64)
  return
}
// 如果尺寸较大需要压缩, 则等比缩放, 计算出新的宽高
let width, height
if (imgObj.width > imgObj.height) {
  width = imgObj.width > this.options.maxSize ? this.options.maxSize : imgObj.width
  height = width * (imgObj.height / imgObj.width)
} else {
  height = imgObj.height > this.options.maxSize ? this.options.maxSize : imgObj.height
  width = height * (imgObj.width / imgObj.height)
}

// 创建一个画布, 尺寸等同上面计算出的新宽高
const canvas = document.createElement('canvas')
const context = canvas.getContext('2d')
canvas.width = width
canvas.height = height
// 读取 exif 数据, 用于判断方向
let exifData
exif.getData(this, function () {
  let _dataTxt = exif.pretty(this)
  exifData = exif.getAllTags(this)
  console.log(_dataTxt)
})
// 根据方向来调整绘制方向
// 在 canvas 中, 旋转绘制一张图片实际是先对画布进行旋转, 再根据需要绘制图片, 然后将画布旋转回来
if (exifData && exifData.Orientation === 3) {
  // 被旋转了 180度
  context.rotate(180 * Math.PI / 180)
  context.drawImage(imgObj, -canvas.width, -canvas.height, canvas.width, canvas.height)
} else if (exifData && exifData.Orientation === 6) {
  // 被旋转了 90 度
  canvas.width = height
  canvas.height = width
  context.rotate(90 * Math.PI / 180)
  context.drawImage(imgObj, 0, -canvas.width, canvas.height, canvas.width)
} else {
  // 正常图片
  context.drawImage(imgObj, 0, 0, canvas.width, canvas.height)
}
// 在上传之前可以进行本地预览操作
if ($('#prew-canvas').length) {
  $('#prew-canvas').empty().append(canvas)
}
// 从 canvas 导出 base64 数据, 调用发送方法
let postData = canvas.toDataURL('image/jpeg', 0.92)
post(postData)
```

## 后端代码
以Node.js为例 (未做类型判断, 尺寸限制等处理, 仅供调试使用)
```js
app.use('/upload', function (req, res) {
  let data = req.body.img
  var dataTypes = new RegExp('data:(.*)/(.*);base64').exec(data)  // 读取文件和图片格式  
  var dataType = dataTypes[1] // 数据类型, 如果是图片, 此值均为 image  
  var extName = dataTypes[2]  // 文件扩展名, jpg/png/gif 等
  var fileName = new Date().getTime() + '.' + extName  
  var base64Data = data.replace(/^data:image\/\w+;base64,/, '')   // 图片数据  
  var dataBuffer = Buffer.alloc(base64Data.length, base64Data, 'base64') // 创建数据流
  fs.writeFile(`static/up/${fileName}`, dataBuffer, function (err) {
    if (err) {
      res.send(err)
    } else {
      res.send({  // 如果写入成功, 返回文件访问路径
        code: 0,
        path: `/static/up/${fileName}`
      })
    }
  })
})
```