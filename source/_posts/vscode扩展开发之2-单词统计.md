---
title: vscode扩展开发之2-单词统计
date: 2017-07-05 23:54:11
tags:
- vscode
permalink: vscode-ext-2
---

# 示例2 单词统计

当一个 `markdown` 文件被编辑时, 就会在状态栏添加一个消息, 它包含当前的单词数量, 并且会在编辑的时候更新

## 概览

这个插件由三部分构成:
- 更新状态栏: 在状态栏上显示自定义文字
- 注册事件: 在编辑事件触发时更新状态栏
- 处理扩展资源: 释放资源, 比如事件订阅或 UI 处理

## 更新状态栏

- 定义并实例化一个 `WordCounter` 类, 这个类可以计数单词数量并在状态栏上显示结果.
- `Hello World` 命令可以调用 `updateWordCount` 函数

```typescript
// The module 'vscode' contains the VS Code extensibility API
// Import the necessary extensibility types to use in your code below
import {window, commands, Disposable, ExtensionContext, StatusBarAlignment, StatusBarItem, TextDocument} from 'vscode';

// This method is called when your extension is activated. Activation is
// controlled by the activation events defined in package.json.
export function activate(context: ExtensionContext) {

    // Use the console to output diagnostic information (console.log) and errors (console.error).
    // This line of code will only be executed once when your extension is activated.
    console.log('Congratulations, your extension "WordCount" is now active!');

    // create a new word counter
    let wordCounter = new WordCounter();

    let disposable = commands.registerCommand('extension.sayHello', () => {
        wordCounter.updateWordCount();
    });

    // Add to a list of disposables which are disposed when this extension is deactivated.
    context.subscriptions.push(wordCounter);
    context.subscriptions.push(disposable);
}

class WordCounter {

    private _statusBarItem: StatusBarItem;

    public updateWordCount() {

        // Create as needed
        if (!this._statusBarItem) {
            this._statusBarItem = window.createStatusBarItem(StatusBarAlignment.Left);
        }

        // Get the current text editor
        let editor = window.activeTextEditor;
        if (!editor) {
            this._statusBarItem.hide();
            return;
        }

        let doc = editor.document;

        // Only update status if an Markdown file
        if (doc.languageId === "markdown") {
            let wordCount = this._getWordCount(doc);

            // Update the status bar
            this._statusBarItem.text = wordCount !== 1 ? `${wordCount} Words` : '1 Word';
            this._statusBarItem.show();
        } else { 
            this._statusBarItem.hide();
        }
    }

    public _getWordCount(doc: TextDocument): number {

        let docContent = doc.getText();

        // Parse out unwanted whitespace so the split is accurate
        docContent = docContent.replace(/(< ([^>]+)<)/g, '').replace(/\s+/g, ' ');
        docContent = docContent.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
        let wordCount = 0;
        if (docContent != "") {
            wordCount = docContent.split(" ").length;
        }

        return wordCount;
    }

    dispose() {
        this._statusBarItem.dispose();
    }
}
```

## 订阅事件

现在将上面的类关联到一系列事件上
- `onDidChangeTextEditorSelection` 光标位置变化时触发
- `onDidChangeActiveTextEditor` 活动的编辑器变化时触发

我们需要创建一个新的类, 这个类会订阅上述事件, 调用 `WordCounter` 来更新单词数量, 同时还要注意看, 这个类如何管理废弃的订阅, 以及如何停止监听, 当被自己处理的时候 (?)(Also note how this class manages the subscription as Disposables and how it stops listing when being disposed itself)

```ts
class WordCounterController {

    private _wordCounter: WordCounter;
    private _disposable: Disposable;

    constructor(wordCounter: WordCounter) {
        this._wordCounter = wordCounter;

        // subscribe to selection change and editor activation events
        let subscriptions: Disposable[] = [];
        window.onDidChangeTextEditorSelection(this._onEvent, this, subscriptions);
        window.onDidChangeActiveTextEditor(this._onEvent, this, subscriptions);

        // update the counter for the current file
        this._wordCounter.updateWordCount();

        // create a combined disposable from both event subscriptions
        this._disposable = Disposable.from(...subscriptions);
    }

    dispose() {
        this._disposable.dispose();
    }

    private _onEvent() {
        this._wordCounter.updateWordCount();
    }
}
```

现在, 我们不想通过命令来加载这个扩展, 而是在 `Markdown` 文件里都变得可用

- 首先需要替换掉 `active` 函数:

```ts
// create a new word counter
let wordCounter = new WordCounter();
let controller = new WordCounterController(wordCounter);

// Add to a list of disposables which are disposed when this extension is deactivated.
context.subscriptions.push(controller);
context.subscriptions.push(wordCounter);
```

- 然后, 需要保证在打开 `Markdown` 文件的时候激活扩展, 为了达到目的, 我们需要修改 `package.json` 文件. 之前的扩展通过 `extension.sayHello` 命令来激活, 现在不需要这个了, 所以 `contributes` 属性可以删掉了.

- 现在修改你的扩展, 添加 `activetionEvents` 属性, 使其在打开一个 `Markdown` 文件的时候激活

```json
"activationEvents": [
        "onLanguage:markdown"
    ]
```

`onLanguage:${language}` 事件获取一个语言 ID, 比如 `markdown`, 这个事件会在这种语言类型的文件打开时触发.

调试插件, 并打开一个 Markdown 文件, 就可以看到一个实时的单词统计了.

## 自定义的状态栏

现在我们已经知道了如何在状态栏上显示格式化的数据, VS Code 允许你使用图标, 颜色, 工具提示等更进一步地定制化你的状态栏. 使用智能感知, 你可以看到各种各样的状态栏区域. 另一个很好的了解VS Code 的 API 的途径是 `vscode.d.ts` 类型声明文件, 它就包含在你生成的项目中, 打开 `node_modules\vscode\vscode.d.ts` , 你可以看到完整的带有注释的 VS Code 扩展 API.

使用下面的代码来替换, 就可以显示一个铅笔的图标
```ts
this._statusBarItem.text = wordCount !== 1 ? `$(pencil) ${wordCount} Words` : '$(pencil) 1 Word';
this._statusBarItem.show();
```

## 销毁扩展资源

现在我们要通过销毁这一部分来更深入的了解扩展是如何处理 VS Code 的资源的.
当一个扩展被激活, 他是通过一个含有 `subscriptions` 销毁集合的 `ExtensionContext` 类来实现 (?). 扩展可以添加一个销毁对象到集合中, 当插件失效的时候 VS Code 会销毁这些对象.
很多创建工作区或 UI 对象的API 会返回一个 `Disposable` 对象, 扩展可以通过他们的销毁方法直接从 VS Code 移除这些元素. 
事件是另一个例子, 在 `onDid` 事件订阅方法返回一个 `Disposable` 对象的地方 . 扩展通过处理事件的 `Disposable` 对象来取消订阅一个事件. 在我们的示例中, `WordCountController` 直接处理事件订阅函数 , 通过... [ TBC ]