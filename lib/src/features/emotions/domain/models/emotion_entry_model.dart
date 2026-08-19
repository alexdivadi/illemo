import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';

class EmotionEntryModel {
  const EmotionEntryModel({
    required this.id,
    required this.categoryId,
    required this.specificId,
    required this.loggedAt,
    this.deepId,
  });

  final String id;
  final String categoryId;
  final String specificId;
  final String? deepId;
  final int loggedAt;

  factory EmotionEntryModel.fromEntity(EmotionEntry entry) => EmotionEntryModel(
        id: entry.id,
        categoryId: entry.emotionId.split('.').first,
        specificId: entry.specific.id,
        deepId: entry.deep?.id,
        loggedAt: entry.loggedAt.millisecondsSinceEpoch,
      );

  factory EmotionEntryModel.fromMap(Map<String, Object?> map) => EmotionEntryModel(
        id: map['id']! as String,
        categoryId: map['core_id']! as String,
        specificId: map['specific_id']! as String,
        deepId: map['deep_id'] as String?,
        loggedAt: map['logged_at']! as int,
      );

  EmotionEntry toEntity() => EmotionEntry(
        id: id,
        emotionId: deepId ?? specificId,
        loggedAt: DateTime.fromMillisecondsSinceEpoch(loggedAt),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'core_id': categoryId,
        'specific_id': specificId,
        'deep_id': deepId,
        'logged_at': loggedAt,
        'date': DateTime.fromMillisecondsSinceEpoch(loggedAt).toIso8601String().substring(0, 10),
      };
}
