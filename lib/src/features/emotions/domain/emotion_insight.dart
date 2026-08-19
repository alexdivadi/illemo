import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';

String emotionInsight(List<EmotionEntry> emotions) {
  final keys = emotions.map((emotion) => emotion.category).toList();
  if (keys.contains(Category.joyful) && keys.contains(Category.sad)) {
    return 'You’re holding joy and sadness at once — a sign of how fully you’re showing up today.';
  }
  if (keys.where((key) => key == Category.scared || key == Category.mad).length >= 2) {
    return 'A heavy mix today. Try one slow breath and one small thing you can control.';
  }
  if (keys.length >= 2 && keys.every((key) => key == Category.joyful)) {
    return 'A genuinely good day — worth pausing to notice and let it in.';
  }
  if (keys.contains(Category.mad) && keys.contains(Category.sad)) {
    return 'Anger and sadness often travel together. Both are real, and both are welcome here.';
  }
  if (keys.contains(Category.scared) && keys.contains(Category.joyful)) {
    return 'Feeling hopeful and scared at the same time usually means something matters.';
  }
  if (keys.contains(Category.scared)) {
    return 'Whatever feels uncertain right now — you don’t have to solve it all today.';
  }
  if (keys.contains(Category.joyful)) {
    return 'Something lit you up today. That matters more than it might seem.';
  }
  if (keys.contains(Category.sad)) {
    return 'Hard days are part of the picture too. Be gentle with yourself tonight.';
  }
  return 'You checked in today. That alone takes a quiet kind of courage.';
}
