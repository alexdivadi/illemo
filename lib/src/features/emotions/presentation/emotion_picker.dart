import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/service/emotion_today_service.dart';

class EmotionPickerScreen extends ConsumerWidget {
  const EmotionPickerScreen({super.key});

  static const path = "/emotion/pick";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysEmotionLog = ref.watch(emotionTodayServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an Emotion'),
      ),
      body: Center(
        child: todaysEmotionLog.isLoading
            ? const CircularProgressIndicator.adaptive()
            : Column(
                children: [
                  if (todaysEmotionLog.value != null)
                    Text('You are feeling ${todaysEmotionLog.value!.emotion1} today.'),
                  Text('Pick an emotion.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(emotionTodayServiceProvider.notifier).updateEmotionLogToday(
                            todaysEmotionLog.value?.id,
                            EmotionLog(date: DateTime.now(), emotion1: Emotion.appreciated),
                          );
                    },
                    child: const Text('Happy'),
                  ),
                ],
              ),
      ),
    );
  }
}
