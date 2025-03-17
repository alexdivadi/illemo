import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:illemo/src/features/authentication/domain/app_user.dart';
import 'package:illemo/src/features/streak/data/streak_repository.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:illemo/src/features/streak/domain/streak_model.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'streak_repository_local.g.dart';

/// A repository for handling a user's [Streak] data.
///
/// [userID] is the ID of the user for whom the streaks are managed.
/// [prefs] is the shared preferences with cache.
class StreakRepositoryLocal implements StreakRepository {
  StreakRepositoryLocal({
    required this.userID,
    required this.prefs,
  });

  /// Returns the Firestore path for the streaks collection of a specific user.
  ///
  /// [uid] is the user ID for which the path is generated.
  static String streaksPath(String uid) => 'users/$uid/streaks';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  final UserID userID;
  @override
  final SharedPreferencesWithCache prefs;

  /// Creates a new streak in Firestore.
  ///
  /// [streak] is the streak entity to be added.
  /// [id] is an optional parameter for the streak ID. If not provided, the ID from the streak entity will be used.
  @override
  Future<void> addStreak(Streak streak, {StreakID? id}) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id ?? streak.id);
    await docRef.set(StreakModel.fromEntity(streak, id: id).toMap());
    log('Added new streak: $streak, $id');
  }

  /// Reads a streak from Firestore by its ID.
  ///
  /// [id] is the ID of the streak to be fetched.
  /// Returns a [Streak] entity if found, otherwise returns null.
  @override
  Future<Streak?> getStreak(StreakID id) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return StreakModel.fromMap(docSnapshot.data()!).toEntity();
    }
    return null;
  }

  /// Returns a stream of a streak from Firestore by its ID.
  ///
  /// [id] is the ID of the streak to be fetched.
  /// Returns a stream of [Streak] entity if found, otherwise returns null.
  @override
  Stream<Streak?> getStreakStream(StreakID id) {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id);
    return docRef.snapshots().map((docSnapshot) {
      if (docSnapshot.exists) {
        return StreakModel.fromMap(docSnapshot.data()!).toEntity();
      }
      return null;
    });
  }

  /// Updates an existing streak in Firestore.
  ///
  /// [streak] is the streak entity to be updated.
  /// [id] is an optional parameter for the streak ID. If not provided, the ID from the streak entity will be used.
  @override
  Future<void> updateStreak(Streak streak, {StreakID? id}) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id ?? streak.id);
    await docRef.update(StreakModel.fromEntity(streak, id: id).toMap());
    log('Updated streak: $streak');
  }

  /// Deletes a streak from Firestore by its ID.
  ///
  /// [id] is the ID of the streak to be deleted.
  @override
  Future<void> deleteStreak(StreakID id) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id);
    await docRef.delete();
    log('Deleted streak: $id');
  }
}

/// Provider for [StreakRepository].
///
/// Requires [UserID] userID.
@riverpod
StreakRepository streakRepository(Ref ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  if (currentUser == null) {
    throw AssertionError('User can\'t be null when fetching emotions');
  }

  final SharedPreferencesWithCache prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return StreakRepository(userID: currentUser.uid, prefs: prefs);
}
