import 'dart:convert';

import 'package:flutter/material.dart';
import 'util/widgetutil.dart';
import 'package:ktflutter/http_extension.dart';
import 'global.dart';
import 'util/cardutil.dart';
import 'carddetail.dart';

class PackDetailRoute extends MaterialPageRoute {
  PackDetailRoute(String url) : super(builder: (context) => PackDetailPage(url));
}

class PackDetailPage extends StatefulWidget {
  final String url;
  PackDetailPage(this.url): super();
  _PackDetailState createState() => _PackDetailState(url);
}

class _PackDetailState extends State<PackDetailPage> {

  List<dynamic> detail = [];
  String url;

  getPackDetail() async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/packdetail?url=$url')).body);
      detail = [];
      detail.addAll(json['cards']);
      setState(() {});
    } catch(e) {

    }
  }

  _PackDetailState(this.url) : super() {
    getPackDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards in Package'),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },),
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              expend(Container(
                child: ListView.separated(
                  itemCount: detail.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          var hash = detail[index]['hash_id'];
                          Navigator.push(context, CardDetailRoute(hash));
                        },
                        child: Container(
                          height: 80,
                          child: Row(
                            children: <Widget>[
                              expend(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  expend(sized(Text('中文名称:  ' + detail[index]['name_nw']), height:20)),
                                  expend(sized(Text('日文名称:  ' + parseName(detail[index]['name_ja'])), height: 20)),
                                  expend(sized(Text('英文名称:  ' + parseName(detail[index]['name_en'])), height: 20)),
                                  expend(sized(Text('卡片类型:  ' + detail[index]['type_st']), height: 20)),
                                ],
                              )),
                              FadeInImage.assetNetwork(
                                  placeholder: 'assets/img0.png',
                                  image: detail[index]['img_url']
                              ),
                            ],
                          ),
                        )
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              )),
            ],
          )
      ),
    );
  }
}
