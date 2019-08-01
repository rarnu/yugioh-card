import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:yugiohcard/util/cardutil.dart';
import 'package:yugiohcard/util/widgetutil.dart';
import 'global.dart';

class CardWikiRoute extends MaterialPageRoute {
  CardWikiRoute(String hash) : super(builder: (context) => CardWikiPage(hash));
}

class CardWikiPage extends StatefulWidget {
  String hash;
  CardWikiPage(this.hash): super();
  _CardWikiState createState() => _CardWikiState(hash);
}

class _CardWikiState extends State<CardWikiPage> {

  String hash;
  String wiki = '';
  
  _CardWikiState(this.hash) : super() {
    getCardWiki();
  }

  getCardWiki() async {
    try {
      wiki = (await httpGet('$BASEURL/cardwiki?hash=$hash')).body;
      setState(() {});
    } catch(e) {

    }
  }

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Wiki'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            Html(
              data: wiki,
              linkStyle: TextStyle(
                  color: Color.fromARGB(255, 180, 180, 180),
                  decoration: TextDecoration.underline
              ),
              onLinkTap: (url) {

              },
            )
          ],
        )
    );
  }
}