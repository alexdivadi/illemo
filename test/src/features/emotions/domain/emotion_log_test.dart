import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_entry_model.dart';

void main() {
  test('emotion entry survives persistence conversion', () {
    final date = DateTime(2026, 8, 16);
    final entry = EmotionEntry(
      id: 'log-1',
      emotionId: 'joy.content.peaceful',
      loggedAt: date,
    );

    final restored = EmotionEntryModel.fromMap(
      EmotionEntryModel.fromEntity(entry).toMap(),
    ).toEntity();

    expect(restored, entry);
    expect(restored.id, 'log-1');
  });
}
