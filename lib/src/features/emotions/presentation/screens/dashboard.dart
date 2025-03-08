import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_today.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const path = "/dashboard";
  static const title = "Dashboard";

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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Today\'s Emotions', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: Sizes.p16),
                  todaysEmotionLog.hasError
                      ? Padding(
                          padding: const EdgeInsets.all(Sizes.p16),
                          child: Text(
                              "Something went wrong. Check your connection or try restarting the app.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.red)),
                        )
                      : InkWell(
                          onTap: () =>
                              context.push(EmotionPickerScreen.path, extra: todaysEmotionLog.value),
                          child: Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: todaysEmotionLog.value != null
                                ? _buildEmotionLog(todaysEmotionLog.value!)
                                : Container(
                                    height: 300,
                                    color: Theme.of(context).primaryColor,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(Sizes.p16),
                                    child: Center(
                                      child: Text(
                                        'Log your emotions!',
                                        style: const TextStyle(
                                            fontSize: Sizes.p24, color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmotionLog(EmotionLog emotionLog) {
    return Column(
      children: List.generate(3, (i) {
        if (emotionLog.emotions.length > i) {
          return Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.p16),
            color: emotionLog.emotions[i].color,
            child: Center(
                child:
                    Text('${emotionLog.emotions[i]}', style: const TextStyle(fontSize: Sizes.p24))),
          );
        } else {
          return Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.p16),
            color: Colors.grey[300],
          );
        }
      }),
    );
  }
}
