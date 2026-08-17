---
name: flutter-keep-files-focused
description: Keep Flutter and Dart changes aligned with this repository's feature-first clean architecture while preventing oversized, mixed-responsibility files. Use when creating, editing, refactoring, or reviewing application code; adding models, repositories, services, controllers, screens, or widgets; or when a proposed change would add substantial code to an existing file.
---

# Keep Flutter Files Focused

Preserve architectural boundaries and make each file easy to name, locate, test, and review. Prefer cohesive files over either mega-files or artificial one-line wrappers.

## Inspect Before Editing

1. Read the repository `AGENTS.md` and the nearest feature structure.
2. List the relevant files and inspect neighboring implementations.
3. Identify the layer and responsibility of every new type before writing it.
4. Check the size and declarations of files that will receive substantial code.

Do not use an existing misplaced type as precedent when the repository's documented architecture says otherwise.

## Follow This Project Structure

Place feature code under `lib/features/<feature>/`:

- `domain/models/`: immutable business models, normally one public model per file.
- `domain/repositories/`: provider-neutral repository and persistence contracts.
- `domain/`: domain errors and other dependency-free business types.
- `application/`: controllers, policies, coordinators, and use cases.
- `data/`: API transports, JSON mappers, repository implementations, local storage, Drift, and provider-specific code.
- `presentation/`: screens and widgets; place reusable or public widgets in separate files.

Place shared provider abstractions and cross-feature infrastructure under `lib/core/` according to the existing structure.

Enforce dependency direction:

- Domain must not import application, data, presentation, Flutter SDK, or provider SDKs.
- Application must depend on domain contracts, not concrete data implementations.
- Presentation must depend on application and domain types, not parse transport payloads.
- Data may depend on domain and must own serialization, SDK, network, database, and storage details.
- Dependency injection must connect domain contracts to data implementations.

## Keep Files Focused

Prefer one public model, contract, screen, reusable widget, mapper, repository implementation, or service per file. Keep private helpers beside their owner only when they are small and cannot be reused independently.

Treat these as strong refactoring signals:

- A file defines unrelated public types.
- Models are declared inside an API, service, controller, repository, or screen file.
- A controller handles transport mapping, persistence details, or substantial widget construction.
- A screen contains reusable widgets or large independent sections.
- A file name no longer describes most of its contents.
- A hand-written file is approaching 300 lines or a change would push it materially beyond that size.
- A class has several independent reasons to change.

Do not wait for a hard line limit when responsibilities are already mixed. Conversely, do not split a cohesive implementation solely to satisfy a number.

Exclude generated files such as `*.g.dart`, `*.freezed.dart`, and build output from file-size judgments and manual refactors.

## Split Safely

When a touched file has mixed responsibilities:

1. Extract domain models and contracts first.
2. Move JSON parsing and payload construction into data-layer mappers.
3. Keep API clients limited to transport concerns.
4. Put repository orchestration and error translation in data repository implementations.
5. Make controllers consume domain contracts through constructor injection.
6. Extract reusable or independently understandable widgets into presentation files.
7. Update imports and dependency injection without changing behavior.

Preserve public behavior and avoid an unrelated repository-wide syntax or naming sweep. If a complete split would materially expand the requested scope, keep new code properly placed, avoid making the oversized file worse, and report the remaining architectural debt.

## Review Before Handoff

Run checks that answer all of the following:

- Does each new public type live in the correct layer and a clearly named file?
- Do domain and application files avoid imports from `data`?
- Are provider types and raw JSON confined to `data` or `core/services` implementations?
- Did any hand-written file become oversized or gain a second responsibility?
- Could a reviewer locate a model, contract, mapper, implementation, or widget from its path alone?

Run `dart format` on changed Dart files, then `dart analyze` and the relevant tests required by the task or repository instructions.
