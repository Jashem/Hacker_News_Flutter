import 'package:flutter/material.dart';
import 'package:hacker/src/blocs/stories_provider.dart';
import './screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: MaterialApp(
        title: "Hacker News",
        home: NewsList(),
      ),
    );
  }
}
