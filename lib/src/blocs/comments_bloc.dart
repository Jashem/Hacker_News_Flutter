import 'package:hacker/src/models/item_model.dart';
import 'package:hacker/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CommentsBloc {
  final _repository = Repository();
  final _fetchComments = PublishSubject<int>();
  final _commentOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  void Function(int) get fetchItemWithComment => _fetchComments.sink.add;

  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentOutput.stream;

  CommentsBloc() {
    _fetchComments.transform(_fetchCommentTransform()).pipe(_commentOutput);
  }

  _fetchCommentTransform() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then(
          (ItemModel item) {
            item.kids.forEach(
              (kidId) => fetchItemWithComment(kidId),
            );
          },
        );
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  void dispose() {
    _fetchComments.close();
    _commentOutput.close();
  }
}
