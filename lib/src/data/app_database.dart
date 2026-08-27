import 'dart:convert';

import 'package:illemo/src/features/emotions/data/emotion_taxonomy_migration.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'app_database.g.dart';

Future<void> createDatabaseSchema(Database db, int version) async {
  await db.execute(
      'CREATE TABLE emotion_logs (id TEXT PRIMARY KEY, emotion1 INTEGER NOT NULL, emotion2 INTEGER, emotion3 INTEGER, date TEXT NOT NULL UNIQUE, timestamp INTEGER NOT NULL)');
  await db.execute(
      'CREATE TABLE streaks (id TEXT PRIMARY KEY, count INTEGER NOT NULL, timestamp INTEGER NOT NULL)');
  await db.execute('CREATE TABLE metadata (key TEXT PRIMARY KEY, value TEXT NOT NULL)');
  await _createEmotionEntriesTable(db);
  await migrateJournalEntries(db);
}

Future<void> _createEmotionEntriesTable(DatabaseExecutor db) => db.execute(
      'CREATE TABLE emotion_entries (id TEXT PRIMARY KEY, core_id TEXT NOT NULL, specific_id TEXT NOT NULL, deep_id TEXT, logged_at INTEGER NOT NULL, date TEXT NOT NULL)',
    );

Future<void> migrateJournalEntries(DatabaseExecutor db) => db.execute(
      'CREATE TABLE journal_entries (id TEXT PRIMARY KEY, body TEXT NOT NULL, date TEXT NOT NULL UNIQUE, updated_at INTEGER NOT NULL)',
    );

Future<void> migrateEmotionEntries(DatabaseExecutor db) async {
  final logs = await db.query('emotion_logs');
  for (final log in logs) {
    final timestamp = log['timestamp']! as int;
    final emotionIds = [log['emotion1'], log['emotion2'], log['emotion3']].whereType<int>();
    var index = 0;
    for (final emotionId in emotionIds) {
      final legacy = _legacyEmotionPath(emotionId);
      await db.insert(
        'emotion_entries',
        {
          'id': '${log['id']}-$index',
          'core_id': legacy.$1,
          'specific_id': legacy.$2,
          'deep_id': null,
          'logged_at': timestamp + index,
          'date': log['date'],
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      index++;
    }
  }
}

(String, String) _legacyEmotionPath(int id) {
  if (id <= 13) return ('sadness', 'sadness.lonely');
  if (id <= 26) return ('joy', 'joy.content');
  if (id <= 39) return ('surprise', 'surprise.amazed');
  if (id <= 52) return ('joy', 'joy.hopeful');
  if (id <= 65) return ('fear', 'fear.anxious');
  return ('anger', 'anger.frustrated');
}

Future<int> migrateLegacyEmotionLogs(DatabaseExecutor db, Iterable<String> values) async {
  var migrated = 0;
  for (final value in values) {
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      await db.insert(
        'emotion_logs',
        {
          'id': data['id'],
          'emotion1': data['emotion1'],
          'emotion2': data['emotion2'],
          'emotion3': data['emotion3'],
          'date': data['date'],
          'timestamp': data['timestamp'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      migrated++;
    } on Object {
      // Keep the legacy preference untouched if a malformed record cannot migrate.
    }
  }
  return migrated;
}

@Riverpod(keepAlive: true)
Future<Database> appDatabase(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final db = await openDatabase(
    '${await getDatabasesPath()}/illemo.db',
    version: 3,
    onCreate: createDatabaseSchema,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await _createEmotionEntriesTable(db);
        await migrateEmotionEntries(db);
      }
      if (oldVersion < 3) await migrateJournalEntries(db);
    },
  );
  if ((await db.query('metadata', where: 'key = ?', whereArgs: ['legacy_emotions_migrated']))
      .isEmpty) {
    await db.transaction((txn) async {
      await migrateLegacyEmotionLogs(
        txn,
        prefs.keys
            .where((key) => key.startsWith('emotions_'))
            .map(prefs.getString)
            .whereType<String>(),
      );
      await migrateEmotionEntries(txn);
      await txn.insert('metadata', {'key': 'legacy_emotions_migrated', 'value': '1'});
    });
  }
  await db.transaction(migrateEmotionTaxonomy);
  ref.onDispose(db.close);
  return db;
}
