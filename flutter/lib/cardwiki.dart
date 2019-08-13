import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:yugiohcard/util/cardutil.dart';
import 'package:yugiohcard/util/widgetutil.dart';
import 'global.dart';

class CardWikiRoute extends MaterialPageRoute {
  CardWikiRoute(String hash, String wiki) : super(builder: (context) => CardWikiPage(hash, wiki));
}

class CardWikiPage extends StatefulWidget {
  String hash;
  String wiki;
  CardWikiPage(this.hash, this.wiki): super();
  _CardWikiState createState() => _CardWikiState(hash, wiki);
}

class _CardWikiState extends State<CardWikiPage> {

  String hash;
  String wiki;
  _CardWikiState(this.hash, this.wiki) : super();

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