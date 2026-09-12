# Illemo Architecture

Illemo is an offline-first Flutter application. Core journaling must work without an account or network connection. SQLite is the source of truth; authentication and cloud synchronization are optional enhancements.

## Principles

- Prefer small, feature-first code over speculative abstractions.
- Keep business rules independent of Flutter, Firebase, SQLite, and navigation.
- Write locally first. The UI reads local state and never waits for cloud persistence.
- Preserve stable emotion/category IDs because they are persisted data.
- Add a layer only when it owns a real responsibility.

## Project structure

```text
lib/
  main.dart
  src/
    app.dart
    theme/
      app_theme.dart
      app_colors.dart
    routing/
    localization/
    common_widgets/
    constants/
    utils/
    features/
      <feature>/
        presentation/
        application/
        domain/
        data/
```

Features may omit an empty layer. Do not create placeholder folders, interfaces, or implementations.

## Layers and dependencies

Dependencies point inward:

```text
presentation -> application -> domain
                       ^          ^
                       |          |
                      data -------+
```

### Presentation

Screens, reusable feature widgets, and presentation controllers. Widgets render state and forward user intent; they do not contain SQL, Firebase calls, serialization, or cross-feature business rules.

### Application

Riverpod providers and services that coordinate use cases, repositories, and state. Application code decides what operation happens, while repositories decide how data is stored.

### Domain

Entities, value objects, enums, and business rules written in plain Dart. Domain code must not depend on Flutter widgets, Riverpod, GoRouter, Firebase, or SQLite. Existing persisted numeric emotion and category IDs are immutable compatibility contracts.

### Data

Repository implementations, SQLite tables and mapping, Firebase synchronization, Remote Config, and serialization. Data models translate between storage records and domain entities.

Repository contracts belong in the domain layer when multiple implementations are required. Do not introduce an interface for a single implementation merely for architectural symmetry.

## Offline-first persistence

SQLite, accessed with `sqflite`, is the authoritative store for emotion logs, streak data derived or cached locally, and sync metadata. SharedPreferences is limited to small preferences such as onboarding completion and settings; it is not an application database.

Local writes follow this flow:

1. Validate the domain operation.
2. Commit it to SQLite in a transaction.
3. Refresh/invalidate the relevant Riverpod state.
4. If cloud sync is enabled, enqueue the record for background synchronization.

Every locally created record uses a stable UUID. Mutable synchronized records include an updated timestamp and sync state. Signing in must never replace or delete local data. Firestore is an optional backup/sync target, not the source used directly by screens.

Database schema changes require explicit, tested migrations. Preserve existing stored IDs and migrate the current SharedPreferences emotion records before removing that storage path.

## Riverpod

Use `flutter_riverpod`, `riverpod_annotation`, and generated providers:

```dart
part 'example.g.dart';

@riverpod
Future<Value> example(Ref ref) async => ref.watch(repositoryProvider).load();
```

- Prefer annotated providers over handwritten provider declarations.
- Use `@Riverpod(keepAlive: true)` only for long-lived infrastructure whose lifetime requires it.
- Keep providers close to the feature/layer they coordinate.
- Use provider overrides for tests.
- Never edit `*.g.dart` files manually. Generate them with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Theme

All application-wide theme configuration belongs under `lib/src/theme/`, not in `app.dart` or individual screens.

- `app_theme.dart` builds and exports the app `ThemeData`.
- `app_colors.dart` contains the small semantic palette shared across features.
- `app.dart` selects the theme and configures `MaterialApp.router`.
- Use `Theme.of(context).colorScheme`, text themes, and component themes in widgets.
- Category/emotion-specific colors may remain with their domain presentation metadata when they are taxonomy-specific rather than general design tokens.
- Keep typography based on Material defaults unless a product requirement explicitly introduces assets or a font dependency.
- Define reusable button, card, chip, input, navigation, and app-bar styling in `ThemeData` component themes.
- Preserve accessible contrast, text scaling, minimum touch targets, and platform brightness behavior.

Do not create a custom design-system framework. Add a theme extension only when Material's existing theme APIs cannot express a reused semantic value.

## Routing

GoRouter is the only navigation system. Routes and redirects live in `lib/src/routing/` and the router is exposed through an annotated Riverpod provider.

- Keep route paths as constants on their destination screens or in the established route definitions.
- Pass typed domain values where practical and validate untyped `extra` payloads at route boundaries.
- Core routes—onboarding, dashboard, emotion picker, and calendar—must not require authentication.
- Authentication/profile routes enable optional backup and synchronization.
- Preserve deep links, back behavior, and the stateful shell navigation contract.

## Common widgets

`lib/src/common_widgets/` contains widgets reused by multiple features. A widget used by only one feature stays under that feature's `presentation/widgets/` directory.

Common widgets should be small, theme-aware, accessible, and free of feature-specific repository access. Prefer Material widgets and composition before creating wrappers.

## Constants and utilities

- `constants/` contains stable, dependency-free values such as spacing and breakpoints.
- `utils/` contains small stateless helpers or platform adapters used across features.
- Feature-specific constants and helpers remain inside the feature.
- Do not use either folder as a dumping ground for business rules, services, or mutable global state.

## Localization

Use Flutter's generated localization support with ARB files under `lib/l10n/` and `flutter gen-l10n`. User-visible strings must come from generated `AppLocalizations` once localization is configured.

- Use descriptive message keys, placeholders, plurals, and locale-aware date/number formatting.
- Do not concatenate translated fragments into sentences.
- Remote Config may supply product-managed copy such as the daily reflection prompt, but every remote value must have a local default.
- The existing `.hardcoded` marker is transitional and should not be added to new user-visible copy.

## Testing and verification

- Domain tests cover business rules and persistence conversions.
- Repository tests cover SQLite queries, constraints, and migrations.
- Provider tests use overrides and cover offline behavior.
- Widget tests cover critical interactions, accessibility, and routing payloads.

Before handing off a change, run:

```sh
dart format .
flutter analyze
flutter test
```

Review the diff for accidental changes to IDs, routes, generated files, persistence schemas, and unrelated features.
