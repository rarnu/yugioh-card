import 'dart:convert';

import 'package:flutter/material.dart';
import 'deck.dart';
import 'util/widgetutil.dart';
import 'package:ktflutter/http_extension.dart';
import 'global.dart';

class DeckInCategoryRoute extends MaterialPageRoute {
  DeckInCategoryRoute(String hash) : super(builder: (context) => DeckInCategoryPage(hash));
}

class DeckInCategoryPage extends StatefulWidget {
  final String hash;
  DeckInCategoryPage(this.hash): super();
  _DeckInCategoryState createState() => _DeckInCategoryState(hash);
}

class _DeckInCategoryState extends State<DeckInCategoryPage> {

  String hash;
  final List<dynamic> deckList = <dynamic>[];

  getDeckListData() async {
    try {
      var deckJson = JsonCodec().decode((await httpGet('$BASEURL/deckincategory?hash=$hash')).body);
      deckList.addAll(deckJson);
      setState(() {});
    } catch(e) {
    }
  }

  _DeckInCategoryState(this.hash) : super() {
    getDeckListData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck In Category'),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: deckList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.0,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, DeckRoute(deckList[index]['code']));
                    },
                    child: sizedh(Text(deckList[index]['name']), height: 40),
                  );
                }),
          ],
        )
      ),
    );
  }
}
