import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:yugiohcard/global.dart';
import 'package:yugiohcard/packdetail.dart';
import 'util/widgetutil.dart';

class PackRoute extends MaterialPageRoute {
  PackRoute() : super(builder: (context) => PackPage());
}

class PackPage extends StatefulWidget {
  _PageState createState() => _PageState();
}

class _PageState extends State<PackPage> {
  List<dynamic> packs = [];
  List<dynamic> seasons = [];
  List<dynamic> packdetails = [];
  String currentSeason = '';

  _PageState() : super() {
    getPackData();
  }

  getPackData() async {
    try {
      var json = JsonCodec().decode((await httpGet('$BASEURL/packlist')).body);
      if (json['result'] == 0) {
        packs = json['data'];
        seasons = [];
        for (var item in packs) {
          if (currentSeason == '') {
            currentSeason = item['season'];
          }
          if (!seasons.contains(item['season'])) {
            seasons.add(item['season']);
          }
        }
        getCurrentSeasonPacks();
      }
    } catch(e) {

    }
  }

  getCurrentSeasonPacks() {
    packdetails = [];
    for (var item in packs) {
      if (item['season'] == currentSeason) {
        packdetails.add(item);
      }
    }
    setState(() {});
  }

  Color getSeasonColor(String s) => currentSeason == s
      ? Color.fromARGB(255, 255, 255, 255)
      : Color.fromARGB(255, 127, 127, 127);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Packages'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: sized(Row(
          children: <Widget>[
            expend(
              ListView.separated(
                itemCount: seasons.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        currentSeason = seasons[index];
                        getCurrentSeasonPacks();
                      },
                      child: Container(
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            expend(Text(
                              '  ${seasons[index]}',
                              style: TextStyle(
                                  color: getSeasonColor(seasons[index])),
                            )),
                          ],
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
              flex: 1,
            ),
            VerticalDivider(),
            expend(
              ListView.separated(
                itemCount: packdetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        var url = packdetails[index]['url'];
                        Navigator.push(context, PackDetailRoute(url));
                      },
                      child: Container(
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            expend(Text(
                              ' [${packdetails[index]['abbr']}]${packdetails[index]['name']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 0.8,
                            )),
                          ],
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
              flex: 4,
            )
          ],
        )));
  }
}
