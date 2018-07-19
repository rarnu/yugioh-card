《游戏王》卡片查询器（跨平台版）
=============================

**本软件仅包含『中文』语言，而不是与《游戏王》本身一致，拥有各国的语言支持。**

- - -

软件发布页：[游戏王卡片查询器](http://scarlett.vip/yugioh)

跟随『中国OCG工作室』更新

- - -

编译方法：

### Android

```
$ cd native
$ fpccmd AA yugiohapi.ppr
$ fpccmd AI yugiohapi.ppr
$ cd android
$ gradle build
```

### iOS

```
$ cd native
$ fpccmd I yugiohapi.ppr
$ cd ios/YuGiOhCard
$ xcodebuild -workspace YuGiOhCard.xcworkspace/ -scheme YuGiOhCard -configuration Release
```

### Windows (NOT completed)

```
$ cd native
$ fpccmd W yugiohapi.ppr
$ cd pc/yugiohcard
$ fpccmd W yugiohcard.ppr O
```

### Mac OSX

```
$ cd native
$ fpccmd M yugiohapi.ppr
$ cd pc/yugiohcard
$ fpccmd M yugiohcard.ppr O
```

### Linux

```
$ cd native
$ fpccmd L yugiohapi.ppr
$ cd pc/yugiohcard
$ fpccmd L yugiohcard.ppr O
```

- - -

软件截图：

