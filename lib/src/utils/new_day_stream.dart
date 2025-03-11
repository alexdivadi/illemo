import 'dart:async';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_day_stream.g.dart';

/// A stream that emits a new value every day at midnight.
///
/// This is useful for updating the UI when a new day starts.
@riverpod
Stream<DateTime> newDayStream(Ref ref) async* {
  while (true) {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    await Future.delayed(durationUntilMidnight);

    yield DateTime.now();
  }
}
