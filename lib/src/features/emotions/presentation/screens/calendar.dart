import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_today.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  static const path = "/calendar";
  static const title = "Calendar";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysEmotionLog = ref.watch(emotionTodayProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Center(
        child: todaysEmotionLog.isLoading
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: () => context.go(EmotionPickerScreen.path),
                child: todaysEmotionLog.value != null
                    ? Text('You are feeling ${todaysEmotionLog.value!.emotion1} today.')
                    : Text('Log your emotions!')),
      ),
    );
  }
}
