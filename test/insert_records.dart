import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> insertRandomRecords(Database db) async {
    final random = Random();
    for (int i = 0; i < 50; i++) {
      int randomDay = random.nextInt(31) + 1;
      DateTime randomDate = DateTime(2024, 10, randomDay); // DateTime 형식으로 변환

      await db.insert(
        'records',
        {
          'title': 'test$i',
          'description': 'testDesc$i',
          'createAt': randomDate.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      await ContributionHelper()
          .addOrUpdateContribution(DateTime(2024, 10, randomDay), 'create');
    }
  }

  test('insert random records into existing db', () async {
    // 기존 DB 열기
    String path = join(await getDatabasesPath(), 'record.db');
    final db = await openDatabase(path);

    // 50개 레코드 삽입
    await insertRandomRecords(db);

    // 레코드 삽입 후 레코드 수를 확인하거나 필요한 추가 검증 수행
    final List<Map<String, dynamic>> records = await db.query('records');
    print('Total records: ${records.length}'); // 테스트 확인용 출력

    // 데이터베이스 닫기
    await db.close();
  });
}
