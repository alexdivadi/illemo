import 'dart:developer';

import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_today_service.g.dart';

@riverpod
class EmotionTodayService extends _$EmotionTodayService {
  late final EmotionRepository _emotionRepository;

  @override
  Future<EmotionLog?> build() {
    _emotionRepository = ref.watch(emotionRepositoryProvider);
    return _emotionRepository.getEmotionLogToday();
  }

  void updateEmotionLogToday(EmotionLogID? id, EmotionLog emotionLog) async {
    if (id == null) {
      await _emotionRepository.addEmotionLog(emotionLog);
    } else {
      await _emotionRepository.updateEmotionLog(id, emotionLog);
    }
    log('Updated today\'s emotions: $emotionLog');
    state = AsyncValue<EmotionLog?>.data(emotionLog);
  }

  void deleteEmotionLogToday(EmotionLogID id) async {
    await _emotionRepository.deleteEmotionLog(id);
    log('Deleted today\'s emotions.');
    state = AsyncValue.data(null);
  }
}
