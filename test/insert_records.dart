import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> insertRandomRecords(Database db) async {
    final random = Random();
    for (int i = 0; i < 1000; i++) {
      int randomDay = random.nextInt(31) + 1;
      int randomMonth = random.nextInt(12) + 1;
      DateTime randomDate = DateTime(2024, randomMonth, randomDay);

      await db.insert(
        'records',
        {
          'title': 'test$i',
          'description':
              'testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i testDesc$i',
          'createAt': randomDate.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      await ContributionHelper().addOrUpdateContribution(
          DateTime(2024, randomMonth, randomDay), 'create');
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  test('insert random records into existing db', () async {
    String path = join(await getDatabasesPath(), 'record.db');
    final db = await openDatabase(path);
    try {
      await insertRandomRecords(db);

      final List<Map<String, dynamic>> records = await db.query('records');
      print('Total records: ${records.length}');
    } finally {
      await db.close();
    }
  }, timeout: Timeout(Duration(minutes: 5)));
}
