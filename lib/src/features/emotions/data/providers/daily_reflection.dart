import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const dailyReflectionKey = 'daily_reflection_prompt';
const dailyReflectionDefault = 'How are you feeling today?';

final dailyReflectionProvider = FutureProvider<String>((ref) async {
  final config = FirebaseRemoteConfig.instance;
  await config.setDefaults(const {dailyReflectionKey: dailyReflectionDefault});
  try {
    await config.fetchAndActivate();
  } catch (_) {
    // The configured default remains available offline.
  }
  return config.getString(dailyReflectionKey);
});
