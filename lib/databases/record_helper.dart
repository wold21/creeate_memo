import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecordHelper extends ChangeNotifier {
  static final RecordHelper _instance = RecordHelper._internal();

  // Database instance
  static Database? _database;

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
            'CREATE TABLE records(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, isFavorite INTEGER, replyCount INTEGER, updateAt INTEGER)';
        return db.execute(
          sql,
        );
      },
    );
  }

  // Get all records
  Future<List<RecordInfo>> getRecords() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('records');
    return List.generate(maps.length, (i) {
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
  }

  // Insert record
  Future<void> insertRecord(RecordInfo record) async {
    final db = await database;
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
