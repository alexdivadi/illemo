import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/data/app_database.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/settings/application/export_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  late Database database;
  late EmotionRepository repository;
  late ExportService service;

  EmotionEntry entry(String id, int day, [String emotion = 'joy.hopeful']) =>
      EmotionEntry(id: id, emotionId: emotion, loggedAt: DateTime(2026, 8, day, 12));

  List<dynamic> entries(String backup) => (jsonDecode(backup) as Map)['entries'] as List;

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(version: 3, onCreate: createDatabaseSchema),
    );
    repository = EmotionRepository(database);
    final container = ProviderContainer.test(overrides: [
      emotionRepositoryProvider.overrideWithValue(repository),
    ]);
    service = container.read(exportServiceProvider);
  });

  tearDown(() async {
    repository.dispose();
    await database.close();
  });

  test('exports all history and inclusive, open-ended calendar-day ranges', () async {
    expect(entries(await service.exportHistory()), isEmpty);
    for (var day = 1; day <= 3; day++) {
      await repository.save(entry('$day', day));
    }
    expect(entries(await service.exportHistory()), hasLength(3));
    expect(entries(await service.exportHistory(startDate: DateTime(2026, 8, 2))), hasLength(2));
    expect(entries(await service.exportHistory(endDate: DateTime(2026, 8, 2))), hasLength(2));
    final filtered = entries(await service.exportHistory(
      startDate: DateTime(2026, 8, 2, 23),
      endDate: DateTime(2026, 8, 2),
    ));
    expect(filtered.single['id'], '2');
    await expectLater(
        service.exportHistory(
          startDate: DateTime(2026, 8, 3),
          endDate: DateTime(2026, 8, 1),
        ),
        throwsArgumentError);
  });

  test('round trips IDs, deep emotions, timestamps and stored dates', () async {
    await repository.save(entry('deep', 2, 'joy.hopeful.optimistic'));
    // Migrated records can have a calendar date independent of their timestamp.
    await database.update('emotion_entries', {'date': '2026-08-01'});
    final backup = await service.exportHistory();
    await repository.delete('deep');
    expect(await service.importHistory(backup), 1);
    expect(await service.exportHistory(), backup);
    expect(await service.importHistory(backup), 0);
    expect(await service.importHistory('{"version":1,"entries":[]}', override: true), 0);
    expect(await service.exportHistory(), backup);
  });

  test('skips whole occupied days by default and replaces only imported days', () async {
    await repository.save(entry('incoming', 1));
    await repository.save(entry('new-day', 2));
    final backup = await service.exportHistory();
    await repository.delete('incoming');
    await repository.delete('new-day');
    await repository.save(entry('old-one', 1, 'sadness.lonely'));
    await repository.save(entry('old-two', 1, 'fear.anxious'));
    await repository.save(entry('untouched', 3));

    expect(await service.importHistory(backup), 1);
    expect(entries(await service.exportHistory()).map((row) => row['id']),
        ['old-one', 'old-two', 'new-day', 'untouched']);
    expect(await service.importHistory(backup, override: true), 2);
    expect(entries(await service.exportHistory()).map((row) => row['id']),
        ['incoming', 'new-day', 'untouched']);
  });

  test('rejects invalid backups before deleting or inserting anything', () async {
    await repository.save(entry('original', 1));
    final backup = await service.exportHistory();
    final row = Map<String, dynamic>.from(entries(backup).single as Map);
    final invalidRows = [
      {...row, 'id': ''},
      {...row, 'specific_id': 'missing'},
      {...row, 'core_id': 'fear'},
      {...row, 'date': '2026-02-30'},
      {...row, 'logged_at': 'yesterday'},
      {...row, 'logged_at': 8640000000000001},
      {...row, 'deep_id': false},
    ];
    for (final malformed in [
      'not json',
      '[]',
      '{"version":2,"entries":[]}',
      for (final invalid in invalidRows)
        jsonEncode({
          'version': 1,
          'entries': [row, invalid]
        }),
      jsonEncode({
        'version': 1,
        'entries': [row, row]
      }),
      jsonEncode({
        'version': 1,
        'entries': [
          row,
          {...row, 'id': 'duplicate-emotion'}
        ]
      }),
      jsonEncode({
        'version': 1,
        'entries': [
          for (final emotion in ['joy.hopeful', 'joy.content', 'joy.grateful', 'joy.proud'])
            {...row, 'id': emotion, 'specific_id': emotion},
        ]
      }),
    ]) {
      await expectLater(service.importHistory(malformed, override: true), throwsFormatException);
      expect(await service.exportHistory(), backup);
    }
  });

  test('ID conflict on another day rolls back earlier writes and deletions', () async {
    await repository.save(entry('first', 1));
    await repository.save(entry('collision', 2));
    final backup = await service.exportHistory();
    await repository.delete('first');
    await repository.delete('collision');
    await repository.save(entry('existing', 1));
    await repository.save(entry('collision', 3));
    final before = await service.exportHistory();
    await expectLater(
        service.importHistory(backup, override: true), throwsA(isA<DatabaseException>()));
    expect(await service.exportHistory(), before);
  });

  test('successful import refreshes repository stream subscribers', () async {
    await repository.save(entry('incoming', 1));
    final backup = await service.exportHistory();
    await repository.delete('incoming');
    final stream =
        StreamIterator(repository.watchRange(DateTime(2026, 8, 1), DateTime(2026, 8, 1)));
    addTearDown(stream.cancel);
    expect(await stream.moveNext(), isTrue);
    expect(stream.current, isEmpty);
    final next = stream.moveNext();
    await service.importHistory(backup);
    expect(await next.timeout(const Duration(seconds: 5)), isTrue);
    expect(stream.current.single.id, 'incoming');
  });
}
