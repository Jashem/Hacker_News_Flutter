import 'package:flutter/material.dart';
import 'package:hacker/src/blocs/comments_bloc.dart';
import 'package:hacker/src/blocs/comments_provider.dart';
import 'package:hacker/src/models/item_model.dart';
import 'package:hacker/src/widgets/comment.dart';
import 'package:hacker/src/widgets/loading_container.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        stream: bloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapShot) {
          if (!snapShot.hasData) {
            return LoadinContainer();
          }

          final fetchItem = snapShot.data[itemId];

          return FutureBuilder(
              future: fetchItem,
              builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return LoadinContainer();
                }

                return buildList(itemSnapshot.data, snapShot.data);
              });
        });
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final commentList = item.kids.map(
      (kidId) => Comment(
        itemMap: itemMap,
        itemId: kidId,
        depth: 1,
      ),
    );
    children.addAll(commentList);

    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
