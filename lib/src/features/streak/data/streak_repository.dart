import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:illemo/src/features/authentication/domain/app_user.dart';
import 'package:illemo/src/features/streak/domain/streak.dart';
import 'package:illemo/src/features/streak/domain/streak_model.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'streak_repository.g.dart';

/// Firestore implementation of [StreakRepository].
/// Requires [UserID] userID.
class StreakRepository {
  StreakRepository({
    required this.userID,
    required this.prefs,
  });

  /// Returns the Firestore path for the emotions collection of a specific user.
  static String streaksPath(String uid) => 'users/$uid/streaks';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserID userID;
  final SharedPreferencesWithCache prefs;

  /// Creates a new streak in Firestore.
  Future<void> addStreak(Streak streak, {StreakID? id}) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id ?? streak.id);
    await docRef.set(StreakModel.fromEntity(streak).toMap());
  }

  /// Reads a streak from Firestore by its ID.
  Future<Streak?> getStreak(StreakID id) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return StreakModel.fromMap(docSnapshot.data()!).toEntity();
    }
    return null;
  }

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
  Future<void> updateStreak(Streak streak, {StreakID? id}) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id ?? streak.id);
    await docRef.update(StreakModel.fromEntity(streak).toMap());
  }

  /// Deletes a streak from Firestore by its ID.
  Future<void> deleteStreak(StreakID id) async {
    final docRef = _firestore.collection(streaksPath(userID)).doc(id);
    await docRef.delete();
  }
}

/// Provider for [StreakRepository].
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
