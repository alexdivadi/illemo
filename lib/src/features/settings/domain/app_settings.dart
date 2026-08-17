class AppSettings {
  const AppSettings({
    this.darkMode = false,
    this.dailyReminder = false,
    this.dailyReminderMinutes = 8 * 60,
    this.streakReminder = false,
  });

  final bool darkMode;
  final bool dailyReminder;
  final int dailyReminderMinutes;
  final bool streakReminder;

  AppSettings copyWith({
    bool? darkMode,
    bool? dailyReminder,
    int? dailyReminderMinutes,
    bool? streakReminder,
  }) =>
      AppSettings(
        darkMode: darkMode ?? this.darkMode,
        dailyReminder: dailyReminder ?? this.dailyReminder,
        dailyReminderMinutes: dailyReminderMinutes ?? this.dailyReminderMinutes,
        streakReminder: streakReminder ?? this.streakReminder,
      );
}
