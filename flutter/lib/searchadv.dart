import 'package:flutter/material.dart';
import 'package:yugiohcard/cardlist.dart';
import 'package:yugiohcard/util/widgetutil.dart';
import 'global.dart';

class SearchAdvRoute extends MaterialPageRoute {
  SearchAdvRoute() : super(builder: (context) => SearchAdvPage());
}

class SearchAdvPage extends StatefulWidget {
  _SearchAdvState createState() => _SearchAdvState();
}

class _SearchAdvState extends State<SearchAdvPage> {
  Color dark = Color.fromARGB(255, 127, 127, 127);
  Color light = Color.fromARGB(255, 126, 255, 255);

  TextEditingController effectController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController scaleController = TextEditingController();
  TextEditingController atkController = TextEditingController();
  TextEditingController defController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  int cardType = 0;

  List<int> selectMagicType = [];
  List<int> selectTrapType = [];
  List<int> selectMonsterAttr = [];
  List<int> selectMonsterType = [];
  List<int> selectMonsterRace = [];
  List<int> selectLinkArrow = [];

  List<Widget> buildUI() {
    List<Widget> w = [];
    if (cardType == 1) {
      // magic
      w.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('魔法种类'),
      ));
      w.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: GridView.builder(
                itemCount: magicType.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!selectMagicType.contains(index)) {
                        selectMagicType.add(index);
                      } else {
                        selectMagicType.remove(index);
                      }
                      setState(() {});
                    },
                    child: Text(
                      magicType[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              selectMagicType.contains(index) ? light : dark),
                    ),
                  );
                }),
          )));
    } else if (cardType == 2) {
      // trap
      w.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('陷阱种类'),
      ));
      w.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: GridView.builder(
                itemCount: trapType.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!selectTrapType.contains(index)) {
                        selectTrapType.add(index);
                      } else {
                        selectTrapType.remove(index);
                      }
                      setState(() {});
                    },
                    child: Text(
                      trapType[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: selectTrapType.contains(index) ? light : dark),
                    ),
                  );
                }),
          )));
    } else {
      // monster
      w.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('怪兽属性'),
      ));
      w.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: GridView.builder(
                itemCount: monsterAttr.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!selectMonsterAttr.contains(index)) {
                        selectMonsterAttr.add(index);
                      } else {
                        selectMonsterAttr.remove(index);
                      }
                      setState(() {});
                    },
                    child: Text(
                      monsterAttr[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              selectMonsterAttr.contains(index) ? light : dark),
                    ),
                  );
                }),
          )));

      w.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('怪兽种类'),
      ));
      w.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: GridView.builder(
                itemCount: monsterType.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!selectMonsterType.contains(index)) {
                        selectMonsterType.add(index);
                      } else {
                        selectMonsterType.remove(index);
                      }
                      setState(() {});
                    },
                    child: Text(
                      monsterType[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              selectMonsterType.contains(index) ? light : dark),
                    ),
                  );
                }),
          )));

      w.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('怪兽种族'),
      ));

      w.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: GridView.builder(
                itemCount: monsterRace.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!selectMonsterRace.contains(index)) {
                        selectMonsterRace.add(index);
                      } else {
                        selectMonsterRace.remove(index);
                      }
                      setState(() {});
                    },
                    child: Text(
                      monsterRace[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              selectMonsterRace.contains(index) ? light : dark),
                    ),
                  );
                }),
          )));
      w.add(
        sizedh(
            Row(
              children: <Widget>[
                sizedw(Text('星数阶级'), width: 80),
                expend(Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    readOnly: false,
                    controller: levelController,
                    decoration: InputDecoration(
                        hintText: '可以是范围，如 1-4', border: InputBorder.none),
                  ),
                )),
              ],
            ),
            height: 40),
      );
      w.add(Divider());
      w.add(
        sizedh(
            Row(
              children: <Widget>[
                sizedw(Text('灵摆刻度'), width: 80),
                expend(Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    readOnly: false,
                    controller: scaleController,
                    decoration: InputDecoration(
                        hintText: '可以是范围，如 1-4', border: InputBorder.none),
                  ),
                )),
              ],
            ),
            height: 40),
      );
      w.add(Divider());
      w.add(
        sizedh(
            Row(
              children: <Widget>[
                sizedw(Text('攻击力'), width: 80),
                expend(Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    readOnly: false,
                    controller: atkController,
                    decoration: InputDecoration(
                        hintText: '可以是范围，如 1500-2000',
                        border: InputBorder.none),
                  ),
                )),
              ],
            ),
            height: 40),
      );
      w.add(Divider());
      w.add(
        sizedh(
            Row(
              children: <Widget>[
                sizedw(Text('守备力'), width: 80),
                expend(Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    readOnly: false,
                    controller: defController,
                    decoration: InputDecoration(
                        hintText: '可以是范围，如 1500-2000',
                        border: InputBorder.none),
                  ),
                )),
              ],
            ),
            height: 40),
      );
      w.add(Divider());
      w.add(
        sizedh(
            Row(
              children: <Widget>[
                sizedw(Text('连接值'), width: 80),
                expend(Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    readOnly: false,
                    controller: linkController,
                    decoration: InputDecoration(
                        hintText: '可以是范围，如 1-3', border: InputBorder.none),
                  ),
                )),
              ],
            ),
            height: 40),
      );
      w.add(Divider());
      w.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('连接方向'),
      ));
      w.add(Column(
        children: <Widget>[
          sized(
              GridView.builder(
                itemCount: linkArrow.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!selectLinkArrow.contains(index)) {
                        selectLinkArrow.add(index);
                      } else {
                        selectLinkArrow.remove(index);
                      }
                      setState(() {});
                    },
                    child: Text(linkArrow[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                          selectLinkArrow.contains(index) ? light : dark),
                    ),
                  );
                },
              ),
              width: 120,
              height: 120),
        ],
      ));
    }
    return w;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            sized(
                FlatButton(
                  child: Text('搜索'),
                  onPressed: () {
                    var key = buildSearchKey();
                    if (key != '') {
                      Navigator.push(context, CardListRoute(key));
                    }
                  },
                ),
                width: 60),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              sizedh(
                  Row(
                    children: <Widget>[
                      sizedw(Text('卡片种类'), width: 80),
                      expend(Container(
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  '怪兽',
                                  style: TextStyle(
                                      color: cardType == 0 ? light : dark),
                                ),
                              ),
                              onTap: () {
                                cardType = 0;
                                setState(() {});
                              },
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  '魔法',
                                  style: TextStyle(
                                      color: cardType == 1 ? light : dark),
                                ),
                              ),
                              onTap: () {
                                cardType = 1;
                                setState(() {});
                              },
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  '陷阱',
                                  style: TextStyle(
                                      color: cardType == 2 ? light : dark),
                                ),
                              ),
                              onTap: () {
                                cardType = 2;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                  height: 40),
              sizedh(
                  Row(
                    children: <Widget>[
                      sizedw(Text('卡片效果'), width: 80),
                      expend(Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextField(
                          readOnly: false,
                          controller: effectController,
                          decoration: InputDecoration(
                              hintText: '输入要搜索的关键字', border: InputBorder.none),
                        ),
                      )),
                    ],
                  ),
                  height: 40),
              Divider(),
              ...buildUI(),
            ],
          ),
        ));
  }

  String parseCardType() {
    switch(cardType) {
      case 1: return '魔法';
      case 2: return '陷阱';
      default: return '怪兽';
    }
  }

  String buildMagicCardType() {
    var k = '';
    for (var idx in selectMagicType) {
      k += '${magicType[idx]},';
    }
    if (k.endsWith(',')) {
      k = k.substring(0, k.length - 1);
    }
    return k;
  }

  String buildTrapCardType() {
    var k = '';
    for (var idx in selectTrapType) {
      k += '${trapType[idx]},';
    }
    if (k.endsWith(',')) {
      k = k.substring(0, k.length - 1);
    }
    return k;
  }

  String buildMonsterCardType() {
    var k = '';
    for (var idx in selectMonsterType) {
      k += '${monsterType[idx]},';
    }
    if (k.endsWith(',')) {
      k = k.substring(0, k.length - 1);
    }
    return k;
  }

  String buildMonsterRace() {
    var k = '';
    for (var idx in selectMonsterRace) {
      k += '${monsterRace[idx]},';
    }
    if (k.endsWith(',')) {
      k = k.substring(0, k.length - 1);
    }
    return k;
  }

  String buildMonsterElement() {
    var k = '';
    for (var idx in selectMonsterAttr) {
      k += '${monsterAttr[idx]},';
    }
    if (k.endsWith(',')) {
      k = k.substring(0, k.length - 1);
    }
    return k;
  }

  String buildMonsterLinkArrow() {
    var k = '';
    if (selectLinkArrow.contains(0)) { k+= '7,'; }
    if (selectLinkArrow.contains(1)) { k+= '8,'; }
    if (selectLinkArrow.contains(2)) { k+= '9,'; }
    if (selectLinkArrow.contains(3)) { k+= '4,'; }
    if (selectLinkArrow.contains(5)) { k+= '6,'; }
    if (selectLinkArrow.contains(6)) { k+= '1,'; }
    if (selectLinkArrow.contains(7)) { k+= '2,'; }
    if (selectLinkArrow.contains(8)) { k+= '3,'; }
    if (k.endsWith(',')) {
      k = k.substring(0, k.length - 1);
    }
    return k;
  }

  String buildSearchKey() {
    var str = ' +(类:${parseCardType()})';
    if (effectController.text != '') {
      str += ' +(效果:${effectController.text})';
    }
    if (cardType == 1) {
      var ct2 = buildMagicCardType();
      if (ct2 != '') {
        str += ' +(类:$ct2)';
      }
    } else if (cardType == 2) {
      var ct2 = buildTrapCardType();
      if (ct2 != '') {
        str += ' +(类:$ct2)';
      }
    } else {
      // monster
      if (atkController.text != '') {
        str += ' +(atk:${atkController.text})';
      }
      if (defController.text != '') {
        str += ' +(def:${defController.text})';
      }
      if (levelController.text != '') {
        str += ' +(level:${levelController.text})';
      }
      if (scaleController.text != '') {
        str += ' +(刻度:${scaleController.text})';
      }
      if (linkController.text != '') {
        str += ' +(link:${linkController.text})';
      }
      var ct2 = buildMonsterCardType();
      if (ct2 != '') {
        str += ' +(类:$ct2)';
      }
      var race = buildMonsterRace();
      if (race != '') {
        str += ' +(族:$race)';
      }
      var ele = buildMonsterElement();
      if (ele != '') {
        str += ' +(属性:$ele)';
      }
      var la = buildMonsterLinkArrow();
      if (la != '') {
        str += ' +(linkArrow:$la)';
      }
    }

    return str;
  }
}
