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
    final parentId = emotion.parentId;
    if (parentId == null) return emotion;
    final parent = Emotion.get(parentId);
    return parent.isCategory ? emotion : parent;
  }

  Emotion? get deep {
    final parentId = emotion.parentId;
    return parentId == null || Emotion.get(parentId).isCategory ? null : emotion;
  }

  String get label => emotion.label;
  DateTime get date => loggedAt;

  @override
  List<Object?> get props => [id, emotionId, loggedAt];
}
