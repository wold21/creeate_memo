import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecordHelper extends ChangeNotifier {
  static final RecordHelper _instance = RecordHelper._internal();

  // Database instance
  static Database? _database;
  List<RecordInfo> _allRecords = [];
  List<RecordInfo> _favoriteRecords = [];

  RecordHelper._internal();

  factory RecordHelper() {
    return _instance;
  }

  // Database opened or create
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Database initialization
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'record.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String sql =
            'CREATE TABLE records(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updateAt TIMESTAMP DEFAULT NULL, isDelete INTEGER DEFAULT 0, isFavorite INTEGER DEFAULT 0, replyCount INTEGER DEFAULT 0)';
        return db.execute(
          sql,
        );
      },
    );
  }

  Future<void> callUpdate() async {
    await getRecords();
    await getFavoriteRecords();
  }

  // Get all records
  Future<void> getRecords() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('records',
        where: 'isDelete = 0', orderBy: 'createAt DESC');
    _allRecords = List.generate(maps.length, (i) {
      return RecordInfo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        createAt: maps[i]['createAt'],
        updateAt: maps[i]['updateAt'],
        isDelete: maps[i]['isDelete'] == 1,
        isFavorite: maps[i]['isFavorite'] == 1,
        replyCount: maps[i]['replyCount'],
      );
    });

    notifyListeners();
  }

  List<RecordInfo> get allRecords => _allRecords;

  // Get favorite records
  Future<void> getFavoriteRecords() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('records',
        where: 'isDelete = 0 AND isFavorite = 1', orderBy: 'createAt DESC');
    _favoriteRecords = List.generate(maps.length, (i) {
      return RecordInfo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        createAt: maps[i]['createAt'],
        updateAt: maps[i]['updateAt'],
        isDelete: maps[i]['isDelete'] == 1,
        isFavorite: maps[i]['isFavorite'] == 1,
        replyCount: maps[i]['replyCount'],
      );
    });

    notifyListeners();
  }

  List<RecordInfo> get favoriteRecords => _favoriteRecords;

  // Insert record
  Future<void> insertRecord(RecordInfo record) async {
    final db = await database;
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    callUpdate();
  }

  // Toggle favorite
  Future<void> toggleFavorite(int id) async {
    final db = await database;
    final record = _allRecords.firstWhere((element) => element.id == id);
    await db.update(
      'records',
      {'isFavorite': record.isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    await callUpdate();
  }

  // Update record
  Future<void> updateRecord(RecordInfo record) async {
    final db = await database;
    await db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );

    callUpdate();
  }

  // Delete record
  Future<void> deleteRecord(int id) async {
    final db = await database;
    await db.update(
      'records',
      {'isDelete': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    callUpdate();
  }
}
