import 'package:equatable/equatable.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';

typedef EmotionEntryID = String;

class EmotionEntry extends Equatable {
  const EmotionEntry({
    required this.id,
    required this.emotionId,
    required this.loggedAt,
  });

  static const maxPerDay = 3;

  final EmotionEntryID id;
  final String emotionId;
  final DateTime loggedAt;

  Emotion get emotion => Emotion.get(emotionId);
  Category get category => emotion.category;
  Emotion get specific {
    final parts = emotionId.split('.');
    return Emotion.get(parts.take(2).join('.'));
  }

  Emotion? get deep => emotionId.split('.').length > 2 ? emotion : null;
  String get label => emotion.label;
  DateTime get date => loggedAt;

  @override
  List<Object?> get props => [id, emotionId, loggedAt];
}
