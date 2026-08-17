import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_definition.dart';

String emotionInsight(List<EmotionEntry> emotions) {
  final keys = emotions.map((emotion) => emotion.core.core).toList();
  if (keys.contains(EmotionKey.joy) && keys.contains(EmotionKey.sadness)) {
    return 'You’re holding joy and sadness at once — a sign of how fully you’re showing up today.';
  }
  if (keys.where((key) => key == EmotionKey.fear || key == EmotionKey.anger).length >= 2) {
    return 'A heavy mix today. Try one slow breath and one small thing you can control.';
  }
  if (keys.length >= 2 && keys.every((key) => key == EmotionKey.joy)) {
    return 'A genuinely good day — worth pausing to notice and let it in.';
  }
  if (keys.contains(EmotionKey.anger) && keys.contains(EmotionKey.sadness)) {
    return 'Anger and sadness often travel together. Both are real, and both are welcome here.';
  }
  if (keys.contains(EmotionKey.fear) && keys.contains(EmotionKey.joy)) {
    return 'Feeling hopeful and scared at the same time usually means something matters.';
  }
  if (keys.contains(EmotionKey.fear)) {
    return 'Whatever feels uncertain right now — you don’t have to solve it all today.';
  }
  if (keys.contains(EmotionKey.joy)) {
    return 'Something lit you up today. That matters more than it might seem.';
  }
  if (keys.contains(EmotionKey.sadness)) {
    return 'Hard days are part of the picture too. Be gentle with yourself tonight.';
  }
  return 'You checked in today. That alone takes a quiet kind of courage.';
}
