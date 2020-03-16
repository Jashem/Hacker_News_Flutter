import 'package:flutter/material.dart';
import 'package:hacker/src/blocs/stories_provider.dart';
import 'package:hacker/src/models/item_model.dart';
import 'package:hacker/src/widgets/loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int id;

  NewsListTile(this.id);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadinContainer();
        }
        return FutureBuilder(
          future: snapshot.data[id],
          builder: (context, AsyncSnapshot<ItemModel> snapshot) {
            if (!snapshot.hasData) {
              return LoadinContainer();
            }
            return buildTile(context, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/$id');
          },
          title: Text(item.title),
          subtitle: Text('${item.score} votes'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.message),
              Text('${item.descendants}'),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 8,
        ),
      ],
    );
  }
}
