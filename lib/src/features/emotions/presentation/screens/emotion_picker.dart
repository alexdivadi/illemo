import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_entry_model.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_confirmation.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_glyph.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/logged_emotion_icons.dart';
import 'package:illemo/src/features/emotions/service/emotion_entry_service.dart';
import 'package:uuid/uuid.dart';

enum _PickerStep { category, specific, deep }

class EmotionPickerScreen extends ConsumerStatefulWidget {
  const EmotionPickerScreen({super.key, this.entry});

  static const path = '/emotion/pick';
  static const title = 'Daily Reflection';
  final EmotionEntry? entry;

  @override
  ConsumerState<EmotionPickerScreen> createState() => _EmotionPickerScreenState();
}

class _EmotionPickerScreenState extends ConsumerState<EmotionPickerScreen> {
  _PickerStep _step = _PickerStep.category;
  Category? _category;
  Emotion? _specific;
  bool _saving = false;

  void _selectCategory(Category category) => setState(() {
        _category = category;
        _specific = null;
        _step = _PickerStep.specific;
      });

  void _selectSpecific(Emotion emotion) => setState(() {
        _specific = emotion;
        _step = _PickerStep.deep;
      });

  void _back() {
    if (_step == _PickerStep.category) {
      context.pop();
      return;
    }
    setState(() {
      _step = _step == _PickerStep.deep ? _PickerStep.specific : _PickerStep.category;
      if (_step == _PickerStep.category) _category = null;
    });
  }

  Future<void> _save([Emotion? deep]) async {
    if (_saving || _category == null || _specific == null) return;
    setState(() => _saving = true);
    final entry = EmotionEntry(
      id: widget.entry?.id ?? const Uuid().v4(),
      emotionId: deep?.id ?? _specific!.id,
      loggedAt: widget.entry?.loggedAt ?? DateTime.now(),
    );
    try {
      await ref.read(emotionEntryServiceProvider).save(entry);
      if (mounted) {
        context.go(
          EmotionConfirmationScreen.path,
          extra: EmotionEntryModel.fromEntity(entry).toMap(),
        );
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).scaffoldBackgroundColor;
    final usedEmotionIds = ref
            .watch(emotionEntriesTodayProvider)
            .value
            ?.where((entry) => entry.id != widget.entry?.id)
            .map((entry) => entry.emotionId)
            .toSet() ??
        const <String>{};
    final loggedEntries = ref.watch(emotionEntriesTodayProvider).value ?? const <EmotionEntry>[];
    return Scaffold(
      backgroundColor: _category?.flood(surface) ?? surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: switch (_step) {
                _PickerStep.category => _CategoryPicker(
                    loggedEntries: loggedEntries, onBack: _back, onSelected: _selectCategory),
                _PickerStep.specific => _SpecificPicker(
                    category: _category!,
                    loggedEntries: loggedEntries,
                    onBack: _back,
                    onSelected: _selectSpecific),
                _PickerStep.deep => _DeepPicker(
                    category: _category!,
                    specific: _specific!,
                    loggedEntries: loggedEntries,
                    saving: _saving,
                    usedEmotionIds: usedEmotionIds,
                    onBack: _back,
                    onSave: _save),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.loggedEntries,
    required this.onBack,
    required this.onSelected,
  });

  final List<EmotionEntry> loggedEntries;
  final VoidCallback onBack;
  final ValueChanged<Category> onSelected;

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey('category'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextButton.icon(
                  onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back')),
              const SizedBox(height: 8),
              LoggedEmotionIcons(entries: loggedEntries),
              Text('What are you feeling right now?',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Start broad.', style: Theme.of(context).textTheme.bodyLarge),
            ]),
          ),
          Expanded(
            child: Column(
              children: [
                for (final category in Category.values)
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: Emotion.categoryRoot(category).label,
                      child: Material(
                        color: category.cardFor(
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).brightness,
                        ),
                        child: InkWell(
                          onTap: () => onSelected(category),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child:
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(Emotion.categoryRoot(category).label,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: category.foregroundOn(
                                          category.cardFor(
                                            Theme.of(context).colorScheme.surface,
                                            Theme.of(context).brightness,
                                          ),
                                        ),
                                      )),
                              EmotionGlyph(emotion: category, size: 44),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('No feeling is good or bad — they’re all welcome here.',
                textAlign: TextAlign.center),
          ),
        ],
      );
}

class _SpecificPicker extends StatelessWidget {
  const _SpecificPicker({
    required this.category,
    required this.loggedEntries,
    required this.onBack,
    required this.onSelected,
  });

  final Category category;
  final List<EmotionEntry> loggedEntries;
  final VoidCallback onBack;
  final ValueChanged<Emotion> onSelected;

  @override
  Widget build(BuildContext context) {
    final feelings = Emotion.specificsFor(category);
    final theme = Theme.of(context);
    final background = category.flood(theme.scaffoldBackgroundColor);
    final foreground = category.foregroundOn(background);
    return Padding(
      key: const ValueKey('specific'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back'))),
        LoggedEmotionIcons(entries: loggedEntries),
        Row(children: [
          EmotionGlyph(emotion: category, size: 40),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(Emotion.categoryRoot(category).label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(color: foreground)),
            Text('More specifically…',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: foreground)),
          ]),
        ]),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            itemCount: feelings.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 1.55,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              final feeling = feelings[index];
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: category.soft(theme.colorScheme.surface),
                    foregroundColor: foreground,
                    side: BorderSide(color: category.border)),
                onPressed: () => onSelected(feeling),
                child: Text(feeling.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: foreground)),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _DeepPicker extends StatelessWidget {
  const _DeepPicker(
      {required this.category,
      required this.specific,
      required this.loggedEntries,
      required this.saving,
      required this.usedEmotionIds,
      required this.onBack,
      required this.onSave});

  final Category category;
  final Emotion specific;
  final List<EmotionEntry> loggedEntries;
  final bool saving;
  final Set<String> usedEmotionIds;
  final VoidCallback onBack;
  final ValueChanged<Emotion?> onSave;

  @override
  Widget build(BuildContext context) {
    final feelings = Emotion.childrenOf(specific.id);
    final theme = Theme.of(context);
    final background = category.flood(theme.scaffoldBackgroundColor);
    final foreground = category.foregroundOn(background);
    final buttonForeground = ThemeData.estimateBrightnessForColor(foreground) == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Padding(
      key: const ValueKey('deep'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back'))),
        LoggedEmotionIcons(entries: loggedEntries),
        Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Chip(label: Text(Emotion.categoryRoot(category).label)),
          const Icon(Icons.chevron_right, size: 18),
          Chip(label: Text(specific.label)),
        ]),
        const SizedBox(height: 24),
        Text('Even more precisely?',
            style: theme.textTheme.headlineSmall?.copyWith(color: foreground)),
        const SizedBox(height: 6),
        Text('Optional — pick one, or save as-is below.', style: TextStyle(color: foreground)),
        const SizedBox(height: 26),
        Expanded(
          child: ListView.separated(
            itemCount: feelings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final feeling = feelings[index];
              final disabled = saving || usedEmotionIds.contains(feeling.id);
              return OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                    backgroundColor: category.soft(theme.colorScheme.surface),
                    foregroundColor: foreground,
                    disabledForegroundColor: theme.disabledColor,
                    side: BorderSide(color: disabled ? theme.disabledColor : category.border)),
                onPressed: disabled ? null : () => onSave(feeling),
                icon: const Icon(Icons.circle_outlined, size: 12),
                label: Text(feeling.label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: disabled ? theme.disabledColor : foreground)),
              );
            },
          ),
        ),
        FilledButton(
          onPressed: saving || usedEmotionIds.contains(specific.id) ? null : () => onSave(null),
          style: FilledButton.styleFrom(
              backgroundColor: foreground,
              foregroundColor: buttonForeground,
              padding: const EdgeInsets.all(17)),
          child: Text(saving ? 'Saving…' : 'Save as “${specific.label}”'),
        ),
      ]),
    );
  }
}
