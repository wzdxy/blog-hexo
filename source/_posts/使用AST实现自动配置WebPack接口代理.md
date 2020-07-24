---
title: 使用AST实现自动配置WebPack接口代理
date: 2020-07-24 23:27:28
tags:
  - 前端
  - AST
  - Javascript
permalink: ast-auto-proxy
---

## 背景

在开发物料平台的过程中, 为了提升物料开发的效率, 对 api 接口做了约定, 将物料用到的接口都配置到同一个 js 文件内.按照变量名划分.

```js
const mApi = {
  getList: (params) => axios.get("/api/get-list", params),
  setItem: (params) =>
    axios({
      method: "post",
      url: "/api/set-item",
    }),
};
const adminApi = {
  getList: (params) => axios.get("/admin-api/get-list", params),
};
export { mApi, adminApi };
```

为了减少操作, 打算根据这个文件自动配置代理.

<!-- more -->

一个搭建平台一般有后台(一般放在公司的管理系统域名下)和 M 站两部分, 所以这两部分接口需要分别指向不同的域名.

也就是获得下面的代码:

```js
export default {
  "/api/get-list": {
    target: mHost,
  },
  "/api/set-item": {
    target: mHost,
  },
  "/admin/get-list": {
    target: adminHost,
  },
};
```

首先想到的方法是正则提取, 但大家在代码里如何配置路由和参数不太可控, 可能出现提取错误, 而且不同 api 下的接口也不容易判断.

因此采用 AST 解析的方式, 也许更准确也更优雅.

## 依赖的工具

babel 是一个前端工程中很常用的工具, 其作用就是用将使用未来新语法的代码解析成 AST (Abstract Syntax Tree 抽象语法树), 然后转换成已经被浏览器兼容的语法, 再将其生成代码.

而 babel 是由多个工具组成的, 我们这次可以用以下工具实现这个功能.

- parser AST 解析器
- generator 代码生成器
- traverse 转换器
- types AST 节点类型

首先是代码解析成 AST 树, 很简单

```
const codeString = fs.readFileSync(apiFilePath, 'utf-8')
const ast = parser.parse(codeString, { ecmaVersion: 2020, sourceType: 'module' })
```

遍历 AST, 找到配置 ajax 请求 url 的地方, 将存储到对应的数组中

```js
let parentChain = []; // 在深度优先遍历中记录所有祖先node
let mApiList = []; // 存储 mApi 的 URL 地址
let adminApiList = []; // 存储 adminApi 的 URL 地址
let unkownApiList = [];
// 遍历提取
traverse(ast, {
  enter: function (path) {
    const { node, parent } = path;
    parentChain.push(node);
    // 适用于 ajax.get('xx') ajax.post('xx')
    if (node.type === "StringLiteral" && parent.type === "CallExpression") {
      getApiObjectName(parentChain).push(node.value);
    }
    // 适用于 ajax({url: 'xx'}) 写法
    if (node.type === "ObjectProperty" && node.key.name === "url") {
      getApiObjectName(parentChain).push(node.value.value);
    }
  },
  exit: function () {
    parentChain.pop();
  },
});
// 判断祖先是属于 mApi 还是 adminApi
function getApiObjectName(parentChain) {
  if (
    parentChain.some(
      (ancestorNode) =>
        ancestorNode.type === "VariableDeclarator" &&
        ancestorNode.id.name === "mApi"
    )
  ) {
    return mApiList;
  } else if (
    parentChain.some(
      (ancestorNode) =>
        ancestorNode.type === "VariableDeclarator" &&
        ancestorNode.id.name === "adminApi"
    )
  ) {
    return adminApiList;
  } else {
    return unkownApiList;
  }
}
```

`@babel/traverse` 的 enter 方法提供的回调参数里只能拿到 当前 node 和 parent node, 无法直接得知它属于哪个 api 对象.

这里为了做出判断, 维护一个 `parentChain` 栈, 记录深度优先遍历过程中的所有父级节点, 在判断时就可以根据这个栈找到它的祖先节点.

拿到 `mApiList` 和 `adminApiList` 数组后, 就可以生成配置了. 这里使用 `@babel/generator` 工具.

```js
// 根据配置列表依次生成代理列表的 ast node
const code = generator(
  t.program([
    // 导入全局配置(定义代理域名的js)
    t.variableDeclaration("const", [
      t.variableDeclarator(
        t.objectPattern([
          t.objectProperty(
            t.identifier("mHost"),
            t.identifier("mHost"),
            false,
            true
          ),
          t.objectProperty(
            t.identifier("adminHost"),
            t.identifier("adminHost"),
            false,
            true
          ),
        ]),
        t.callExpression(t.identifier("require"), [
          t.stringLiteral("./dev-host"),
        ])
      ),
    ]),
    // 导出生成的代理列表
    t.expressionStatement(
      t.assignmentExpression(
        "=",
        t.memberExpression(t.identifier("module"), t.identifier("exports")),
        t.objectExpression([
          t.objectProperty(
            t.identifier("proxy"),
            t.objectExpression(
              list.map((item) => createAstNodeOfProxyItem(...item))
            )
          ),
        ])
      )
    ),
  ]),
  {
    jsescOption: { quotes: "single" }, // generate options
  }
);

// 创建每一个代理配置的 ast node
function createAstNodeOfProxyItem(api, target, cookie) {
  return t.objectProperty(
    t.stringLiteral(api),
    t.objectExpression([
      t.objectProperty(t.identifier("target"), t.identifier(target)),
    ])
  );
}
```

这样生成源码后, 将其写入到 js 文件即可.

```js
fs.writeFileSync(
  path.resolve(config.localRepoPath, "proxy-list-auto.js"),
  proxyListResultCode,
  "utf-8"
);
```

这样就得到了一个 export 开头提到的代理配置列表 js 文件, 将其导入到 webpack 的 proxy 配置即可.
