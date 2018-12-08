---
title: 解决 git 在 windows 终端下乱码
date: 2018-12-08 18:30:33
tags: [git, powershell, windows]
permalink: windows-git-encode
---
## git log , git diff 乱码
类似
```
<E9><85><8D><E7><BD><AE><E6><96><87><E4><BB>
```
解决方法
```
setx LESSCHARSET 'utf-8'
```

## git status 乱码
类似
```
\226\260\345\273\272\346
```
解决方法
```
git config --global core.quotepath false
```


