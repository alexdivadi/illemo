import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_log_tile.dart';
import 'package:intl/intl.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({
    super.key,
    required this.date,
    required this.emotionLog,
    this.isComplete = false,
  });

  final DateTime date;
  final EmotionLog? emotionLog;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final currentDate = DateTime(date.year, date.month, date.day);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      // Minus 2 for border width, minus 6 for padding
      final tileHeight = (constraints.maxHeight - Sizes.p8) / EmotionLog.logSize;
      return Container(
        margin: const EdgeInsets.all(Sizes.p2),
        decoration: BoxDecoration(
          border: Border.all(
            color: () {
              switch (currentDate.compareTo(today)) {
                case 0:
                  return emotionLog != null
                      ? isComplete
                          ? Colors.amber
                          : Colors.grey
                      : Colors.grey.withAlpha(75);
                case -1:
                  return emotionLog != null
                      ? isComplete
                          ? Colors.amber
                          : Colors.grey
                      : Colors.grey.withAlpha(75);
                case 1:
                  return Colors.transparent;
                default:
                  return Colors.transparent;
              }
            }(),
            width: Sizes.p2,
          ),
          borderRadius: BorderRadius.circular(Sizes.p4),
        ),
        child: InkWell(
          onTap: () {
            if (emotionLog != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('On ${DateFormat.yMMMMd().format(currentDate)} you felt:'),
                    content: EmotionLogTile(
                      emotionLog: emotionLog,
                      height: 100,
                      showNames: true,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: currentDate.isAfter(today)
              ? SizedBox(
                  height: constraints.maxHeight,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.5),
                          radius: 10.0,
                          child: Text(
                            '${currentDate.day}',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.5),
                              fontSize: 9.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : EmotionLogTile(
                  emotionLog: emotionLog,
                  height: tileHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                      radius: 10.0,
                      child: Text(
                        '${currentDate.day}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 9.0,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
