import 'package:flutter/foundation.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:uuid/uuid.dart';

typedef StreakID = String;

@immutable
class StreakModel {
  const StreakModel({
    required this.id,
    required this.count,
    required this.timestamp,
  });

  final StreakID id;

  /// Only first emotion is required. Stored in db as id (an [int]).
  final int count;

  /// Used to track when the log was updated. Stored in db as milliseconds since epoch (an [int]).
  final int timestamp;

  factory StreakModel.fromEntity(Streak entity, {StreakID? id, int? timestamp}) {
    return StreakModel(
      id: id ?? entity.id ?? Uuid().v4(),
      count: entity.count,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Streak toEntity() {
    return Streak(
      id: id,
      count: count,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  factory StreakModel.fromMap(Map<String, dynamic> data) {
    final id = data['id'] as StreakID;
    final count = data['count'] as int;
    final timestamp = data['timestamp'] as int;

    return StreakModel(
      id: id,
      count: count,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count': count,
      'timestamp': timestamp,
    };
  }
}
