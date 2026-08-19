import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/theme/app_colors.dart';

class EmotionLogTile extends StatelessWidget {
  const EmotionLogTile({
    super.key,
    required this.emotions,
    this.height = 100,
    this.showNames = false,
    this.child,
  });

  final List<Emotion> emotions;
  final double height;
  final bool showNames;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height * EmotionEntry.maxPerDay,
          child: emotions.isNotEmpty
              ? Column(
                  children: List.generate(EmotionEntry.maxPerDay, (i) {
                    if (emotions.length > i) {
                      final emotion = emotions[i];
                      return Container(
                        height: height,
                        width: double.infinity,
                        padding: const EdgeInsets.all(Sizes.p16),
                        color: emotion.category.cardFor(
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).brightness,
                        ),
                        child: Center(
                          child: showNames
                              ? FittedBox(
                                  child: Text(
                                    '$emotion',
                                    style: TextStyle(
                                      fontSize: Sizes.p24,
                                      color: emotion.category.foregroundOn(
                                        emotion.category.cardFor(
                                          Theme.of(context).colorScheme.surface,
                                          Theme.of(context).brightness,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      );
                    } else {
                      return Container(
                        height: height,
                        width: double.infinity,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.surfaceContainerHigh
                            : AppColors.chip,
                      );
                    }
                  }),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surfaceContainerHigh
                      : AppColors.chip,
                ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
