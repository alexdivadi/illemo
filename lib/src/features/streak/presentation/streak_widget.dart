import 'package:flutter/material.dart';
import 'package:illemo/src/constants/app_sizes.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget(this.streak, {super.key});

  final Streak streak;

  Color _getStreakColor() {
    if (streak.count >= 60) {
      return Colors.blueAccent;
    } else if (streak.count >= 30) {
      return Colors.purple;
    } else if (streak.count >= 14) {
      return Colors.red;
    } else if (streak.count >= 7) {
      return Colors.orange;
    } else if (streak.count >= 3) {
      return Colors.amber;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final streakStyle = TextStyle(
      fontSize: Sizes.p48,
      fontWeight: FontWeight.bold,
      color: _getStreakColor(),
    );
    return Column(
      children: [
        Text('${streak.count}', style: streakStyle),
        Text('day streak', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
