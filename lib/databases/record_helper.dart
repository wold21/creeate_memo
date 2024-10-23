import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecordHelper extends ChangeNotifier {
  static final RecordHelper _instance = RecordHelper._internal();

  // Database instance
  static Database? _database;
  List<RecordInfo> _records = [];

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

  // Get all records
  Future<void> getRecords({bool isFavorite = false}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('records',
        where: 'isDelete = 0 AND isFavorite = ?',
        whereArgs: [isFavorite ? 1 : 0],
        orderBy: 'createAt DESC');
    _records = List.generate(maps.length, (i) {
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

  List<RecordInfo> get records => _records;

  // Insert record
  Future<void> insertRecord(RecordInfo record) async {
    final db = await database;
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getRecords();
  }

  // Toggle favorite
  Future<void> toggleFavorite(int id) async {
    final db = await database;
    final record = _records.firstWhere((element) => element.id == id);
    await db.update(
      'records',
      {'isFavorite': record.isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    await getRecords();
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

    await getRecords();
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
    await getRecords();
  }
}
