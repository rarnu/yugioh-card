import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ktflutter/http_extension.dart';
import 'package:yugiohcard/deck.dart';
import 'package:yugiohcard/deckincategory.dart';

import 'global.dart';
import 'util/widgetutil.dart';

class DeckListRoute extends MaterialPageRoute {
  DeckListRoute() : super(builder: (context) => DeckListPage());
}

class DeckListPage extends StatefulWidget {
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckListPage> {

  final List<dynamic> cardTheme = <dynamic>[];
  final List<dynamic> cardCategory = <dynamic>[];

  getDeckListData() async {
    try {
      var categoryJson = JsonCodec().decode((await httpGet('$BASEURL/deckcategory')).body);
      var themeJson = JsonCodec().decode((await httpGet('$BASEURL/decktheme')).body);
      cardTheme.addAll(categoryJson);
      cardCategory.addAll(themeJson);
      setState(() {});
    } catch(e) {
    }
  }

  _DeckListState() : super() {
    getDeckListData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck List'),
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
                itemCount: cardTheme.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.0,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, DeckInCategoryRoute(cardTheme[index]['guid']));
                    },
                    child: sizedh(Text(cardTheme[index]['name']), height: 40),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Divider(),
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cardCategory.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.0,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, DeckRoute(cardCategory[index]['code']));
                    },
                    child: sizedh(Text(cardCategory[index]['name']), height: 40),
                  );
                }),
          ],
        )
      ),
    );
  }
}
