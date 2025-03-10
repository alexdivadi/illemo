import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_today_service.g.dart';

class EmotionTodayService {
  EmotionTodayService(this.emotionRepository);

  final EmotionRepository emotionRepository;

  void updateEmotionLogToday(EmotionLogID? id, EmotionLog emotionLog) async {
    if (id == null) {
      id = await emotionRepository.addEmotionLog(emotionLog);
    } else {
      await emotionRepository.updateEmotionLog(id, emotionLog);
    }
    log('Updated today\'s emotions: $emotionLog');
  }

  void deleteEmotionLogToday(EmotionLogID id) async {
    await emotionRepository.deleteEmotionLog(id);
    log('Deleted today\'s emotions.');
  }
}

@riverpod
EmotionTodayService emotionTodayService(Ref ref) {
  final EmotionRepository emotionRepository = ref.watch(emotionRepositoryProvider);
  return EmotionTodayService(emotionRepository);
}

@riverpod
Future<void> uploadEmotionLog(Ref ref, List<int> emotionIds, EmotionLogID? id) async {
  final emotions = emotionIds.map((id) => Emotion.get(id)).toList();
  final EmotionLog log = EmotionLog.fromEmotions(
    emotions: emotions,
    date: DateTime.now(),
    id: id,
  );
  final EmotionTodayService emotionTodayService = ref.read(emotionTodayServiceProvider);
  return emotionTodayService.updateEmotionLogToday(id, log);
}
