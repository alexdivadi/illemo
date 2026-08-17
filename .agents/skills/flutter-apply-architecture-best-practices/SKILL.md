---
name: flutter-apply-architecture-best-practices
description: Apply and review this repository's feature-first Flutter architecture, including data/domain/presentation layers, Signals controllers, Injectable + GetIt dependency injection, offline-first repositories, core service abstractions, go_router navigation, localization, and the shared design system. Use when creating, restructuring, or reviewing Flutter features, screens, controllers, repositories, data sources, services, routes, or dependency registrations.
---

# Apply Flutter Architecture Best Practices

Treat `ARCHITECTURE.md` as the source of truth. Inspect nearby features before editing so new code follows established repository patterns.

## Organize by Feature

Place feature code under:

```text
lib/features/<feature>/
├── data/
├── domain/
└── presentation/
```

Use `lib/core/` only for genuinely cross-feature code:

```text
lib/core/
├── di/        # Injectable + GetIt setup
├── models/    # Shared model types
├── services/  # Provider abstractions and shared controller bases
└── ui/        # Design tokens, theme, and shared widgets
```

Do not introduce top-level `lib/data`, `lib/domain`, or `lib/ui/features` directories.

## Respect Layer Boundaries

- Keep business entities in `domain/`.
- Keep repositories and data sources in `data/`.
- Keep controllers, screens, and feature widgets in `presentation/`.
- Let screens render state and forward user intent. Put fetching, mutations, coordination, and side effects in controllers.
- Depend on abstractions at provider boundaries. Do not access SDK clients directly outside their concrete service implementations.

## Manage State with Signals

- Implement the controller-screen pattern; do not introduce `ChangeNotifier` ViewModels.
- Expose mutable state with `signal` and derived state with `computed`.
- Use `effect` for side effects and dispose effects with the controller lifecycle.
- Use `computedFrom` for asynchronous flows returning `Future`; treat its value as async state.
- Prefer separate signals for independent values. Use one async state object when loading, error, and data belong to the same operation.
- Read signals in screens and widgets through `signals_flutter` watch widgets.

## Use Injectable and GetIt

- Register repository and service implementations with `@LazySingleton(as: Interface)`.
- Register controllers with `@injectable`; controllers are factories by default.
- Provide external SDK dependencies through `@module` getters.
- Initialize dependency injection through `configureDependencies()` in `lib/core/di/di.dart`.
- Use constructor injection. Do not add an alternative DI container or manually construct dependency graphs in screens.

After changing Injectable registrations, regenerate the generated DI code with the repository's build-runner workflow.

## Build Data and Repository Layers

- Model business entities in the domain layer; these may mirror database row shapes when appropriate.
- Put CRUD orchestration in repositories.
- Reuse shared query models such as `ListQuery` for filtering, sorting, and pagination.
- Inject `DatabaseService`, `FunctionsService`, and other core abstractions rather than Supabase or Firebase SDK clients.
- Use `AnalyticsService`, `ErrorTrackingService`, and `NotificationsService` for their respective provider operations.

For offline-capable features, read and follow `docs/offline-first-repositories.md`, then use:

```text
data/
├── local/<feature>_local_data_source.dart
├── remote/<feature>_remote_data_source.dart
└── <feature>_repository.dart
```

- Stream reads local-first.
- Apply writes locally first and queue deferred synchronization in the outbox.
- Trigger explicit synchronization through `SyncCoordinator` on app start, resume, and manual refresh.
- Keep critical side-effect operations such as checkout and payments online-only.

## Follow App-Wide Conventions

- Use `go_router` for navigation.
- Define `static const path` on each screen and reference that constant in routes, redirects, and navigation calls. Do not duplicate route strings.
- Use `easy_localization` with translations in `assets/translations/`; support `en` and `es`.
- Reuse tokens, `FpTheme.light()`, and components exported by `lib/core/ui/ui.dart` before creating new styling primitives.
- Prefer widget classes over functions returning widgets.
- Prefer a separate file for a new public widget when applicable.
- Prefer absolute imports for non-sibling files.
- Prefer Dart dot shorthands where supported.
- Use `withAlpha` instead of deprecated `withOpacity`.

## Implementation Workflow

1. Inspect `ARCHITECTURE.md`, the target feature, DI setup, and analogous implementations.
2. Define or update domain models and repository contracts as needed.
3. Implement data sources and repository orchestration, applying the offline-first standard when applicable.
4. Register services, repositories, and controllers with Injectable.
5. Implement a Signals controller for state, async work, mutations, and side effects.
6. Implement UI-focused screens and widgets that watch controller signals.
7. Add routes using screen path constants and localize user-facing text.
8. Regenerate code when annotations or generated models changed.
9. Format changed Dart files and run `dart analyze`.

Do not create tests unless the user asks for them.

## Review Checklist

- [ ] Code is feature-first and each file belongs to the correct layer.
- [ ] Screens contain presentation logic only.
- [ ] Controllers use Signals rather than `ChangeNotifier`.
- [ ] Dependencies use Injectable + GetIt and constructor injection.
- [ ] External providers are accessed only through core service abstractions.
- [ ] Offline-capable repositories follow the local/remote/orchestration standard.
- [ ] Routes reference screen `path` constants.
- [ ] User-facing strings are localized and design-system primitives are reused.
- [ ] Changed Dart files are formatted and `dart analyze` passes.
