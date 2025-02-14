import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:illemo/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:illemo/src/features/authentication/domain/app_user.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_log_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_repository.g.dart';

/// Firestore implementation of [EmotionRepository].
/// Depends on [firebaseAuthProvider] for user id.
@Riverpod(keepAlive: true)
class EmotionRepository extends _$EmotionRepository {
  EmotionRepository();

  /// Returns the Firestore path for the emotions collection of a specific user.
  static String emotionsPath(String uid) => 'users/$uid/emotions';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final UserID _userID;

  /// Initializes the repository by getting the current user and fetching today's emotion log (which may be).
  ///
  /// Throws an [AssertionError] if the user is null.
  @override
  Future<EmotionLog?> build() async {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    if (user == null) {
      throw AssertionError('User can\'t be null');
    }
    _userID = user.uid;
    return getEmotionLogToday();
  }

  /// Adds a new emotion log to Firestore.
  ///
  /// Converts the [EmotionLog] entity to a map using [EmotionLogModel] before adding it.
  Future<void> addEmotionLog(EmotionLog emotionLog) async {
    await _firestore
        .collection(emotionsPath(_userID))
        .add(EmotionLogModel.fromEntity(emotionLog).toMap());
  }

  /// Updates an existing emotion log in Firestore.
  ///
  /// Converts the [EmotionLog] entity to a map using [EmotionLogModel] before updating it.
  Future<void> updateEmotionLog(String id, EmotionLog emotionLog) async {
    await _firestore
        .collection(emotionsPath(_userID))
        .doc(id)
        .update(EmotionLogModel.fromEntity(emotionLog, id: id).toMap());
  }

  /// Deletes an emotion log from Firestore by its document ID.
  Future<void> deleteEmotionLog(String id) async {
    await _firestore.collection(emotionsPath(_userID)).doc(id).delete();
  }

  /// Retrieves an emotion log from Firestore by its document ID.
  ///
  /// Returns the [EmotionLog] entity if found, otherwise returns null.
  Future<EmotionLog?> getEmotionLog(String id) async {
    DocumentSnapshot doc = await _firestore.collection(emotionsPath(_userID)).doc(id).get();
    if (doc.exists) {
      return EmotionLogModel.fromMap(doc.data() as Map<String, dynamic>).toEntity();
    }
    return null;
  }

  /// Retrieves today's emotion log from Firestore.
  ///
  /// Returns the [EmotionLog] entity if found, otherwise returns null.
  Future<EmotionLog?> getEmotionLogToday() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(emotionsPath(_userID))
        .where('date', isEqualTo: DateTime.now().toIso8601String().split('T').first)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return EmotionLogModel.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>)
          .toEntity();
    }
    return null;
  }

  /// Streams a list of emotion logs from Firestore within an optional date range.
  ///
  /// If [startDate] is provided, only logs from that date onwards are included.
  /// If [endDate] is provided, only logs up to that date are included.
  Stream<List<EmotionLog>> getEmotionLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore.collection(emotionsPath(_userID));

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
