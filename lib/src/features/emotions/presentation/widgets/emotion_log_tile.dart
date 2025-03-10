import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';

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
                        color: emotion.color,
                        child: Center(
                          child: showNames
                              ? FittedBox(
                                  child: Text('$emotion',
                                      style:
                                          TextStyle(fontSize: Sizes.p24, color: emotion.textColor)),
                                )
                              : null,
                        ),
                      );
                    } else {
                      return Container(
                        height: height,
                        width: double.infinity,
                        color: Colors.grey[300],
                      );
                    }
                  }),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
