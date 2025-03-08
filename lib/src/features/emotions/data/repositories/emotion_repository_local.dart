import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:illemo/src/features/authentication/domain/app_user.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local implementation of [EmotionRepository].
/// Depends on [sharedPreferencesProvider] for storing data.
class EmotionRepositoryLocal implements EmotionRepository {
  EmotionRepositoryLocal({
    required this.userID,
    required this.prefs,
  }) {
    _emotionLogTodayController = StreamController<EmotionLog?>.broadcast(
      onListen: _emitCurrentEmotionLogToday,
    );
  }

  /// The path used for storing emotion logs in shared preferences.
  final String _collectionPath = 'emotions';

  /// The shared preferences instance with cache.
  final SharedPreferencesWithCache prefs;
  @override
  final UserID userID;

  late final StreamController<EmotionLog?> _emotionLogTodayController;

  /// Emits the current emotion log for today to the stream.
  void _emitCurrentEmotionLogToday() {
    final key = '${_collectionPath}_${DateTime.now().weekday}';
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final EmotionLog emotionLog = EmotionLogModel.fromMap(jsonDecode(jsonString)).toEntity();
      if (DateUtils.isSameDay(emotionLog.date, DateTime.now())) {
        _emotionLogTodayController.add(emotionLog);
        log('Stream updated: Emotion log for today is $emotionLog');
        return;
      }
    }
    _emotionLogTodayController.add(null);
  }

  /// Adds a new emotion log to the local storage.
  ///
  /// [emotionLog] - The emotion log to be added.
  @override
  Future<EmotionLogID> addEmotionLog(EmotionLog emotionLog) async {
    final key = '${_collectionPath}_${emotionLog.date.weekday}';
    final EmotionLogModel emotionLogModel = EmotionLogModel.fromEntity(emotionLog);
    await prefs.setString(key, jsonEncode(emotionLogModel.toMap()));

    if (DateUtils.isSameDay(emotionLog.date, DateTime.now())) {
      // Updates today's log
      _emitCurrentEmotionLogToday();
    }
    return emotionLogModel.id;
  }

  /// Updates an existing emotion log in the local storage.
  ///
  /// [id] - The identifier of the emotion log to be updated.
  /// [emotionLog] - The updated emotion log.
  @override
  Future<void> updateEmotionLog(String id, EmotionLog emotionLog) async {
    /// id is the weekday (only stores up to 7 entries)
    final key = '${_collectionPath}_${emotionLog.date.weekday}';
    await prefs.setString(key, jsonEncode(EmotionLogModel.fromEntity(emotionLog, id: id).toMap()));

    if (DateUtils.isSameDay(emotionLog.date, DateTime.now())) {
      // Updates today's log
      _emitCurrentEmotionLogToday();
    }
  }

  /// Deletes an emotion log from the local storage.
  ///
  /// [id] - The identifier of the emotion log to be deleted.
  @override
  Future<void> deleteEmotionLog(String id) async {
    final key = '${_collectionPath}_$id';
    await prefs.remove(key);
    _emitCurrentEmotionLogToday(); // Updates today's log
  }

  /// Retrieves an emotion log by its identifier from the local storage.
  ///
  /// [id] - The identifier of the emotion log to be retrieved.
  /// Returns the emotion log if found, otherwise returns null.
  @override
  Future<EmotionLog?> getEmotionLog(String id) async {
    final key = '${_collectionPath}_$id';
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return EmotionLogModel.fromMap(jsonDecode(jsonString)).toEntity();
    }
    return null;
  }

  /// Retrieves today's emotion log from the local storage.
  ///
  /// Returns the emotion log if found and the date matches today, otherwise returns null.
  @override
  Stream<EmotionLog?> getEmotionLogToday() => _emotionLogTodayController.stream;

  /// Retrieves a stream of emotion logs within the specified date range from the local storage.
  ///
  /// [startDate] - The start date of the range (inclusive).
  /// [endDate] - The end date of the range (inclusive).
  /// Returns a stream of emotion logs that fall within the specified date range.
  @override
  Stream<List<EmotionLog>> getEmotionLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) async* {
    final keys = prefs.keys.where((key) => key.startsWith(_collectionPath));
    final logs = <EmotionLog>[];
    for (final key in keys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final emotionLog = EmotionLogModel.fromMap(jsonDecode(jsonString)).toEntity();
        if ((startDate == null || emotionLog.date.isAfter(startDate)) &&
            (endDate == null || emotionLog.date.isBefore(endDate))) {
          logs.add(emotionLog);
        }
      }
    }
    yield logs;
  }
}
