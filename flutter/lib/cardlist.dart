import 'dart:convert';

import 'package:flutter/material.dart';
import 'util/widgetutil.dart';
import 'package:ktflutter/http_extension.dart';
import 'global.dart';
import 'util/cardutil.dart';
import 'carddetail.dart';

class CardListRoute extends MaterialPageRoute {
  CardListRoute(String keyword) : super(builder: (context) => CardListPage(keyword));
}

class CardListPage extends StatefulWidget {
  final String keyword;
  CardListPage(this.keyword): super();
  _CardListState createState() => _CardListState(keyword);
}

class _CardListState extends State<CardListPage> {

  List<dynamic> entries = <dynamic>[];
  String keyword;
  int currentPage = 1;
  int totalPage = 0;

  searchCard() async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/search?key=$keyword&page=$currentPage')).body);
      currentPage = json['meta']['cur_page'];
      totalPage = json['meta']['total_page'];
      entries = <dynamic>[];
      entries.addAll(json['cards']);
      setState(() {});
    } catch(e) {
    }
  }

  _CardListState(this.keyword) : super() {
    searchCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
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
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          var hash = entries[index]['hash_id'];
                          Navigator.push(context, CardDetailRoute(hash));
                        },
                        child: Container(
                          height: 80,
                          child: Row(
                            children: <Widget>[
                              expend(Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  expend(sized(Text('中文名称:  ' + entries[index]['name_nw']), height:20)),
                                  expend(sized(Text('日文名称:  ' + parseName(entries[index]['name_ja'])), height: 20)),
                                  expend(sized(Text('英文名称:  ' + parseName(entries[index]['name_en'])), height: 20)),
                                  expend(sized(Text('卡片类型:  ' + entries[index]['type_st']), height: 20)),
                                ],
                              )),
                              FadeInImage.assetNetwork(
                                  placeholder: 'assets/img0.png',
                                  image: entries[index]['img_url']
                              ),
                            ],
                          ),
                        )
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              )),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.fast_rewind),
                    onPressed: () {
                      if (currentPage != 1) {
                        currentPage = 1;
                        searchCard();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      if (currentPage > 1) {
                        currentPage--;
                        searchCard();
                      }
                    },
                  ),
                  expend(Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('$currentPage / $totalPage'),
                    ],

                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      if (currentPage < totalPage) {
                        currentPage++;
                        searchCard();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fast_forward),
                    onPressed: () {
                      if (currentPage != totalPage) {
                        currentPage = totalPage;
                        searchCard();
                      }
                    },
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}
