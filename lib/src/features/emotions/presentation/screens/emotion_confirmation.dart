import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_definition.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_entry_repository.dart';
import 'package:illemo/src/features/emotions/presentation/screens/dashboard.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_glyph.dart';

class EmotionConfirmationScreen extends ConsumerWidget {
  const EmotionConfirmationScreen({super.key, required this.entry});

  static const path = '/emotion/confirmation';
  final EmotionEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final core = entry.core;
    final theme = Theme.of(context);
    final background = core.core.flood(theme.scaffoldBackgroundColor);
    final foreground = core.core.foregroundOn(background);
    final buttonForeground = ThemeData.estimateBrightnessForColor(foreground) == Brightness.dark
        ? Colors.white
        : Colors.black;
    final canAdd = ref.watch(emotionEntriesTodayProvider).value?.length != 3;
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmotionGlyph(emotion: core.core, size: 80),
                  const SizedBox(height: 20),
                  Text(entry.label,
                      style: theme.textTheme.headlineLarge?.copyWith(color: foreground),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text('Logged as ${core.label} → ${entry.specific.label}.',
                      style: TextStyle(color: foreground), textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: core.core.soft(theme.colorScheme.surface),
                        border: Border.all(color: core.core.border),
                        borderRadius: BorderRadius.circular(22)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('NOTED ✓',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: foreground, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                      const SizedBox(height: 8),
                      Text(
                          'All feelings are welcome here. Naming what you feel is a kind of honesty — keep going.',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: foreground, height: 1.5)),
                    ]),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () => context.go(DashboardScreen.path),
                          style: FilledButton.styleFrom(
                              backgroundColor: foreground,
                              foregroundColor: buttonForeground,
                              padding: const EdgeInsets.all(17)),
                          child: const Text('Back to today’s log'))),
                  if (canAdd) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () => context.go(EmotionPickerScreen.path),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: foreground,
                                side: BorderSide(color: core.core.border),
                                padding: const EdgeInsets.all(17)),
                            child: const Text('Add another feeling'))),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
