import 'dart:async';

import 'package:flutter/material.dart';
import 'package:illemo/src/features/settings/application/reminder_service.dart';
import 'package:illemo/src/features/settings/data/settings_repository.dart';
import 'package:illemo/src/features/settings/domain/app_settings.dart';
import 'package:illemo/src/features/streak/service/streak_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() async => (await ref.watch(settingsRepositoryProvider.future)).load();

  Future<void> setDarkMode(bool enabled) async {
    await _save(state.requireValue.copyWith(darkMode: enabled));
  }

  Future<void> requestNotificationPermissionOnce() async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    if (repository.wasNotificationPermissionRequested()) return;
    final enabled = await (await ref.read(reminderServiceProvider.future)).requestPermission();
    final next = state.requireValue.copyWith(
      dailyReminder: enabled,
      streakReminder: enabled,
    );
    await _save(next);
    await repository.setNotificationPermissionRequested();
    if (enabled) {
      await (await ref.read(reminderServiceProvider.future))
          .scheduleDaily(next.dailyReminderMinutes);
    }
  }

  Future<bool> setDailyReminder(bool enabled) async {
    final reminders = await ref.read(reminderServiceProvider.future);
    if (enabled && !await reminders.requestPermission()) return false;
    final next = state.requireValue.copyWith(dailyReminder: enabled);
    if (enabled) {
      await reminders.scheduleDaily(next.dailyReminderMinutes);
    } else {
      await reminders.cancelDaily();
    }
    await _save(next);
    return true;
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    final next = state.requireValue.copyWith(
      dailyReminderMinutes: time.hour * 60 + time.minute,
    );
    if (next.dailyReminder) {
      await (await ref.read(reminderServiceProvider.future))
          .scheduleDaily(next.dailyReminderMinutes);
    }
    await _save(next);
  }

  Future<bool> setStreakReminder(bool enabled) async {
    final reminders = await ref.read(reminderServiceProvider.future);
    if (enabled && !await reminders.requestPermission()) return false;
    if (enabled) {
      final streak = await ref.read(streakProvider.future);
      if (streak.count > 0) await reminders.scheduleStreak(streak.lastUpdated);
    } else {
      await reminders.cancelStreak();
    }
    await _save(state.requireValue.copyWith(streakReminder: enabled));
    return true;
  }

  Future<void> _save(AppSettings settings) async {
    state = AsyncData(settings);
    await (await ref.read(settingsRepositoryProvider.future)).save(settings);
  }
}
