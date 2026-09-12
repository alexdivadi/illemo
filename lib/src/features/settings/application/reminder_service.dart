import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

part 'reminder_service.g.dart';

class ReminderService {
  ReminderService(this._notifications);

  static const _dailyId = 100;
  static const _streakId = 101;
  static const _payload = EmotionPickerScreen.path;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'emotion_reminders',
      'Emotion reminders',
      channelDescription: 'Daily emotion log and streak reminders',
      icon: 'ic_stat_illemo',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
    macOS: DarwinNotificationDetails(),
  );

  final FlutterLocalNotificationsPlugin _notifications;
  final _taps = StreamController<String>.broadcast();
  String? _launchPayload;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    if (!kIsWeb) {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    }

    await _notifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_illemo'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload case final String payload) _taps.add(payload);
      },
    );
    final launch = await _notifications.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _launchPayload = launch?.notificationResponse?.payload;
    }
  }

  Stream<String> get taps async* {
    if (_launchPayload case final String payload) {
      _launchPayload = null;
      yield payload;
    }
    yield* _taps.stream;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _notifications
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, sound: true, badge: true) ??
          true;
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return await _notifications
              .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, sound: true, badge: true) ??
          true;
    }
    return true;
  }

  Future<void> scheduleDaily(int minutesSinceMidnight) async {
    final hour = minutesSinceMidnight ~/ 60;
    final minute = minutesSinceMidnight % 60;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) scheduled = scheduled.add(const Duration(days: 1));
    await _notifications.zonedSchedule(
      id: _dailyId,
      title: 'How are you feeling?',
      body: 'Take a moment to complete today’s emotion log.',
      scheduledDate: scheduled,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: _payload,
    );
  }

  Future<void> cancelDaily() => _notifications.cancel(id: _dailyId);

  Future<void> scheduleStreak(DateTime incrementedAt) async {
    final local = tz.TZDateTime.from(incrementedAt, tz.local);
    final scheduled = tz.TZDateTime(tz.local, local.year, local.month, local.day + 1, 20);
    await _notifications.cancel(id: _streakId);
    if (!scheduled.isAfter(tz.TZDateTime.now(tz.local))) return;
    await _notifications.zonedSchedule(
      id: _streakId,
      title: 'Keep your streak going',
      body: 'Complete today’s emotion log before your streak ends.',
      scheduledDate: scheduled,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _payload,
    );
  }

  Future<void> cancelStreak() => _notifications.cancel(id: _streakId);

  void dispose() => _taps.close();
}

@Riverpod(keepAlive: true)
Future<ReminderService> reminderService(Ref ref) async {
  final service = ReminderService(FlutterLocalNotificationsPlugin());
  await service.initialize();
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
Stream<String> reminderTaps(Ref ref) async* {
  final service = await ref.watch(reminderServiceProvider.future);
  yield* service.taps;
}
