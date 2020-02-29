import 'dart:async';
import 'dart:convert';
import 'package:hacker/src/models/item_model.dart';
import 'package:hacker/src/resources/repository.dart';
import 'package:http/http.dart' show Client;

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  var client = Client();

  Future<List<int>> fetchTopIds() async {
    final url = '$_root/topstories.json';
    final response = await client.get(url);
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final url = '$_root/item/$id.json';
    final response = await client.get(url);
    final map = json.decode(response.body);
    return ItemModel.fromJson(map);
  }
}
