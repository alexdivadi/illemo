---
name: flutter-use-riverpod
description: Implement, refactor, debug, and test Flutter state management with Riverpod 3 using riverpod_annotation and generated providers. Use when adding or changing providers, Notifiers, AsyncNotifiers, provider dependencies, parameterized providers, lifecycle cleanup, invalidation, overrides, ProviderScope setup, Consumer widgets, or generated Riverpod files in this repository.
---

# Use Riverpod in Flutter

Read `AGENTS.md`, `ARCHITECTURE.md`, `pubspec.yaml`, and nearby providers before editing. Follow this repository's feature-first layers and existing Riverpod 3 versions.

## Choose the Smallest Provider

- Use an annotated function for immutable synchronous, `Future`, or `Stream` state.
- Use an annotated class extending the generated `_$Name` base only when callers need public mutation methods.
- Let the function's return type select the generated provider kind.
- Pass provider parameters directly to annotated functions/classes instead of manually declaring families.
- Keep ephemeral widget state such as animation, text-field, and temporary selection state in the widget unless it must be shared or preserved.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emotion_today.g.dart';

@riverpod
Stream<EmotionLog?> emotionToday(Ref ref) {
  return ref.watch(emotionRepositoryProvider).watchToday();
}
```

For mutable async state:

```dart
@riverpod
class Editor extends _$Editor {
  @override
  Future<Model> build(String id) => ref.watch(repositoryProvider).get(id);

  Future<void> save(Model value) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(repositoryProvider).save(value);
      return value;
    });
  }
}
```

Do not put initialization logic in a Notifier constructor; use `build`.

## Use Ref Deliberately

- Use `ref.watch` for declarative dependencies that should rebuild or recompute.
- Use `ref.read` inside event handlers and mutation methods for one-time access.
- Use `ref.listen` for side effects caused by state changes, not for deriving values.
- Use `ref.invalidate` after a mutation when the simplest correct refresh is recomputation.
- Register cleanup for controllers, subscriptions, timers, and clients with `ref.onDispose`.
- Prefer derived providers over copying provider state into another controller.

Generated providers are auto-disposed by default. Add `@Riverpod(keepAlive: true)` only for infrastructure or caches that must survive without listeners; document the lifetime reason in code when it is not obvious.

## Keep Layer Boundaries

- Provide repositories and infrastructure through providers; do not access SDK singletons from screens.
- Put repository providers in the data layer and use-case/controller providers in the application or presentation layer.
- Keep domain entities independent of Riverpod.
- Keep local SQLite as the source of truth; providers expose and coordinate repository state rather than becoming a second persistence layer.
- Make network-backed providers tolerate offline operation when the feature has a local fallback.

## Consume State in Widgets

- Wrap the app once with `ProviderScope`.
- Use `ConsumerWidget`/`ConsumerStatefulWidget` only when a widget reads providers.
- Watch providers during `build`; read notifiers from callbacks.
- Render `AsyncValue` loading, error, and data states explicitly. Preserve useful cached/local data during refresh when the existing UX supports it.
- Use `.select` only after identifying an unnecessary rebuild; do not optimize speculatively.

## Generate Code

Every annotated source needs a matching `part '<file>.g.dart';` declaration. Never create or edit `*.g.dart` by hand.

After changing annotations, signatures, or Notifiers, run:

```sh
dart run build_runner build
```

Review generated diffs and exclude unrelated churn. Then run:

```sh
dart format <changed-files>
flutter analyze
flutter test <focused-tests>
```

## Test Providers

- Create a fresh `ProviderContainer.test()` per unit test and register cleanup.
- Override repositories or infrastructure at provider boundaries.
- Use `ProviderScope(overrides: [...])` for widget tests.
- Read `.future` for `Future` providers and listen to auto-disposed providers when a test needs them to remain alive.
- Test observable state and side effects, not generated implementation details.

## Avoid

- Do not use Riverpod as a service locator from arbitrary domain objects.
- Do not call `ref.watch` from button callbacks; use `ref.read`.
- Do not trigger writes, navigation, dialogs, or analytics as provider initialization side effects.
- Do not retain `Ref` beyond its provider/widget lifecycle.
- Do not add `keepAlive`, manual caching, or a Notifier when a generated functional provider already works.
- Do not adopt experimental Riverpod persistence or mutation APIs unless the task explicitly requests them; this repository already owns SQLite persistence and stable mutation flows.

When behavior or syntax is version-sensitive, verify against the [official Riverpod documentation](https://riverpod.dev/docs/introduction/getting_started) before coding.
