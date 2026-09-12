import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:illemo/src/features/streak/domain/streak_model.dart';

void main() {
  test('streak increments, resets, and survives persistence conversion', () {
    final streak = Streak(count: 2, lastUpdated: DateTime(2026, 8, 15), id: 'current');

    expect(streak.increment().count, 3);
    expect(streak.reset().count, 0);
    expect(StreakModel.fromMap(StreakModel.fromEntity(streak).toMap()).toEntity(), streak);
  });
}
