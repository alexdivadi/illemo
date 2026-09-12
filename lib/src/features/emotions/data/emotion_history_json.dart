import 'dart:convert';

import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_entry_model.dart';
import 'package:illemo/src/utils/date.dart';

/// Versioned backups retain stored calendar dates, including migrated history
/// whose date may differ from the timestamp's local date.
class EmotionHistoryJson {
  static String encode(List<Map<String, Object?>> rows) =>
      jsonEncode({'version': 1, 'entries': rows});

  static List<Map<String, Object?>> decode(String source) {
    final data = jsonDecode(source);
    if (data is! Map<String, dynamic> || data['version'] != 1 || data['entries'] is! List) {
      throw const FormatException('Unsupported emotion history backup.');
    }
    final rows = <Map<String, Object?>>[];
    final ids = <String>{};
    final days = <String, Set<String>>{};
    for (final value in data['entries'] as List) {
      if (value is! Map<String, dynamic> ||
          value['id'] is! String ||
          (value['id'] as String).trim().isEmpty ||
          value['core_id'] is! String ||
          value['specific_id'] is! String ||
          (value['deep_id'] != null && value['deep_id'] is! String) ||
          value['logged_at'] is! int ||
          value['date'] is! String) {
        throw const FormatException('Invalid emotion history entry.');
      }
      final date = value['date'] as String;
      final parsedDate = DateTime.tryParse(date);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
          parsedDate == null ||
          parsedDate.date != date) {
        throw const FormatException('Invalid emotion history date.');
      }
      late Map<String, Object?> row;
      late EmotionEntry entry;
      try {
        entry = EmotionEntryModel.fromMap(value).toEntity();
        row = EmotionEntryModel.fromEntity(entry).toMap();
      } on ArgumentError {
        throw const FormatException('Invalid emotion or timestamp.');
      }
      if (row['core_id'] != value['core_id'] ||
          row['specific_id'] != value['specific_id'] ||
          row['deep_id'] != value['deep_id']) {
        throw const FormatException('Inconsistent emotion hierarchy.');
      }
      final emotions = days.putIfAbsent(date, () => <String>{});
      if (!ids.add(entry.id) ||
          !emotions.add(entry.emotionId) ||
          emotions.length > EmotionEntry.maxPerDay) {
        throw const FormatException('Duplicate entries or too many emotions in a day.');
      }
      rows.add({...row, 'date': date});
    }
    return rows;
  }
}
