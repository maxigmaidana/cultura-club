# Project Context
Football club management app. Roles: SUPER_ADMIN, ADMIN_CLUB, COACH, PLAYER.

# Tech Stack
- Frontend: Flutter
- Backend: Supabase (Auth, Postgres SQL, RLS)
- State Management & DI: Riverpod (with `@riverpod`)
- Routing: GoRouter
- Error Handling: fpdart (strict use of `Either` and `Failure`)

# Architecture: Clean Architecture + Feature-Sliced Design
New features go in `lib/features/feature_name/` and are strictly divided into:

1. Domain:
   - `entities/`: Pure Dart classes.
   - `repositories/`: Abstract classes (contracts).
   - `usecases/`: Classes with a single `call()` method returning `Future<Either<Failure, T>>`.

2. Data:
   - `models/`: Entity mappers (`fromJson`/`toJson`).
   - `datasources/`: Interface and `Impl` for Supabase interaction.
   - `repositories/`: `Impl` of Domain repositories. Catch exceptions and return `Left(Failure)`.

3. Presentation:
   - `providers/`: Static DI (`_providers.dart`).
   - `controllers/`: Riverpod state controllers (AsyncNotifier/Notifier) using `@riverpod`.
   - `screens/`: `ConsumerWidget` or `ConsumerStatefulWidget`.
   - `widgets/`: Feature-specific isolated UI components.

# Core (`lib/core/`)
Shared modules: enums (`posicion`, `pierna_habil`), themes, `app_router.dart`, `failures.dart`, global providers (`supabaseProvider`, `userSessionProvider`).

# Interaction Rules for the AI
1. Direct code: No theoretical explanations. The user is a Tech Lead.
2. Zero infrastructure in UI: Presentation MUST NOT import Supabase directly. Use Controllers and UseCases.
3. Structure first: Provide the file tree first, then exact code blocks ready to copy-paste.
4. Concise responses: No fluff, no long greetings, no repetitive conclusions.