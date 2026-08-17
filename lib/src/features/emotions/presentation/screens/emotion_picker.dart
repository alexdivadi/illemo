import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_definition.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_confirmation.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_glyph.dart';
import 'package:illemo/src/features/emotions/service/emotion_entry_service.dart';
import 'package:uuid/uuid.dart';

enum _PickerStep { core, specific, deep }

class EmotionPickerScreen extends ConsumerStatefulWidget {
  const EmotionPickerScreen({super.key, this.entry, this.todaysEmotionLog});

  static const path = '/emotion/pick';
  static const title = 'Daily Reflection';
  final EmotionEntry? entry;
  final EmotionLog? todaysEmotionLog;

  @override
  ConsumerState<EmotionPickerScreen> createState() => _EmotionPickerScreenState();
}

class _EmotionPickerScreenState extends ConsumerState<EmotionPickerScreen> {
  _PickerStep _step = _PickerStep.core;
  EmotionDefinition? _core;
  EmotionDefinition? _specific;
  bool _saving = false;

  void _selectCore(EmotionDefinition emotion) => setState(() {
        _core = emotion;
        _specific = null;
        _step = _PickerStep.specific;
      });

  void _selectSpecific(EmotionDefinition emotion) => setState(() {
        _specific = emotion;
        _step = _PickerStep.deep;
      });

  void _back() {
    if (_step == _PickerStep.core) {
      context.pop();
      return;
    }
    setState(() {
      _step = _step == _PickerStep.deep ? _PickerStep.specific : _PickerStep.core;
      if (_step == _PickerStep.core) _core = null;
    });
  }

  Future<void> _save([EmotionDefinition? deep]) async {
    if (_saving || _core == null || _specific == null) return;
    setState(() => _saving = true);
    final entry = EmotionEntry(
      id: widget.entry?.id ?? const Uuid().v4(),
      coreId: _core!.id,
      specificId: _specific!.id,
      deepId: deep?.id,
      loggedAt: widget.entry?.loggedAt ?? DateTime.now(),
    );
    try {
      await ref.read(emotionEntryServiceProvider).save(entry);
      if (mounted) context.go(EmotionConfirmationScreen.path, extra: entry);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: _core?.core.flood(surface) ?? surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: switch (_step) {
                _PickerStep.core => _CorePicker(onBack: _back, onSelected: _selectCore),
                _PickerStep.specific =>
                  _SpecificPicker(core: _core!, onBack: _back, onSelected: _selectSpecific),
                _PickerStep.deep => _DeepPicker(
                    core: _core!,
                    specific: _specific!,
                    saving: _saving,
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

class _CorePicker extends StatelessWidget {
  const _CorePicker({required this.onBack, required this.onSelected});

  final VoidCallback onBack;
  final ValueChanged<EmotionDefinition> onSelected;

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey('core'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextButton.icon(
                  onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back')),
              const SizedBox(height: 10),
              Text('What are you feeling right now?',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Start broad.', style: Theme.of(context).textTheme.bodyLarge),
            ]),
          ),
          Expanded(
            child: Column(
              children: [
                for (final emotion in EmotionDefinition.cores)
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: emotion.label,
                      child: Material(
                        color: emotion.core.card,
                        child: InkWell(
                          onTap: () => onSelected(emotion),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child:
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(emotion.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: emotion.core.foreground)),
                              EmotionGlyph(emotion: emotion.core, size: 44),
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
  const _SpecificPicker({required this.core, required this.onBack, required this.onSelected});

  final EmotionDefinition core;
  final VoidCallback onBack;
  final ValueChanged<EmotionDefinition> onSelected;

  @override
  Widget build(BuildContext context) {
    final feelings = EmotionDefinition.childrenOf(core.id);
    final theme = Theme.of(context);
    final background = core.core.flood(theme.scaffoldBackgroundColor);
    final foreground = core.core.foregroundOn(background);
    return Padding(
      key: const ValueKey('specific'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back'))),
        Row(children: [
          EmotionGlyph(emotion: core.core, size: 40),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(core.label.toUpperCase(),
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
                    backgroundColor: core.core.soft(theme.colorScheme.surface),
                    foregroundColor: foreground,
                    side: BorderSide(color: core.core.border)),
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
      {required this.core,
      required this.specific,
      required this.saving,
      required this.onBack,
      required this.onSave});

  final EmotionDefinition core;
  final EmotionDefinition specific;
  final bool saving;
  final VoidCallback onBack;
  final ValueChanged<EmotionDefinition?> onSave;

  @override
  Widget build(BuildContext context) {
    final feelings = EmotionDefinition.childrenOf(specific.id);
    final theme = Theme.of(context);
    final background = core.core.flood(theme.scaffoldBackgroundColor);
    final foreground = core.core.foregroundOn(background);
    final buttonForeground = ThemeData.estimateBrightnessForColor(foreground) == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Padding(
      key: const ValueKey('deep'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('Back'))),
        Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Chip(label: Text(core.label)),
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
            itemBuilder: (context, index) => OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  backgroundColor: core.core.soft(theme.colorScheme.surface),
                  foregroundColor: foreground,
                  side: BorderSide(color: core.core.border)),
              onPressed: saving ? null : () => onSave(feelings[index]),
              icon: const Icon(Icons.circle_outlined, size: 12),
              label: Text(feelings[index].label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: foreground)),
            ),
          ),
        ),
        FilledButton(
          onPressed: saving ? null : () => onSave(null),
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
