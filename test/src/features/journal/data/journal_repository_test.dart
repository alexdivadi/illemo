import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/journal/data/journal_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  test('version 3 migration creates journal storage', () async {
    final database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(database.close);

    await migrateJournalEntries(database);

    expect(
      await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'journal_entries'",
      ),
      hasLength(1),
    );
  });

  test('one journal entry is saved per day and whitespace deletes it', () async {
    final database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 3, onCreate: createDatabaseSchema),
    );
    final repository = JournalRepository(database);
    addTearDown(() async {
      repository.dispose();
      await database.close();
    });

    await repository.saveToday(' First note ');
    await repository.saveToday('Updated note');

    expect((await repository.watchToday().first)?.body, 'Updated note');
    expect(await database.query('journal_entries'), hasLength(1));

    await repository.saveToday('   \n');

    expect(await repository.watchToday().first, isNull);
  });
}
