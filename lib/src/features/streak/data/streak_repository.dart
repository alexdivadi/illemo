import 'dart:async';

import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:illemo/src/features/streak/domain/streak_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'streak_repository.g.dart';

class StreakRepository {
  StreakRepository(this.database);

  final Database database;
  final _changes = StreamController<void>.broadcast();

  Future<void> addStreak(Streak streak, {StreakID? id}) => _save(streak, id: id);

  Future<Streak?> getStreak(StreakID id) async {
    final rows = await database.query('streaks', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : StreakModel.fromMap(rows.single).toEntity();
  }

  Stream<Streak?> getStreakStream(StreakID id) async* {
    yield await getStreak(id);
    await for (final _ in _changes.stream) {
      yield await getStreak(id);
    }
  }

  Future<void> updateStreak(Streak streak, {StreakID? id}) => _save(streak, id: id);

  Future<void> _save(Streak streak, {StreakID? id}) async {
    await database.insert(
      'streaks',
      StreakModel.fromEntity(streak, id: id).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _changes.add(null);
  }

  Future<void> deleteStreak(StreakID id) async {
    await database.delete('streaks', where: 'id = ?', whereArgs: [id]);
    _changes.add(null);
  }

  void dispose() => _changes.close();
}

@riverpod
StreakRepository streakRepository(Ref ref) {
  final repository = StreakRepository(ref.watch(appDatabaseProvider).requireValue);
  ref.onDispose(repository.dispose);
  return repository;
}
