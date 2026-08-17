import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';

void main() {
  test('emotion log survives persistence conversion', () {
    final date = DateTime(2026, 8, 16);
    final log = EmotionLog.fromEmotions(
      emotions: const [Emotion.joyful, Emotion.content],
      date: date,
      id: 'log-1',
    );

    final restored = EmotionLogModel.fromMap(
      EmotionLogModel.fromEntity(log, id: 'log-1', timestamp: 1).toMap(),
    ).toEntity();

    expect(restored, log);
    expect(restored.id, 'log-1');
  });
}
