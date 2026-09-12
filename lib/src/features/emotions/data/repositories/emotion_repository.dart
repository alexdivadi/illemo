import 'dart:async';

import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/data/emotion_history_json.dart';
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

  Future<String> exportHistory({DateTime? startDate, DateTime? endDate}) async {
    if (startDate != null && endDate != null && startDate.date.compareTo(endDate.date) > 0) {
      throw ArgumentError('startDate must not be after endDate.');
    }
    final conditions = <String>[
      if (startDate != null) 'date >= ?',
      if (endDate != null) 'date <= ?',
    ];
    final rows = await database.query(
      'emotion_entries',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: [if (startDate != null) startDate.date, if (endDate != null) endDate.date],
      orderBy: 'date ASC, logged_at ASC, id ASC',
    );
    return EmotionHistoryJson.encode(rows);
  }

  Future<int> importHistory(String json, {bool override = false}) async {
    final rows = EmotionHistoryJson.decode(json);
    final days = <String, List<Map<String, Object?>>>{};
    for (final row in rows) {
      days.putIfAbsent(row['date']! as String, () => []).add(row);
    }
    final imported = await database.transaction((txn) async {
      var count = 0;
      for (final day in days.entries) {
        final existing = await txn.query(
          'emotion_entries',
          columns: ['id'],
          where: 'date = ?',
          whereArgs: [day.key],
          limit: 1,
        );
        if (existing.isNotEmpty && !override) continue;
        if (override) {
          await txn.delete('emotion_entries', where: 'date = ?', whereArgs: [day.key]);
        }
        for (final row in day.value) {
          // Abort on ID conflicts: never replace a record belonging to another day.
          await txn.insert('emotion_entries', row, conflictAlgorithm: ConflictAlgorithm.abort);
          count++;
        }
      }
      return count;
    });
    if (imported > 0) _changes.add(null);
    return imported;
  }

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
