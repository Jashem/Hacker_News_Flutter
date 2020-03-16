import 'package:flutter/material.dart';
import 'package:hacker/src/models/item_model.dart';
import 'package:html/parser.dart' show parse;

import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final double depth;
  final Map<int, Future<ItemModel>> itemMap;

  Comment({this.itemId, this.itemMap, this.depth});

  String parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadinContainer();
        }

        final item = snapshot.data;

        final children = <Widget>[
          ListTile(
            title: Text(parseHtmlString(item.text)),
            subtitle: item.by == '' ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16,
              left: depth * 16,
            ),
          ),
          Divider()
        ];

        snapshot.data.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }
}
