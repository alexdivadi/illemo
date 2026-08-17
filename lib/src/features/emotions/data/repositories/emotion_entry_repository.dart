import 'dart:async';

import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/data/models/emotion_entry_model.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'emotion_entry_repository.g.dart';

class EmotionEntryRepository {
  EmotionEntryRepository(this.database);

  final Database database;
  final _changes = StreamController<void>.broadcast();

  Stream<List<EmotionEntry>> watchToday() => _watch(() async {
        final rows = await database.query(
          'emotion_entries',
          where: 'date = ?',
          whereArgs: [DateTime.now().date],
          orderBy: 'logged_at ASC',
        );
        return rows.map(EmotionEntryModel.fromMap).map((model) => model.toEntity()).toList();
      });

  Future<void> save(EmotionEntry entry) async {
    await database.transaction((txn) async {
      final existing = await txn.query(
        'emotion_entries',
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [entry.id],
        limit: 1,
      );
      if (existing.isEmpty) {
        final count = Sqflite.firstIntValue(await txn.rawQuery(
              'SELECT COUNT(*) FROM emotion_entries WHERE date = ?',
              [entry.loggedAt.date],
            )) ??
            0;
        if (count >= 3) throw StateError('Three feelings are already logged today.');
      }
      await txn.insert(
        'emotion_entries',
        EmotionEntryModel.fromEntity(entry).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    _changes.add(null);
  }

  Future<void> delete(String id) async {
    await database.delete('emotion_entries', where: 'id = ?', whereArgs: [id]);
    _changes.add(null);
  }

  Stream<T> _watch<T>(Future<T> Function() load) async* {
    yield await load();
    await for (final _ in _changes.stream) {
      yield await load();
    }
  }

  void dispose() => _changes.close();
}

@Riverpod(keepAlive: true)
EmotionEntryRepository emotionEntryRepository(Ref ref) {
  final repository = EmotionEntryRepository(ref.watch(appDatabaseProvider).requireValue);
  ref.onDispose(repository.dispose);
  return repository;
}

@riverpod
Stream<List<EmotionEntry>> emotionEntriesToday(Ref ref) {
  return ref.watch(emotionEntryRepositoryProvider).watchToday();
}
