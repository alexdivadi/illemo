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

  bool get isBroken => DateTime.now().difference(lastUpdated).inDays > 1;

  @override
  List<Object?> get props => [count];

  @override
  bool get stringify => true;

  Streak increment() {
    return Streak(
      count: count + 1,
      lastUpdated: DateTime.now(),
      id: id,
    );
  }
}
