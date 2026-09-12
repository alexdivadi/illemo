import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  test('migrates valid legacy records and ignores malformed JSON', () async {
    final database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 1, onCreate: createDatabaseSchema),
    );
    addTearDown(database.close);

    final count = await migrateLegacyEmotionLogs(database, [
      '{"id":"legacy","emotion1":40,"emotion2":null,"emotion3":null,"date":"2026-08-16","timestamp":1}',
      'invalid',
    ]);

    expect(count, 1);
    expect(await database.query('emotion_logs'), hasLength(1));
  });

  test('SQLite stores full history and updates streams', () async {
    final database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 1, onCreate: createDatabaseSchema),
    );
    final repository = EmotionRepository(database);
    addTearDown(() async {
      repository.dispose();
      await database.close();
    });

    for (var day = 1; day <= 8; day++) {
      await repository.save(
        EmotionEntry(
          id: '$day',
          emotionId: 'joy.hopeful',
          loggedAt: DateTime(2026, 8, day),
        ),
      );
    }
    expect(
      await repository.watchRange(DateTime(2026, 8, 1), DateTime(2026, 8, 8)).first,
      hasLength(8),
    );

    await repository.save(
      EmotionEntry(
        id: 'new',
        emotionId: 'sadness.lonely',
        loggedAt: DateTime(2026, 8, 8),
      ),
    );
    final entries = await repository.watchRange(DateTime(2026, 8, 8), DateTime(2026, 8, 8)).first;
    expect(entries.map((entry) => entry.emotionId), ['joy.hopeful', 'sadness.lonely']);
  });
}
