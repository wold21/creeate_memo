import 'package:create_author/databases/database_helper.dart';
import 'package:create_author/models/contribution.dart';
import 'package:flutter/material.dart';

class ContributionHelper extends ChangeNotifier {
  static final ContributionHelper _instance = ContributionHelper._internal();

  ContributionHelper._internal();

  factory ContributionHelper() {
    return _instance;
  }

  // Get contributions by year and month
  Future<Map<DateTime, int>> getContributionsByYearAndMonth(
      int year, int month) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('contributions',
        where: 'year = ? AND month = ?',
        whereArgs: [year, month],
        orderBy: 'createAt DESC');
    Map<DateTime, int> contributions = {};
    for (var map in maps) {
      DateTime date = DateTime(map['year'], map['month'], map['day']);
      contributions[date] = map['count'];
    }
    return contributions;
  }

  // get contribution id
  Future<ContributionInfo?> _getContribution(
      int year, int month, int day) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, Object?>> maps = await db.query('contributions',
        columns: [
          'id',
          'year',
          'month',
          'day',
          'count',
          'lastUpdateAt',
        ],
        where: 'year = ? AND month = ? AND day = ?',
        whereArgs: [year, month, day]);
    if (maps.isNotEmpty) {
      return ContributionInfo.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> addOrUpdateContribution(DateTime createAt, String mode,
      {int count = 1}) async {
    int year = createAt.year;
    int month = createAt.month;
    int day = createAt.day;

    ContributionInfo? contribution = await _getContribution(year, month, day);
    if (contribution == null) {
      await addContribution(year, month, day, count: count);
    } else {
      await updateContribution(contribution, mode);
    }
    notifyListeners();
  }

  // Add contribution
  Future<void> addContribution(int year, int month, int day,
      {int count = 1}) async {
    final db = await DatabaseHelper().database;
    await db.insert('contributions', {
      'year': year,
      'month': month,
      'day': day,
      'count': count,
      'lastUpdateAt': DateTime.now().toIso8601String(),
    });
  }

  // Update contribution
  Future<void> updateContribution(
      ContributionInfo contribution, String mode) async {
    final db = await DatabaseHelper().database;
    if (mode == 'delete') {
      if (contribution.count - 1 == 0) {
        await db.delete('contributions',
            where: 'id = ?', whereArgs: [contribution.id]);
        return;
      } else {
        await db.update(
            'contributions',
            {
              'count': contribution.count - 1,
              'lastUpdateAt': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [contribution.id]);
      }
    } else {
      await db.update(
          'contributions',
          {
            'count': contribution.count + 1,
            'lastUpdateAt': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [contribution.id]);
    }
  }
}
