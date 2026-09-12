import 'package:equatable/equatable.dart';

typedef JournalEntryID = String;

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.body,
    required this.date,
    required this.updatedAt,
  });

  final JournalEntryID id;
  final String body;
  final DateTime date;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, body, date, updatedAt];
}
