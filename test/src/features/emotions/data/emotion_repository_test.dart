import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  test('rejects the same emotion twice on one day', () async {
    final database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 1, onCreate: createDatabaseSchema),
    );
    final repository = EmotionRepository(database);
    addTearDown(() async {
      repository.dispose();
      await database.close();
    });
    final today = DateTime(2026, 8, 18);

    await repository.save(
      EmotionEntry(id: 'first', emotionId: 'joy.hopeful', loggedAt: today),
    );

    expect(
      () => repository.save(
        EmotionEntry(id: 'second', emotionId: 'joy.hopeful', loggedAt: today),
      ),
      throwsStateError,
    );
  });
}
