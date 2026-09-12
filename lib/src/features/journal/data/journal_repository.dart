import 'dart:async';

import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/journal/data/journal_entry_model.dart';
import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'journal_repository.g.dart';

class JournalRepository {
  JournalRepository(this.database);

  final Database database;
  final _changes = StreamController<void>.broadcast();

  Stream<JournalEntry?> watchToday() => _watch(() async {
        final rows = await database.query(
          'journal_entries',
          where: 'date = ?',
          whereArgs: [DateTime.now().date],
          limit: 1,
        );
        return rows.isEmpty ? null : JournalEntryModel.fromMap(rows.single).toEntity();
      });

  Stream<List<JournalEntry>> watchRange(DateTime start, DateTime end) => _watch(() async {
        final rows = await database.query(
          'journal_entries',
          where: 'date >= ? AND date <= ?',
          whereArgs: [start.date, end.date],
          orderBy: 'date ASC',
        );
        return rows.map(JournalEntryModel.fromMap).map((model) => model.toEntity()).toList();
      });

  Future<void> saveToday(String body) async {
    final text = body.trim();
    final date = DateTime.now();
    final rows = await database.query(
      'journal_entries',
      columns: ['id'],
      where: 'date = ?',
      whereArgs: [date.date],
      limit: 1,
    );
    if (text.isEmpty) {
      await database.delete('journal_entries', where: 'date = ?', whereArgs: [date.date]);
    } else {
      await database.insert(
        'journal_entries',
        JournalEntryModel.fromEntity(JournalEntry(
          id: rows.isEmpty ? const Uuid().v4() : rows.single['id']! as String,
          body: text,
          date: date,
          updatedAt: date,
        )).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
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
JournalRepository journalRepository(Ref ref) {
  final repository = JournalRepository(ref.watch(appDatabaseProvider).requireValue);
  ref.onDispose(repository.dispose);
  return repository;
}

@riverpod
Stream<JournalEntry?> journalToday(Ref ref) => ref.watch(journalRepositoryProvider).watchToday();

@riverpod
Stream<List<JournalEntry>> journalRange(Ref ref, DateTime start, DateTime end) =>
    ref.watch(journalRepositoryProvider).watchRange(start, end);
