import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:illemo/src/features/authentication/domain/app_user.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository_local.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/transformers.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'emotion_repository.g.dart';

/// Firestore implementation of [EmotionRepository].
/// Requires [UserID] userID.
class EmotionRepository {
  EmotionRepository({
    required this.userID,
  });

  /// Returns the Firestore path for the emotions collection of a specific user.
  static String emotionsPath(String uid) => 'users/$uid/emotions';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserID userID;

  /// Adds a new emotion log to Firestore.
  ///
  /// Converts the [EmotionLog] entity to a map using [EmotionLogModel] before adding it.
  Future<EmotionLogID> addEmotionLog(EmotionLog emotionLog) async {
    final EmotionLogModel emotionLogModel = EmotionLogModel.fromEntity(emotionLog);
    final docRef = _firestore.collection(emotionsPath(userID)).doc(emotionLogModel.id);
    await docRef.set(emotionLogModel.toMap());
    return emotionLogModel.id;
  }

  /// Updates an existing emotion log in Firestore.
  ///
  /// Converts the [EmotionLog] entity to a map using [EmotionLogModel] before updating it.
  Future<void> updateEmotionLog(EmotionLogID id, EmotionLog emotionLog) async {
    final docRef = _firestore.collection(emotionsPath(userID)).doc(id);
    final emotionLogModel = EmotionLogModel.fromEntity(emotionLog, id: id);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.update(emotionLogModel.toMap());
    } else {
      await docRef.set(emotionLogModel.toMap());
    }
    log("Updated emotion log with ID: $id");
  }

  /// Deletes an emotion log from Firestore by its document ID.
  Future<void> deleteEmotionLog(String id) async {
    await _firestore.collection(emotionsPath(userID)).doc(id).delete();
  }

  /// Retrieves an emotion log from Firestore by its document ID.
  ///
  /// Returns the [EmotionLog] entity if found, otherwise returns null.
  Future<EmotionLog?> getEmotionLog(String id) async {
    DocumentSnapshot doc = await _firestore.collection(emotionsPath(userID)).doc(id).get();
    if (doc.exists) {
      return EmotionLogModel.fromMap(doc.data() as Map<String, dynamic>).toEntity();
    }
    return null;
  }

  /// Retrieves today's emotion log from Firestore.
  ///
  /// Returns the [EmotionLog] entity if found, otherwise returns null.
  Stream<EmotionLog?> getEmotionLogToday() {
    return _firestore
        .collection(emotionsPath(userID))
        .where('date', isEqualTo: DateTime.now().toIso8601String().split('T').first)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return EmotionLogModel.fromMap(querySnapshot.docs.first.data()).toEntity();
      }
      return null;
    });
  }

  /// Streams a list of emotion logs from Firestore within an optional date range.
  ///
  /// If [startDate] is provided, only logs from that date onwards are included.
  /// If [endDate] is provided, only logs up to that date are included.
  Stream<List<EmotionLog>> getEmotionLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore.collection(emotionsPath(userID));

    if (startDate != null) {
      query =
          query.where('date', isGreaterThanOrEqualTo: startDate.toIso8601String().split('T').first);
    }

    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: endDate.toIso8601String().split('T').first);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => EmotionLogModel.fromMap(doc.data() as Map<String, dynamic>).toEntity())
          .toList();
    });
  }
}

/// Provider for [EmotionRepository].
/// Requires [UserID] userID.
@riverpod
EmotionRepository emotionRepository(Ref ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  if (currentUser == null) {
    throw AssertionError('User can\'t be null when fetching emotions');
  }

  if (currentUser.isAnonymous) {
    log('Using local storage for anonymous user');
    final SharedPreferencesWithCache prefs = ref.watch(sharedPreferencesProvider).requireValue;
    return EmotionRepositoryLocal(userID: currentUser.uid, prefs: prefs);
  }
  log('Using firestore for authenticated user');
  return EmotionRepository(userID: currentUser.uid);
}
