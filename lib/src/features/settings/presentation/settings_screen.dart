import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/features/settings/application/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const path = '/settings';
  static const title = 'Settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: settings.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, _) => Center(child: Text('Couldn’t load settings. $error')),
            data: (settings) => ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: settings.darkMode,
                  onChanged: ref.read(settingsControllerProvider.notifier).setDarkMode,
                ),
                const Divider(),
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('Daily reminder'),
                  subtitle: Text(
                    'Remind me every day at ${_formatTime(context, settings.dailyReminderMinutes)}',
                  ),
                  value: settings.dailyReminder,
                  onChanged: (enabled) => _toggle(
                    context,
                    () => ref.read(settingsControllerProvider.notifier).setDailyReminder(enabled),
                  ),
                ),
                ListTile(
                  enabled: settings.dailyReminder,
                  leading: const Icon(Icons.schedule),
                  title: const Text('Daily reminder time'),
                  trailing: Text(_formatTime(context, settings.dailyReminderMinutes)),
                  onTap: () async {
                    final selected = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: settings.dailyReminderMinutes ~/ 60,
                        minute: settings.dailyReminderMinutes % 60,
                      ),
                    );
                    if (selected != null) {
                      await ref
                          .read(settingsControllerProvider.notifier)
                          .setDailyReminderTime(selected);
                    }
                  },
                ),
                const Divider(),
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.local_fire_department_outlined),
                  title: const Text('Streak reminder'),
                  subtitle: const Text(
                    'Remind me at 8:00 PM when today’s log is still incomplete',
                  ),
                  value: settings.streakReminder,
                  onChanged: (enabled) => _toggle(
                    context,
                    () => ref.read(settingsControllerProvider.notifier).setStreakReminder(enabled),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, int minutes) =>
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).format(context);

  Future<void> _toggle(BuildContext context, Future<bool> Function() update) async {
    try {
      if (!await update() && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification permission is required for reminders.')),
        );
      }
    } on Object catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }
}
