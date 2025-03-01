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

  /// Returns a list of emotions in the log.
  List<Emotion> get emotions =>
      [emotion1, if (emotion2 != null) emotion2!, if (emotion3 != null) emotion3!];

  @override
  List<Object?> get props => [emotion1, emotion2, emotion3, date];

  @override
  bool get stringify => true;

  /// Factory constructor to create an EmotionLog from a list of emotions.
  factory EmotionLog.fromEmotions({
    required List<Emotion> emotions,
    required DateTime date,
    EmotionLogID? id,
  }) {
    assert(emotions.isNotEmpty && emotions.length <= 3,
        'Emotions list must contain between 1 and 3 items.');
    return EmotionLog(
      emotion1: emotions[0],
      emotion2: emotions.length > 1 ? emotions[1] : null,
      emotion3: emotions.length > 2 ? emotions[2] : null,
      date: date,
      id: id,
    );
  }

  /// Creates a copy of the current EmotionLog with updated values.
  EmotionLog copyWith({
    Emotion? emotion1,
    Emotion? emotion2,
    Emotion? emotion3,
    DateTime? date,
    EmotionLogID? id,
  }) {
    return EmotionLog(
      emotion1: emotion1 ?? this.emotion1,
      emotion2: emotion2 ?? this.emotion2,
      emotion3: emotion3 ?? this.emotion3,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }
}
