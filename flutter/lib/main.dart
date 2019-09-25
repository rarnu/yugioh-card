import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:ktflutter/toast_extension.dart';
import 'package:yugiohcard/about.dart';
import 'package:yugiohcard/carddetail.dart';
import 'package:yugiohcard/cardlist.dart';
import 'package:yugiohcard/decklist.dart';
import 'package:yugiohcard/packdetail.dart';
import 'package:yugiohcard/searchadv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'global.dart';
import 'util/widgetutil.dart';

import 'limit.dart';
import 'pack.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: MainHomePage(),
    );
  }
}

class MainHomePage extends StatefulWidget {
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  var keywordController = TextEditingController();

  List<dynamic> hotwords = [];
  List<dynamic> hotcards = [];
  List<dynamic> hotpacks = [];

  _getHotestData() async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/hotest')).body);
      if (json['result'] == 0) {
        hotwords = [];
        hotwords.addAll(json['search']);
        hotcards = [];
        hotcards.addAll(json['card']);
        hotpacks = [];
        hotpacks.addAll(json['pack']);
        setState(() {});
      }
    } catch (e) {}
  }

  _findCardByImg(String imgid) async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/findbyimage?imgid=$imgid')).body);
      if (json['result'] == 0) {
        Navigator.push(context, CardDetailRoute(json['hash']));
      } else {
        toast(context, '没有找到匹配的卡片.');
      }
    } catch(e) {
      toast(context, '没有找到匹配的卡片.');
    }
  }

  _getRecData(File img) async {
    try {
      var data = FormData.fromMap({ "file": MultipartFile.fromFileSync(img.path) });
      var json = JsonCodec().decode((await Dio().post<String>('$BASEURL/matchimage', data: data)).data);
      if (json['result'] == 1) {
        toast(context, '没有找到匹配的卡片.');
      } else {
        var imgids = json['imgids'];
        if (imgids.length > 1) {
          // 多张图，选择后跳转
          _showMultiCards(imgids);
        } else {
          // 一张图，直接跳转
          _findCardByImg(imgids[0]);
        }
      }
    } catch(e) {
      toast(context, '上传图片失败.');
    }
  }

  _showMultiCards(List<dynamic> imgids) {
    var lines = 1;
    if (imgids.length > 5) lines++;
    showDialog(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(0xFF, 0x30, 0x30, 0x30),  
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '找到多张卡片',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.white, 
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        ),
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: sized(
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: imgids.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 5,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _findCardByImg(imgids[index]);
                            },
                            child: FadeInImage.assetNetwork(
                                placeholder: 'assets/img0.png',
                                image: 'http://ocg.resource.m2v.cn/${imgids[index]}.jpg'
                              ), 
                          );
                        },
                      ),
                      width: 320,
                      height: 90.0 * lines /* per line */
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: FlatButton(
                        onPressed: () {
                          // 关闭 Dialog
                          Navigator.pop(_);
                        },
                        child: Text('关闭')),
                  )
                ],
              ),
            )
          ],
        ),
      ),  
    );
  }

  _MainHomePageState() : super() {
    _getHotestData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YuGiOh Card'),
        actions: <Widget>[
          sized(
              FlatButton(
                child: Text('限制'),
                onPressed: () {
                  Navigator.push(context, LimitRoute());
                },
              ),
              width: 60),
          sized(
              FlatButton(
                child: Text('卡包'),
                onPressed: () {
                  Navigator.push(context, PackRoute());
                },
              ),
              width: 60),
          sized(
            FlatButton(
              child: Text('卡组'),
              onPressed: () {
                Navigator.push(context, DeckListRoute());
              },
            ), width: 60
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            sized(
                Row(
                  children: <Widget>[
                    expend(TextField(
                      readOnly: false,
                      controller: keywordController,
                      decoration: InputDecoration(
                          hintText: '输入要搜索的关键字', border: InputBorder.none),
                    )),
                    sized(
                        FlatButton(
                          child: Text('搜索'),
                          onPressed: () {
                            var keyword = keywordController.text;
                            if (keyword == '') {
                              toast(context, '搜索关键字不能为空.');
                              return;
                            }
                            Navigator.push(context, CardListRoute(keyword));
                          },
                        ),
                        width: 60),
                    sized(
                        FlatButton(
                          child: Text('高级'),
                          onPressed: () {
                            Navigator.push(context, SearchAdvRoute());
                          },
                        ),
                        width: 60),
                    sized(
                      FlatButton(
                        child: Text('识图'),
                        onPressed: () {
                          showModalBottomSheet(context: context, builder: (BuildContext context) {
                            return new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new ListTile(
                                  leading: new Icon(Icons.photo_camera),
                                  title: new Text("拍照"),
                                  onTap: () async {
                                    var img = await ImagePicker.pickImage(source: ImageSource.camera);
                                    Navigator.pop(context);
                                    _getRecData(img);
                                  },
                                ),
                                new ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text("从相册选取"),
                                  onTap: () async {
                                    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
                                    Navigator.pop(context);
                                    _getRecData(img);
                                  },
                                ),
                              ],
                            );
                          });
                        },
                      ),
                      width: 60),
                  ],
                ),
                height: 48),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '热门搜索',
                style: TextStyle(color: Color.fromARGB(255, 127, 127, 127)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hotwords.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2.2,
                  crossAxisCount: 5,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, CardListRoute(hotwords[index]));
                    },
                    child: sizedh(Text(hotwords[index]), height: 40),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    expend(Text(
                      '热门卡片',
                      style:
                          TextStyle(color: Color.fromARGB(255, 127, 127, 127)),
                    )),
                    GestureDetector(
                      onTap: () {
                        _getHotestData();
                      },
                      child: Text('<换一批>'),
                    )

                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hotcards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            CardDetailRoute(hotcards[index]['hashid']));
                      },
                      child: sizedh(Text('${hotcards[index]['name']}'),
                          height: 36));
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '热门卡包',
                style: TextStyle(color: Color.fromARGB(255, 127, 127, 127)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hotpacks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            PackDetailRoute(hotpacks[index]['packid']));
                      },
                      child: sizedh(
                          Text(
                            '${hotpacks[index]['name']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 0.8,
                          ),
                          height: 36));
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: sized(
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, AboutRoute());
                        },
                        child: Text('关于'),
                      ),
                    ],
                  ),
                  height: 36),
            ),
          ],
        ),
      ),
    );
  }
}
