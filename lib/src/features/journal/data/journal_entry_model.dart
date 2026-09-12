import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/utils/date.dart';

class JournalEntryModel {
  const JournalEntryModel({
    required this.id,
    required this.body,
    required this.date,
    required this.updatedAt,
  });

  final String id;
  final String body;
  final String date;
  final int updatedAt;

  factory JournalEntryModel.fromEntity(JournalEntry entry) => JournalEntryModel(
        id: entry.id,
        body: entry.body,
        date: entry.date.date,
        updatedAt: entry.updatedAt.millisecondsSinceEpoch,
      );

  factory JournalEntryModel.fromMap(Map<String, Object?> map) => JournalEntryModel(
        id: map['id']! as String,
        body: map['body']! as String,
        date: map['date']! as String,
        updatedAt: map['updated_at']! as int,
      );

  JournalEntry toEntity() => JournalEntry(
        id: id,
        body: body,
        date: DateTime.parse(date),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'body': body,
        'date': date,
        'updated_at': updatedAt,
      };
}
