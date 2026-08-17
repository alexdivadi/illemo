import 'dart:async';

import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:sqflite/sqflite.dart';

class EmotionRepositoryLocal implements EmotionRepository {
  EmotionRepositoryLocal({required this.database});

  final Database database;
  final _changes = StreamController<void>.broadcast();

  @override
  final String userID = 'local';

  @override
  Future<EmotionLogID> addEmotionLog(EmotionLog emotionLog) async {
    final model = EmotionLogModel.fromEntity(emotionLog);
    await database.insert('emotion_logs', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _changes.add(null);
    return model.id;
  }

  @override
  Future<void> updateEmotionLog(EmotionLogID id, EmotionLog emotionLog) async {
    final model = EmotionLogModel.fromEntity(emotionLog, id: id);
    await database.insert('emotion_logs', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    _changes.add(null);
  }

  @override
  Future<void> deleteEmotionLog(EmotionLogID id) async {
    await database.delete('emotion_logs', where: 'id = ?', whereArgs: [id]);
    _changes.add(null);
  }

  @override
  Future<EmotionLog?> getEmotionLog(EmotionLogID id) async {
    final rows = await database.query('emotion_logs', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : EmotionLogModel.fromMap(rows.single).toEntity();
  }

  @override
  Stream<EmotionLog?> getEmotionLogToday() => _watch(() async {
        final rows = await database.query(
          'emotion_logs',
          where: 'date = ?',
          whereArgs: [DateTime.now().date],
          limit: 1,
        );
        return rows.isEmpty ? null : EmotionLogModel.fromMap(rows.single).toEntity();
      });

  @override
  Stream<List<EmotionLog>> getEmotionLogs({DateTime? startDate, DateTime? endDate}) =>
      _watch(() async {
        final clauses = <String>[];
        final arguments = <Object?>[];
        if (startDate != null) {
          clauses.add('date >= ?');
          arguments.add(startDate.date);
        }
        if (endDate != null) {
          clauses.add('date <= ?');
          arguments.add(endDate.date);
        }
        final rows = await database.query(
          'emotion_logs',
          where: clauses.isEmpty ? null : clauses.join(' AND '),
          whereArgs: arguments,
          orderBy: 'date DESC',
        );
        return rows.map(EmotionLogModel.fromMap).map((model) => model.toEntity()).toList();
      });

  Stream<T> _watch<T>(Future<T> Function() load) async* {
    yield await load();
    await for (final _ in _changes.stream) {
      yield await load();
    }
  }

  @override
  void dispose() => _changes.close();
}
