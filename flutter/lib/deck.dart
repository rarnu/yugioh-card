import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:yugiohcard/util/widgetutil.dart';

import 'global.dart';

class DeckRoute extends MaterialPageRoute {
  DeckRoute(String code) : super(builder: (context) => DeckPage(code));
}

class DeckPage extends StatefulWidget {
  String code;

  DeckPage(this.code) : super();

  _DeckState createState() => _DeckState(code);
}

class _DeckState extends State<DeckPage> {
  String code;
  final List<dynamic> deckList = <dynamic>[];

  getDeckData() async {
    try {
      var deckJson =
          JsonCodec().decode((await httpGet('$BASEURL/deck?code=$code')).body);
      deckList.addAll(deckJson);
      // print(deckJson);
      setState(() {});
    } catch (e) {}
  }

  _DeckState(this.code) : super() {
    getDeckData();
  }

  _buildDeckData(List<dynamic> inMonster, List<dynamic> inMagicTrap,
      List<dynamic> inExtra, void block(List<dynamic> outList)) async {
    var max = inMonster.length;
    if (inMagicTrap.length > max) {
      max = inMagicTrap.length;
    }
    if (inExtra.length > max) {
      max = inExtra.length;
    }
    var o1 = [...inMonster];
    var o2 = [...inMagicTrap];
    var o3 = [...inExtra];
    for (var i = o1.length; i < max; i++) {
      o1.add({'count': 0, 'name': ''});
    }
    for (var i = o2.length; i < max; i++) {
      o2.add({'count': 0, 'name': ''});
    }
    for (var i = o3.length; i < max; i++) {
      o3.add({'count': 0, 'name': ''});
    }
    var out = <dynamic>[];
    for (var i = 0; i < max; i++) {
      out.add(o1[i]);
      out.add(o2[i]);
      out.add(o3[i]);
    }
    block(out);
  }

  List<Widget> _buildUI() {
    var list = <Widget>[];
    deckList.forEach((item) {
      list.add(Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          item['name'],
          style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.normal),
        ),
      ));
      var d1 = item['monster'];
      var d2 = item['magictrap'];
      var d3 = item['extra'];
      _buildDeckData(d1, d2, d3, (out) {
        list.add(
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: out.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 6.0,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return sizedh(Text(out[index]['count'] == 0 ? '' : '${out[index]['count']} ${out[index]['name']}', style: TextStyle(
                  fontSize: 10.0
                ),), height: 40);
              }),
        );
      });
      list.add(Image.network("https://www.ygo-sem.cn/${item['image']}"));
      list.add(Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
        child: Divider(),
      ));
    });
    return list;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          child: ListView(
            children: _buildUI(),
          )),
    );
  }
}
