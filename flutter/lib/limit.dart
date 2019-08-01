import 'dart:convert';

import 'package:flutter/material.dart';
import 'util/widgetutil.dart';
import 'package:ktflutter/http_extension.dart';
import 'global.dart';
import 'util/cardutil.dart';
import 'carddetail.dart';

class LimitRoute extends MaterialPageRoute {
  LimitRoute() : super(builder: (context) => LimitPage());
}

class LimitPage extends StatefulWidget {
  _LimitState createState() => _LimitState();
}

class _LimitState extends State<LimitPage> {

  final List<dynamic> entries = <dynamic>[];

  getLimitData() async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/limit')).body);
      if (json['result'] == 0) {
        entries.addAll(json['data']);
        setState(() {});
      }
    } catch(e) {
    }
  }

  _LimitState() : super() {
    getLimitData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Limit Cards'),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.separated(
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                var hash = entries[index]['hashid'];
                Navigator.push(context, CardDetailRoute(hash));
              },
              child: Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      colorBlock(parseLimitBlock(entries[index]['color']), width: 26, height: 40, marginRight: 8),
                      expend(Text(parseName(entries[index]['name']))),
                      Text('${parseLimitStr(entries[index]['limit'])}',
                        style: TextStyle(color: parseLimitColor(entries[index]['limit'])),
                      ),
                    ],
                  ),
                )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
    );
  }
}
