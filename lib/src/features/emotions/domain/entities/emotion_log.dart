import 'package:equatable/equatable.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';

class EmotionLog extends Equatable {
  const EmotionLog({
    required this.emotion1,
    required this.date,
    this.emotion2,
    this.emotion3,
    this.id,
  });

  /// Only first emotion is required. Stored in db as id (int).
  final Emotion emotion1;
  final Emotion? emotion2;
  final Emotion? emotion3;

  /// Used for date only, not time.
  final DateTime date;

  /// Optional parameter for tracking doc id in firestore.
  final EmotionLogID? id;

  @override
  List<Object?> get props => [emotion1, emotion2, emotion3, date];

  @override
  bool get stringify => true;
}
