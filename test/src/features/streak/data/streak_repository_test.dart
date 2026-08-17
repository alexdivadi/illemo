import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/streak/data/streak_repository.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  test('SQLite persists streaks without an account', () async {
    final database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 1, onCreate: createDatabaseSchema),
    );
    final repository = StreakRepository(database);
    addTearDown(() async {
      repository.dispose();
      await database.close();
    });

    await repository.addStreak(
      Streak(id: 'current', count: 3, lastUpdated: DateTime(2026, 8, 16)),
    );

    expect((await repository.getStreak('current'))?.count, 3);
  });
}
