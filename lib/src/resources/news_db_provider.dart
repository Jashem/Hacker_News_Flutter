import 'package:hacker/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  NewsDbProvider() {
    init();
  }

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items2.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (newDb, version) {
        newDb.execute('''
        CREATE TABLE Items
        (
          id INTEGER PRIMARY KEY,
          type TEXT,
          by TEXT,
          time INTEGER,
          parent INTEGER,
          kids BLOB,
          dead INTEGER,
          deleted INTEGER,
          text TEXT,
          url TEXT,
          score INTEGER,
          title TEXT,
          descendants INTEGER
        )
        ''');
      },
    );
  }

  Future<List<int>> fetchTopIds() async {
    return null;
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
      'Items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clear() async {
    return db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();
