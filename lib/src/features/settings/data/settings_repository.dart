import 'package:illemo/src/features/settings/domain/app_settings.dart';
import 'package:illemo/src/utils/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  const SettingsRepository(this.preferences);

  static const _darkModeKey = 'settings.darkMode';
  static const _dailyReminderKey = 'settings.dailyReminder';
  static const _dailyReminderMinutesKey = 'settings.dailyReminderMinutes';
  static const _streakReminderKey = 'settings.streakReminder';

  final SharedPreferencesWithCache preferences;

  AppSettings load() => AppSettings(
        darkMode: preferences.getBool(_darkModeKey) ?? false,
        dailyReminder: preferences.getBool(_dailyReminderKey) ?? false,
        dailyReminderMinutes: preferences.getInt(_dailyReminderMinutesKey) ?? 8 * 60,
        streakReminder: preferences.getBool(_streakReminderKey) ?? false,
      );

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      preferences.setBool(_darkModeKey, settings.darkMode),
      preferences.setBool(_dailyReminderKey, settings.dailyReminder),
      preferences.setInt(_dailyReminderMinutesKey, settings.dailyReminderMinutes),
      preferences.setBool(_streakReminderKey, settings.streakReminder),
    ]);
  }
}

@Riverpod(keepAlive: true)
Future<SettingsRepository> settingsRepository(Ref ref) async =>
    SettingsRepository(await ref.watch(sharedPreferencesProvider.future));
