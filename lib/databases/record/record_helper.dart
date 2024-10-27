import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/databases/database_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class RecordHelper extends ChangeNotifier {
  static final RecordHelper _instance = RecordHelper._internal();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _page = 1;
  final int limit = 15;
  List<RecordInfo> _allRecords = [];
  List<RecordInfo> _favoriteRecords = [];
  List<RecordInfo> _historyRecords = [];

  RecordHelper._internal();

  factory RecordHelper() {
    return _instance;
  }

  Future<void> callUpdate({String createAt = ''}) async {
    // await getRecords();
    await getFavoriteRecords();
    if (createAt.isNotEmpty) {
      await getRecordsByDate(DateTime.parse(createAt));
    }
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
        isDelete: maps.first['isDelete'],
        isFavorite: maps.first['isFavorite'],
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
        isDelete: maps[i]['isDelete'],
        isFavorite: maps[i]['isFavorite'],
        replyCount: maps[i]['replyCount'],
      );
    });

    notifyListeners();
  }

  Future<void> getRecordsPage({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;

    final offset = refresh ? 0 : (_page - 1) * limit;
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query('records',
        where: 'isDelete = 0',
        orderBy: 'createAt DESC',
        limit: limit,
        offset: offset);

    if (refresh) {
      _allRecords = maps
          .map((map) => RecordInfo(
                id: map['id'],
                title: map['title'],
                description: map['description'],
                createAt: map['createAt'],
                updateAt: map['updateAt'],
                isDelete: map['isDelete'],
                isFavorite: map['isFavorite'],
                replyCount: map['replyCount'],
              ))
          .toList();
      _page = 1;
    } else {
      final newRecords = maps
          .map((map) => RecordInfo(
                id: map['id'],
                title: map['title'],
                description: map['description'],
                createAt: map['createAt'],
                updateAt: map['updateAt'],
                isDelete: map['isDelete'],
                isFavorite: map['isFavorite'],
                replyCount: map['replyCount'],
              ))
          .toList();

      if (newRecords.isNotEmpty) {
        _allRecords.addAll(newRecords);
        _page++;
      } else {
        _isLoading = false;
        return;
      }
    }
    _isLoading = false;
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
        isDelete: maps[i]['isDelete'],
        isFavorite: maps[i]['isFavorite'],
        replyCount: maps[i]['replyCount'],
      );
    });

    notifyListeners();
  }

  List<RecordInfo> get favoriteRecords => _favoriteRecords;

  Future<void> getRecordsByDate(DateTime conditionDate) async {
    final db = await DatabaseHelper().database;
    String formattedConditionDate =
        DateFormat('yyyyMMdd').format(conditionDate);

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
  SELECT * FROM records
    WHERE strftime('%Y%m%d', createAt) = ? AND isDelete = 0 Order By createAt DESC, id DESC
''', [formattedConditionDate]);
    _historyRecords = List.generate(maps.length, (i) {
      return RecordInfo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        createAt: maps[i]['createAt'],
        updateAt: maps[i]['updateAt'],
        isDelete: maps[i]['isDelete'],
        isFavorite: maps[i]['isFavorite'],
        replyCount: maps[i]['replyCount'],
      );
    });
    notifyListeners();
  }

  List<RecordInfo> get historyRecords => _historyRecords;

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
    final recordIndex = _allRecords.indexWhere((element) => element.id == id);
    if (recordIndex == -1) return;

    final record = _allRecords[recordIndex];
    final isFavorite = record.isFavorite == 1 ? 0 : 1;
    await db.update(
      'records',
      {'isFavorite': isFavorite},
      where: 'id = ?',
      whereArgs: [id],
    );

    _allRecords[recordIndex] =
        _allRecords[recordIndex].copyWith(isFavorite: isFavorite);

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

    final recordIndex =
        _allRecords.indexWhere((element) => element.id == record.id);
    if (recordIndex != -1) {
      _allRecords[recordIndex] =
          record.copyWith(); // 필요한 경우 copyWith 메서드를 사용해 변경
    }

    // await callUpdate(createAt: record.createAt);
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
          .addOrUpdateContribution(DateTime.parse(record.createAt), 'delete');
    } else {
      throw Exception('Record not found');
    }
  }
}
