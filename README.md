《游戏王》卡片查询器（跨平台版）
=============================

**本软件仅包含『中文』语言，而不是与《游戏王》本身一致，拥有各国的语言支持。**

- - -

跟随『中国OCG工作室』更新

- - -

编译方法：

### Android 原生

```
$ cd android
$ gradle build
```

### iOS 原生

```
$ cd ios
$ xcodebuild -workspace YuGiOhCard.xcworkspace/ -scheme YuGiOhCard -configuration Release
```

### 快应用版本

```
$ cd quickapp
$ npm run release
```

### Flutter 版本

```
$ cd flutter
$ flutter run
```

### 服务端(API及页面)

```
$ cd server
$ gradle run
```

### PC 版本

```
准备中...
```

- - -

### API

```
搜索卡片
/search?key=<keyword>&page=<page>

卡片明细
/carddetail?hash=<hashid>

卡片调整
/cardadjust?hash=<hashid>

卡片wiki
/cardwiki?hash=<hashid>

禁限卡表
/limit

卡包列表
/packlist

卡包内容明细
/packdetail?url=<packurl>

热门数据
/hotest
```

- - -

软件截图：

**for WatchOS**

![](https://raw.githubusercontent.com/rarnu/yugioh-card/master/screenshot/watchapp.gif)

**for iOS**

![](https://raw.githubusercontent.com/rarnu/yugioh-card/master/screenshot/iosapp.png)