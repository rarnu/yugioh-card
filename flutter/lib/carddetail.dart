import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:ktflutter/string_extension.dart';
import 'package:yugiohcard/util/cardutil.dart';
import 'package:yugiohcard/util/widgetutil.dart';
import 'global.dart';
import 'cardwiki.dart';

class CardDetailRoute extends MaterialPageRoute {
  CardDetailRoute(String hash) : super(builder: (context) => CardDetailPage(hash));
}

class CardDetailPage extends StatefulWidget {
  String hash;
  CardDetailPage(this.hash): super();
  _CardDetailState createState() => _CardDetailState(hash);
}

class _CardDetailState extends State<CardDetailPage> {

  String hash;
  dynamic data = {};
  String adjust = '';
  _CardDetailState(this.hash) : super() {
    getCardDetail();
  }

  getCardDetail() async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/carddetail?hash=$hash')).body);
      adjust = (await httpGet('$BASEURL/cardadjust?hash=$hash')).body;
      if (json['result'] == 0) {
        data = json['data'];
        setState(() {});
      }
    } catch(e) {

    }
  }

  bool isMonster() {
    try {
      return '${data['cardtype']}'.contains('怪兽');
    } catch(e) {
      return false;
    }
  }
  bool isLinkMonster() {
    try {
      return '${data['cardtype']}'.contains('连接');
    } catch(e) {
      return false;
    }
  }
  bool isXYZMonster() {
    try {
      return '${data['cardtype']}'.contains('XYZ');
    } catch(e) {
      return false;
    }
  }
  String replaceLinkArrow() {
    var str = stringOf('${data['linkarrow']}');
    str = str.replaceAll('1', '↙');
    str = str.replaceAll('2', '↓');
    str = str.replaceAll('3', '↘');
    str = str.replaceAll('4', '←');
    str = str.replaceAll('6', '→');
    str = str.replaceAll('7', '↖');
    str = str.replaceAll('8', '↑');
    str = str.replaceAll('9', '↗');
    return '$str';
  }

  List<Widget> buildMonsterUI() {
    var widgets = <Widget>[];
    if (isMonster()) {
      widgets.add(sized(Row(
        children: <Widget>[
          expend(Text('怪兽种族:'),),
          expend(Text(parseName(data['race'])), flex: 4)
        ],
      ), height: 30),);
      widgets.add(sized(Row(
        children: <Widget>[
          expend(Text('怪兽属性:'),),
          expend(Text(parseName(data['element'])), flex: 4)
        ],
      ), height: 30),);
      if (isLinkMonster()) {
        widgets.add(sized(Row(
          children: <Widget>[
            expend(Text('攻击力:'),),
            expend(Text(parseName(data['atk'])), flex: 4)
          ],
        ), height: 30),);
        widgets.add(sized(Row(
          children: <Widget>[
            expend(Text('连接数:'),),
            expend(Text(parseName(data['link'])), flex: 4)
          ],
        ), height: 30),);
        widgets.add(sized(Row(
          children: <Widget>[
            expend(Text('连接方向:'),),
            expend(Text(replaceLinkArrow()), flex: 4)
          ],
        ), height: 30),);

      } else {
        if (isXYZMonster()) {
          widgets.add(sized(Row(
            children: <Widget>[
              expend(Text('怪兽阶级:'),),
              expend(Text(parseName(data['level'])), flex: 4)
            ],
          ), height: 30),);
        } else {
          widgets.add(sized(Row(
            children: <Widget>[
              expend(Text('怪兽星级:'),),
              expend(Text(parseName(data['level'])), flex: 4)
            ],
          ), height: 30),);
        }
        widgets.add(sized(Row(
          children: <Widget>[
            expend(Text('攻击力:'),),
            expend(Text(parseName(data['atk'])), flex: 4)
          ],
        ), height: 30),);
        widgets.add(sized(Row(
          children: <Widget>[
            expend(Text('守备力:'),),
            expend(Text(parseName(data['def'])), flex: 4)
          ],
        ), height: 30),);
      }
    }
    return widgets;
  }

  String parseEffect(e) => e == null ? '-' : stringOf('$e').replaceAll('<br />', '\n').let((it) => '$it');

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Card Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            sized(FlatButton(child: Text('WIKI'), onPressed: () {
              Navigator.push(context, CardWikiRoute(hash));
            },), width: 65),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            sized(Row(
              children: <Widget>[
                expend(Text('中文名称:'),),
                expend(Text(parseName(data['name'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('日文名称:'),),
                expend(Text(parseName(data['japname'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('英文名称:'),),
                expend(Text(parseName(data['enname'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('卡片类型:'),),
                expend(Text(parseName(data['cardtype'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('卡片密码:'),),
                expend(Text(parseName(data['password'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('使用限制:'),),
                expend(Text(parseName(data['limit'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('罕贵度:'),),
                expend(Text(parseName(data['rare'])), flex: 4)
              ],
            ), height: 30),
            sized(Row(
              children: <Widget>[
                expend(Text('所在卡包:'),),
                expend(Text(parseName(data['pack'])), flex: 4)
              ],
            ), height: 30),
            ...buildMonsterUI(),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  expend(Text('效果:')),
                  expend(Text(parseEffect(data['effect'])), flex: 4)
                ],
              ),
            ),
            Divider(),
            sizedw(Column(children: <Widget>[
              Image.network('http://ocg.resource.m2v.cn/${parseImage(data['imageid'])}.jpg'),
            ],)),
            Divider(),
            sizedw(Column(children: <Widget>[
              Text(adjust),
            ],))
          ],
        ),
    );
  }
}