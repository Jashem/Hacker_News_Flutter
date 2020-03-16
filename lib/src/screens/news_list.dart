import 'package:flutter/material.dart';
import 'package:hacker/src/blocs/stories_bloc.dart';
import 'package:hacker/src/blocs/stories_provider.dart';
import 'package:hacker/src/widgets/news_list_tile.dart';
import 'package:hacker/src/widgets/refresh.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    StoriesBloc bloc = StoriesProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Top News"),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return Refresh(
      child: StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);
              return NewsListTile(snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}
