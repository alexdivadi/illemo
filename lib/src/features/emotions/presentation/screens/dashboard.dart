import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_today.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_log_tile.dart';
import 'package:illemo/src/features/streak/presentation/streak_widget.dart';
import 'package:illemo/src/features/streak/service/streak_service.dart';
import 'package:illemo/src/features/emotions/data/providers/emotion_stats.dart';
import 'package:illemo/src/utils/date.dart';
import 'package:illemo/src/utils/pluralize.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const path = "/dashboard";
  static const title = "Dashboard";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysEmotionLog = ref.watch(emotionTodayProvider);
    final streak = ref.watch(streakProvider);
    final today = DateTime.now().startOfDay;
    final top3EmotionsWeek = ref.watch(getTopEmotionsProvider(
      today.subtract(Duration(days: 7)),
      today,
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
      ),
      body: Center(
        child: todaysEmotionLog.when(
          data: (emotionLog) => Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  gapH32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(
                          child: Text(
                            'Your Daily Emotion Log!',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push(EmotionPickerScreen.path, extra: emotionLog),
                        child: Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(Sizes.p16),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: emotionLog != null
                              ? EmotionLogTile(
                                  emotionLog: emotionLog,
                                  height: 50,
                                  showNames: true,
                                )
                              : Container(
                                  height: 150,
                                  color: Theme.of(context).primaryColor,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(Sizes.p16),
                                  child: Center(
                                    child: Text(
                                      'Log your emotions!',
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(fontSize: Sizes.p24, color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  gapH32,
                  Image.asset(
                    'assets/common/troy_emotions.gif',
                    height: 150,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  gapH64,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: top3EmotionsWeek.when(
                            data: (top3Emotions) {
                              if (top3Emotions.isEmpty) {
                                return Container(
                                  height: 150,
                                  width: 200,
                                  color: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(Sizes.p16),
                                  child: const Center(
                                    child: Text("No emotions logged this week."),
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  Text(
                                    'Top ${"Emotion".pluralize(top3Emotions.length)} this Week',
                                    style: Theme.of(context).textTheme.titleSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  gapH8,
                                  Container(
                                    height: 150,
                                    width: 200,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Sizes.p16),
                                    ),
                                    child: EmotionLogTile(
                                      emotionLog: EmotionLog.fromEmotions(
                                          emotions: top3Emotions, date: today),
                                      height: 50,
                                      showNames: true,
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () => Container(
                              height: 150,
                              width: 200,
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.all(Sizes.p16),
                              child: const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                            error: (error, stack) => Container(
                              height: 150,
                              width: 200,
                              color: Colors.grey[200],
                              padding: const EdgeInsets.all(Sizes.p16),
                              child: Center(child: Icon(Icons.error)),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Center(
                            child: streak.isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : StreakWidget(streak.requireValue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const CircularProgressIndicator.adaptive(),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Text(
              "Something went wrong. Check your connection or try restarting the app.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
