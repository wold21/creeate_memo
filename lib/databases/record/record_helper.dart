import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/databases/database_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class RecordHelper extends ChangeNotifier {
  static final RecordHelper _instance = RecordHelper._internal();

  List<RecordInfo> _allRecords = [];
  List<RecordInfo> _favoriteRecords = [];

  RecordHelper._internal();

  factory RecordHelper() {
    return _instance;
  }

  Future<void> callUpdate() async {
    await getRecords();
    await getFavoriteRecords();
  }

  // Get record by id
  Future<RecordInfo?> getRecordById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db
        .query('records', where: 'id = ? AND isDelete = 0', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RecordInfo(
        id: maps.first['id'],
        title: maps.first['title'],
        description: maps.first['description'],
        createAt: maps.first['createAt'],
        updateAt: maps.first['updateAt'],
        isDelete: maps.first['isDelete'] == 1,
        isFavorite: maps.first['isFavorite'] == 1,
        replyCount: maps.first['replyCount'],
      );
    } else {
      return null;
    }
  }

  // Get all records
  Future<void> getRecords() async {
    final db = await DatabaseHelper().database;
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
    final db = await DatabaseHelper().database;
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
    final db = await DatabaseHelper().database;
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await callUpdate();
    await ContributionHelper()
        .addOrUpdateContribution(DateTime.parse(record.createAt), 'create');
  }

  // Toggle favorite
  Future<void> toggleFavorite(int id) async {
    final db = await DatabaseHelper().database;
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
    final db = await DatabaseHelper().database;
    await db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );

    await callUpdate();
    await ContributionHelper()
        .addOrUpdateContribution(DateTime.parse(record.createAt), 'update');
  }

  // Delete record
  Future<void> deleteRecord(int id) async {
    final db = await DatabaseHelper().database;
    final record = await getRecordById(id);
    if (record != null) {
      await db.update(
        'records',
        {'isDelete': 1},
        where: 'id = ?',
        whereArgs: [id],
      );

      await callUpdate();
      await ContributionHelper()
          .addOrUpdateContribution(DateTime.parse(record!.createAt), 'delete');
    } else {
      throw Exception('Record not found');
    }
  }
}
