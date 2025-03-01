import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_today_service.g.dart';

@Riverpod(keepAlive: true)
class EmotionTodayService extends _$EmotionTodayService {
  late final EmotionRepository _emotionRepository;

  @override
  Future<EmotionLog?> build() {
    _emotionRepository = ref.watch(emotionRepositoryProvider);
    return _emotionRepository.getEmotionLogToday();
  }

  void updateEmotionLogToday(EmotionLogID? id, EmotionLog emotionLog) async {
    if (id == null) {
      id = await _emotionRepository.addEmotionLog(emotionLog);
    } else {
      await _emotionRepository.updateEmotionLog(id, emotionLog);
    }
    log('Updated today\'s emotions: $emotionLog');
    state = AsyncValue<EmotionLog?>.data(emotionLog.copyWith(id: id));
  }

  void deleteEmotionLogToday(EmotionLogID id) async {
    await _emotionRepository.deleteEmotionLog(id);
    log('Deleted today\'s emotions.');
    state = AsyncValue.data(null);
  }
}

@riverpod
Future<void> uploadEmotionLog(Ref ref, List<int> emotionIds, EmotionLogID? id) async {
  final emotions = emotionIds.map((id) => Emotion.get(id)).toList();
  final EmotionLog log = EmotionLog.fromEmotions(
    emotions: emotions,
    date: DateTime.now(),
    id: id,
  );
  final EmotionTodayService emotionTodayService = ref.read(emotionTodayServiceProvider.notifier);
  return emotionTodayService.updateEmotionLogToday(id, log);
}
