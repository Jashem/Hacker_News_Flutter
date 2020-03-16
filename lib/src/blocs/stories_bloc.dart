import 'package:hacker/src/models/item_model.dart';
import 'package:hacker/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _fetchItemInput = PublishSubject<int>();
  final _itemOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemOutput.stream;
  void Function(int) get fetchItem => _fetchItemInput.sink.add;

  StoriesBloc() {
    _fetchItemInput.stream.transform(_fetchItemTransform()).pipe(_itemOutput);
  }

  Future<void> fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _fetchItemTransform() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  Future<void> clear() {
    return _repository.clear();
  }

  void dispose() {
    _topIds.close();
    _fetchItemInput.close();
    _itemOutput.close();
  }
}
