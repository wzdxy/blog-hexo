---
title: ES6 的 Iterator 迭代器和 Generator 生成器
date: 2018-03-07 03:40:49
tags: 
- Javascript
- 前端
permalink: es6-iterator-generator
---

## Iterator 概念

迭代器是 es6 中新增的一种的处理集合中每一个项目的方法 . 它允许使用 for ... of 来遍历对象 . 它提供一个 `next()` 方法 , 用来获取集合中的下一项, 其返回值的形式为 : 

```js
{
    value : something   // 下一项
    done : boolean      // 表示是否迭代完成
}
```

<!-- more -->

## Iterator 用法

- 创建一个迭代器并使用 :
```js
function makeIterator(array){
    var nextIndex = 0;

    return {
       next: function(){
           return nextIndex < array.length ?
               {value: array[nextIndex++], done: false} :
               {done: true};
       }
    };
}

var it = makeIterator(['yo', 'ya']);
console.log(it.next().value); // 'yo'
console.log(it.next().value); // 'ya'
console.log(it.next().done);  // true
```
- Symbol.iterator 属性

默认 Iterator 接口部署在 Symbol.iterator 属性上 , 可以用这个属性来创建可迭代的对象

## 默认可迭代的类型

- Array
- Map
- Set
- String
- [TypedArray](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)
- 函数内的 arguments 属性
- NodeList

以数组为例 :

```js
let arr = ['a', 'b', 'c'];
let iter = arr[Symbol.iterator]();

iter.next() // { value: 'a', done: false }
iter.next() // { value: 'b', done: false }
```

## for...of 循环

具有迭代器属性的对象 (原型链上也可) 可以使用 for...of 来遍历其内容

## Genaretor 概念

自定义的迭代器是一个有用的工具，但由于需要显式地维护其内部状态 , 因此需要谨慎地创建. 而 Generators 可以定义一个包含自有迭代算法的函数 , 并能自动维护自己的状态.

```js
function* idMaker() {
  var index = 0;
  while(true)
    yield index++;
}

var gen = idMaker();

console.log(gen.next().value); // 0
console.log(gen.next().value); // 1
```

在上面的函数中 , 每次调用 next() 函数 , 就会执行一遍 idMaker 函数 , 并在 yield 处停止, 返回 yield 的后面值

## 使用生成器创建 Iterator 接口

```js
var myIterable = {};
myIterable[Symbol.iterator] = function* () {
  yield 1;
  yield 2;
  yield 3;
};

[...myIterable] // [1, 2, 3]
```

上面的代码相当于