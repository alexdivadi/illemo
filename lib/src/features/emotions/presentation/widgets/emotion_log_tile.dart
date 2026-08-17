import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/theme/app_colors.dart';

class EmotionLogTile extends StatelessWidget {
  const EmotionLogTile({
    super.key,
    required this.emotionLog,
    this.height = 100,
    this.showNames = false,
    this.child,
  });

  final EmotionLog? emotionLog;
  final double height;
  final bool showNames;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height * EmotionLog.logSize,
          child: emotionLog != null
              ? Column(
                  children: List.generate(EmotionLog.logSize, (i) {
                    if (emotionLog!.emotions.length > i) {
                      final emotion = emotionLog!.emotions[i];
                      return Container(
                        height: height,
                        width: double.infinity,
                        padding: const EdgeInsets.all(Sizes.p16),
                        color: emotion.category.softColor,
                        child: Center(
                          child: showNames
                              ? FittedBox(
                                  child: Text(
                                    '$emotion',
                                    style: TextStyle(
                                      fontSize: Sizes.p24,
                                      color: emotion.category.baseColor.shade900,
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
                        color: AppColors.chip,
                      );
                    }
                  }),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.chip,
                ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
