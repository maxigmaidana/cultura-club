# Project Context: Cultura Club
Football club management app. Roles: SUPER_ADMIN, ADMIN_CLUB, COACH, PLAYER.

## Tech Stack & BaaS Strategy
- **Frontend**: Flutter
- **Backend**: Supabase (Used as a BaaS). Authentication, Postgres SQL, and Row Level Security (RLS) are handled directly on Supabase.
- **State Management & DI**: Riverpod (strict use of `@riverpod` and code generation).
- **Routing**: GoRouter
- **Error Handling**: fpdart (strict use of `Either` and `Failure`). 
- **Querying**: DataSources must use the Supabase Flutter client directly (e.g., `supabase.from('table').select(...)`). Use PostgREST joins for relations.

## Database Schema Reference
The app relies on this relational structure. Assume UUIDs for all primary/foreign keys unless specified.

- **usuarios**: Core user data. `id` (FK to auth.users), `club_id`, `rol`, `nombre_completo`.
- **clubs**: Club branding and info. `id`, `nombre`, `primary_color`, `logo_url`.
- **categorias**: Teams within a club. `id`, `club_id`, `nombre`, `entrenador_id` (coach).
- **jugadores_perfil**: Static player info. `usuario_id` (PK), `categoria_id`, `posiciones`, `pierna_habil`, `altura_cm`, `peso_kg`.
- **jugador_categoria_stats**: Absolute current stats (0-100 scale). `id`, `jugador_id`, `categoria_id`, `velocidad`, `resistencia`, `tecnica`, `tactica`, `actitud`, `asistencia`. 
- **evolucion_jugador**: Historical log of stat changes. Stores DELTAS (e.g., +2, -1) not absolute values. `id`, `jugador_id`, `evaluador_id`, `categoria_id`, `velocidad`, `resistencia`, etc., plus `comentarios_dt`.
- **partidos**: Match events. `id`, `club_id`, `categoria_id`, `rival`, `condicion`, `fecha_hora`.
- **partidos_rendimiento**: Player match stats. `id`, `jugador_id`, `partido_id`, `minutos_jugados`, `goles`, `asistencias`, `puntos_mvp`.
- **actividades**: Agenda events (entrenamiento, partido, evento). `id`, `categoria_id`, `creador_id`, `tipo`, `titulo`, `fecha_hora`, `lugar`, `indicaciones`, `estado`.
- **citaciones**: Player responses to activities. `id`, `actividad_id`, `jugador_id`, `estado_respuesta` (pendiente/confirma/no_asiste), `fecha_respuesta`.

## Architecture: Clean Architecture + Feature-Sliced Design
New features go in `lib/features/feature_name/` and are strictly divided into:

1. **Domain**:
   - `entities/`: Pure Dart classes.
   - `repositories/`: Abstract classes (contracts).
   - `usecases/`: Classes with a single `call()` method returning `Future<Either<Failure, T>>`.

2. **Data**:
   - `models/`: Entity mappers (`fromJson`/`toJson`).
   - `datasources/`: Interface and `Impl` for Supabase interaction. Ensure proper `dart:developer` logs.
   - `repositories/`: `Impl` of Domain repositories. Catch exceptions and return `Left(Failure)`.

3. **Presentation**:
   - `providers/`: Static DI (`_providers.dart`).
   - `controllers/`: Riverpod state controllers (AsyncNotifier/Notifier) using `@riverpod`.
   - `screens/`: `ConsumerWidget` or `ConsumerStatefulWidget`.
   - `widgets/`: Feature-specific isolated UI components.

## Core (`lib/core/`)
Shared modules: enums (`posicion`, `pierna_habil`, `condicion_partido`), themes, `app_router.dart`, `failures.dart`, global providers (`supabaseProvider`, `userSessionProvider`).

## Interaction Rules for the AI
1. **Direct code**: No theoretical explanations. The user is a Tech Lead.
2. **Zero infrastructure in UI**: Presentation MUST NOT import Supabase directly. Use Controllers and UseCases.
3. **Structure first**: Provide the file tree first, then exact code blocks ready to copy-paste.
4. **Concise responses**: No fluff, no long greetings, no repetitive conclusions.
5. **Typesafe & Null-safe**: Strictly enforce Dart null-safety.