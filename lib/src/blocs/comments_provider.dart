import 'package:flutter/material.dart';
import 'package:hacker/src/blocs/comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  CommentsProvider({Key key, Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static CommentsBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CommentsProvider>().bloc;
}
