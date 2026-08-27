import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/data/emotion_taxonomy_migration.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  test('migrates obsolete emotion IDs once by label or nearest ancestor', () async {
    final database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 1, onCreate: createDatabaseSchema),
    );
    addTearDown(database.close);
    await database.insert('emotion_entries', {
      'id': 'renamed',
      'core_id': 'sadness',
      'specific_id': 'sadness.exhausted',
      'deep_id': 'sadness.exhausted.drained',
      'logged_at': 1,
      'date': '2026-08-26',
    });
    await database.insert('emotion_entries', {
      'id': 'removed',
      'core_id': 'anger',
      'specific_id': 'anger.overwhelmed',
      'deep_id': 'anger.overwhelmed.out_of_control',
      'logged_at': 2,
      'date': '2026-08-27',
    });

    expect(await database.transaction(migrateEmotionTaxonomy), 2);
    expect(await database.transaction(migrateEmotionTaxonomy), 0);

    final rows = await database.query('emotion_entries', orderBy: 'id');
    expect(rows[0]['specific_id'], 'anger');
    expect(rows[0]['deep_id'], isNull);
    expect(rows[1]['specific_id'], 'sadness.tired');
    expect(rows[1]['deep_id'], 'sadness.tired.drained');
    expect(
      await database.query(
        'metadata',
        where: 'key = ?',
        whereArgs: ['emotion_taxonomy_version'],
      ),
      [containsPair('value', '$emotionTaxonomyVersion')],
    );
  });
}
