import 'package:equatable/equatable.dart';
import 'package:illemo/src/features/streak/domain/streak_model.dart';

class Streak extends Equatable {
  const Streak({
    required this.count,
    required this.lastUpdated,
    this.id,
  });

  /// Only first emotion is required. Stored in db as id (int).
  final int count;
  final DateTime lastUpdated;
  final StreakID? id;

  /// Returns true if the streak is broken,
  /// i.e. the difference between [lastUpdated] and `DateTime.now()` is more than one calendar day.
  bool get isBroken => DateTime.now().difference(lastUpdated).inDays > 1;

  @override
  List<Object?> get props => [count];

  @override
  bool get stringify => true;

  /// Returns a new [Streak] with the count incremented by 1.
  Streak increment() {
    return Streak(
      count: count + 1,
      lastUpdated: DateTime.now(),
      id: id,
    );
  }

  /// Returns a new [Streak] with the count reset to 0.
  Streak reset() {
    return Streak(
      count: 0,
      lastUpdated: DateTime.now(),
      id: id,
    );
  }

  Streak copyWith({
    int? count,
    DateTime? lastUpdated,
    StreakID? id,
  }) {
    return Streak(
      count: count ?? this.count,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      id: id ?? this.id,
    );
  }
}
