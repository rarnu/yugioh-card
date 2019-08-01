import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'util/widgetutil.dart';

class AboutRoute extends MaterialPageRoute {
  AboutRoute() : super(builder: (context) => AboutPage());
}

class AboutPage extends StatefulWidget {
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<AboutPage> {
  launchURL() async {
    const url = 'https://github.com/rarnu/yugioh-card';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 48, 8, 0),
        child: Column(
          children: <Widget>[
            expend(Container(
              child: Column(
                children: <Widget>[
                  sized(Image.asset('assets/logo.png'), height: 72),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'YuGiOh Card',
                      textScaleFactor: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '基于Flutter',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 255, 0)),
                        ),
                        sizedh(VerticalDivider(), height: 20),
                        Text(
                          '跨平台',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 255, 0)),
                        ),
                        sizedh(VerticalDivider(), height: 20),
                        Text(
                          '完全开源',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 255, 0)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '游戏王卡片查询器，数据来源 ourocg.cn',
                      style:
                          TextStyle(color: Color.fromARGB(255, 127, 127, 127)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('服务类型'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          '游戏工具类',
                          style: TextStyle(
                              color: Color.fromARGB(255, 127, 127, 127)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('开源信息'),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: GestureDetector(
                            onTap: () {
                              launchURL();
                            },
                            child: Text(
                              'github.com/rarnu/yugioh-card',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 127, 127, 127)),
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text('Copyright(R) rarnu 2019'),
            ),
          ],
        ),
      ),
    );
  }
}
