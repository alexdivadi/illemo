import 'dart:async';

import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_entry_model.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'emotion_repository.g.dart';

class EmotionRepository {
  EmotionRepository(this.database);

  final Database database;
  final _changes = StreamController<void>.broadcast();

  Stream<List<EmotionEntry>> watchToday() {
    final today = DateTime.now();
    return watchRange(today, today);
  }

  Stream<List<EmotionEntry>> watchRange(DateTime start, DateTime end) => _watch(() async {
        final rows = await database.query(
          'emotion_entries',
          where: 'date >= ? AND date <= ?',
          whereArgs: [start.date, end.date],
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
      final duplicate = Sqflite.firstIntValue(await txn.rawQuery(
            'SELECT COUNT(*) FROM emotion_entries WHERE date = ? AND id != ? AND COALESCE(deep_id, specific_id) = ?',
            [entry.loggedAt.date, entry.id, entry.emotionId],
          )) ??
          0;
      if (duplicate > 0) throw StateError('${entry.label} is already logged today.');
      if (existing.isEmpty) {
        final count = Sqflite.firstIntValue(await txn.rawQuery(
              'SELECT COUNT(*) FROM emotion_entries WHERE date = ?',
              [entry.loggedAt.date],
            )) ??
            0;
        if (count >= EmotionEntry.maxPerDay) {
          throw StateError('${EmotionEntry.maxPerDay} feelings are already logged today.');
        }
      }
      await txn.insert(
        'emotion_entries',
        EmotionEntryModel.fromEntity(entry).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    _changes.add(null);
  }

  Future<void> delete(EmotionEntryID id) async {
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
EmotionRepository emotionRepository(Ref ref) {
  final repository = EmotionRepository(ref.watch(appDatabaseProvider).requireValue);
  ref.onDispose(repository.dispose);
  return repository;
}

@riverpod
Stream<List<EmotionEntry>> emotionEntriesToday(Ref ref) {
  return ref.watch(emotionRepositoryProvider).watchToday();
}
