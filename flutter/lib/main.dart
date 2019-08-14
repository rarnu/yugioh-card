import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:ktflutter/toast_extension.dart';
import 'package:yugiohcard/about.dart';
import 'package:yugiohcard/carddetail.dart';
import 'package:yugiohcard/cardlist.dart';
import 'package:yugiohcard/decklist.dart';
import 'package:yugiohcard/packdetail.dart';
import 'package:yugiohcard/searchadv.dart';
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

  getHotestData() async {
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

  _MainHomePageState() : super() {
    getHotestData();
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
                        width: 60)
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
                        getHotestData();
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
