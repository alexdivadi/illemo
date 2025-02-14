import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'emotion_repository_local.g.dart';

/// Local implementation of [EmotionRepository].
/// Depends on [sharedPreferencesProvider] for storing data.
@Riverpod(keepAlive: true)
class EmotionRepositoryLocal extends _$EmotionRepositoryLocal implements EmotionRepository {
  EmotionRepositoryLocal();

  final String _collectionPath = 'emotions';
  late final SharedPreferencesWithCache prefs;

  @override
  Future<EmotionLog?> build() async {
    prefs = ref.watch(sharedPreferencesProvider).requireValue;
    return getEmotionLogToday();
  }

  @override
  Future<void> addEmotionLog(EmotionLog emotionLog) async {
    final key = '${_collectionPath}_${emotionLog.date.weekday}';
    await prefs.setString(key, jsonEncode(EmotionLogModel.fromEntity(emotionLog).toMap()));
  }

  @override
  Future<void> updateEmotionLog(String id, EmotionLog emotionLog) async {
    /// id is the weekday (only stores up to 7 entries)
    final key = '${_collectionPath}_${emotionLog.date.weekday}';
    await prefs.setString(key, jsonEncode(EmotionLogModel.fromEntity(emotionLog, id: id).toMap()));
  }

  @override
  Future<void> deleteEmotionLog(String id) async {
    final key = '${_collectionPath}_$id';
    await prefs.remove(key);
  }

  @override
  Future<EmotionLog?> getEmotionLog(String id) async {
    final key = '${_collectionPath}_$id';
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return EmotionLogModel.fromMap(jsonDecode(jsonString)).toEntity();
    }
    return null;
  }

  @override
  Future<EmotionLog?> getEmotionLogToday() async {
    final key = '${_collectionPath}_${DateTime.now().weekday}';
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final EmotionLog emotionLog = EmotionLogModel.fromMap(jsonDecode(jsonString)).toEntity();
      if (DateUtils.isSameDay(emotionLog.date, DateTime.now())) {
        return emotionLog;
      }
    }
    return null;
  }

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
