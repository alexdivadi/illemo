import 'package:flutter/foundation.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:uuid/uuid.dart';

typedef EmotionLogID = String;

@immutable
class EmotionLogModel {
  const EmotionLogModel({
    required this.id,
    required this.emotion1,
    required this.date,
    required this.timestamp,
    this.emotion2,
    this.emotion3,
  });

  final EmotionLogID id;

  /// Only first emotion is required. Stored in db as id (an [int]).
  final int emotion1;
  final int? emotion2;
  final int? emotion3;

  /// Used for date only, not time.
  /// Format is `yyyy-MM-dd`.
  final String date;

  /// Used to track when the log was updated. Stored in db as milliseconds since epoch (an [int]).
  final int timestamp;

  factory EmotionLogModel.fromEntity(EmotionLog entity, {EmotionLogID? id, int? timestamp}) {
    return EmotionLogModel(
      id: id ?? Uuid().v4(),
      emotion1: entity.emotion1.id,
      emotion2: entity.emotion2?.id,
      emotion3: entity.emotion3?.id,
      date: entity.date.date,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  EmotionLog toEntity() {
    return EmotionLog(
      id: id,
      emotion1: Emotion.get(emotion1),
      emotion2: emotion2 != null ? Emotion.get(emotion2!) : null,
      emotion3: emotion3 != null ? Emotion.get(emotion3!) : null,
      date: DateTime.parse(date),
    );
  }

  factory EmotionLogModel.fromMap(Map<String, dynamic> data) {
    final id = data['id'] as EmotionLogID;
    final emotion1 = data['emotion1'] as int;
    final emotion2 = data['emotion2'] as int?;
    final emotion3 = data['emotion3'] as int?;
    final date = data['date'] as String;
    final timestamp = data['timestamp'] as int;

    return EmotionLogModel(
      id: id,
      emotion1: emotion1,
      emotion2: emotion2,
      emotion3: emotion3,
      date: date,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotion1': emotion1,
      'emotion2': emotion2,
      'emotion3': emotion3,
      'date': date,
      'timestamp': timestamp,
    };
  }
}
