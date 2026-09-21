# API Endpoints - Cultura Club

> Este proyecto usa Supabase como BaaS. No hay backend REST propio.
> Los "endpoints" documentados aca son los metodos de cada DataSource en `lib/features/*/data/**`, que llaman directo al cliente de Supabase.
> Todas las queries corren con la sesion autenticada del usuario y dependen de RLS.

## Indice
- Auth (`auth_remote_data_source.dart`)
- Coach (`coach_rempote_data_source.dart`)
- Evaluation (`evaluation_remote_data_source.dart`)
- Datebook (`datebook_remote_data_source.dart`)
- User (`user_remote_data_source.dart`)
- Gamification (`trivia_remote_data_source.dart`)

---

## Auth - `lib/features/auth/data/datasources/auth_remote_data_source.dart`

### `login(String email, String password)`
- Que hace: autentica con `supabase.auth.signInWithPassword`, luego consulta `usuarios` para completar perfil de negocio.
- Query:
  1. `auth.signInWithPassword(email, password)`
  2. `from('usuarios').select('club_id, rol, nombre_completo').eq('id', user.id).maybeSingle()`
- Respuesta: `UserModel?`.
- Detalle: si autentica en Auth pero no hay fila en `usuarios`, retorna `null`.

### `restoreSession()`
- Que hace: usa `auth.currentSession` y vuelve a consultar `usuarios`.
- Respuesta: `UserModel?` o `null`.

### `signOut()`
- Que hace: `auth.signOut()`.
- Respuesta: `void`.

---

## Coach - `lib/features/coach/data/datasource/coach_rempote_data_source.dart`

### `getCategoriesByCoach(String coachId)`
- Que hace: trae categorias donde `entrenador_id = coachId`.
- Query: `from('categorias').select('id, club_id, nombre, entrenador_id').eq('entrenador_id', coachId)`.
- Respuesta: `List<CategoryEntity>`.

### `getRosterByCategory(String categoryId)`
- Que hace: trae plantel de una categoria con datos del usuario.
- Query:
  `from('jugadores_perfil').select('usuario_id, posiciones, pierna_habil, altura_cm, peso_kg, sector_cancha, usuarios(nombre_completo)').eq('categoria_id', categoryId)`
- Respuesta: `List<PlayerProfileEntity>`.
- Nota: incluye `sector_cancha` para agrupar jugadores en UI.

---

## Evaluation - `lib/features/evaluation/data/datasource/evaluation_remote_data_source.dart`

### `getPlayerStats(String playerId, String categoryId)`
- Que hace: trae stats absolutas (0-100) de un jugador en una categoria.
- Query:
  `from('jugador_categoria_stats').select('*, categorias(nombre)').eq('jugador_id', playerId).eq('categoria_id', categoryId).maybeSingle()`
- Respuesta: `PlayerStatsModel`.
- Nota: si no existe fila retorna `PlayerStatsModel.defaultStats(...)`.

### `getAllStatsForPlayer(String playerId)`
- Que hace: trae todas las stats del jugador en todas sus categorias.
- Query: `from('jugador_categoria_stats').select('*, categorias(nombre)').eq('jugador_id', playerId)`.
- Respuesta: `List<PlayerStatsModel>`.

### `insertEvaluation(EvaluationModel delta, PlayerStatsModel newStats)`
- Que hace: guarda evaluacion en dos pasos:
  1. `upsert` de absolutos en `jugador_categoria_stats`.
  2. `insert` de deltas en `evolucion_jugador`.
- Queries:
  - `from('jugador_categoria_stats').upsert(..., onConflict: 'jugador_id,categoria_id')`
  - `from('evolucion_jugador').insert(...)`
- Respuesta: `void`.
- Nota: no hay transaccion; puede quedar escritura parcial si falla el segundo paso.

---

## Datebook - `lib/features/datebook/data/datasource/datebook_remote_data_source.dart`

### `getActivitiesByCategory(String categoriaId)`
- Que hace: trae actividades de una categoria con sus citaciones.
- Query: `from('actividades').select('*, citaciones(*)').eq('categoria_id', categoriaId).order('fecha_hora', ascending: true)`.
- Respuesta: `List<ActivityModel>`.

### `respondToCitation(String actividadId, String jugadorId, String estadoRespuesta)`
- Que hace: crea/actualiza respuesta del jugador.
- Query:
  `from('citaciones').upsert({...}, onConflict: 'actividad_id,jugador_id')`
- Payload incluye: `fecha_respuesta` en UTC (`DateTime.now().toUtc().toIso8601String()`).
- Respuesta: `void`.

### `createActivity({categoriaId, creadorId, tipo, titulo, fechaHora, lugar, indicaciones, jugadorIds})`
- Que hace: crea actividad y opcionalmente genera citaciones iniciales.
- Queries:
  1. `from('actividades').insert({... 'estado': 'publicada'}).select('id').single()`
  2. Si `jugadorIds` no esta vacio: `from('citaciones').insert([...])` con `estado_respuesta: 'pendiente'`.
- Respuesta: `void`.

### `updateActivity({actividadId, tipo, titulo, fechaHora, lugar, indicaciones})`
- Que hace: actualiza datos base de una actividad existente.
- Query:
  `from('actividades').update({...}).eq('id', actividadId)`
- Respuesta: `void`.

### `getActivitiesForPlayer(String jugadorId)`
- Que hace: trae agenda personal del jugador usando `citaciones` como tabla base.
- Query:
  `from('citaciones').select('*, actividades(*, citaciones(*))').eq('jugador_id', jugadorId).order('actividades(fecha_hora)', ascending: true)`
- Respuesta: `List<ActivityModel>` (parseando `row['actividades']`).

---

## User - `lib/features/user/data/datasources/user_remote_data_source.dart`

### `getUserDetails(String userId)`
- Que hace: trae perfil extendido del usuario con join a `jugadores_perfil` y `categorias` asociada al jugador.
- Query principal:
  `from('usuarios').select('id, club_id, rol, nombre_completo, email, jugadores_perfil(usuario_id, categoria_id, foto_url, fecha_nacimiento, pierna_habil, posiciones, altura_cm, peso_kg, categorias(id, nombre))').eq('id', userId).maybeSingle()`
- Query adicional condicional:
  - Si `rol == 'ENTRENADOR'`: `from('categorias').select('id, club_id, nombre, entrenador_id').eq('entrenador_id', userId)`
- Respuesta: `UserModel` (con `playerProfile` o `coachCategories` segun rol).

---

## Gamification - `lib/features/gamification/data/datasources/trivia_remote_data_source.dart`

### `getPendingTrivias(String jugadorId)`
- Que hace: trae trivias pendientes para el jugador.
- Flujo de queries:
  1. `jugadores_perfil` para obtener `categoria_id` del jugador.
  2. `trivia_respuestas` para preguntas ya respondidas.
  3. `trivia_preguntas` para obtener trivias ya respondidas.
  4. `trivias` + join `trivia_preguntas` filtrando por categoria y excluyendo respondidas.
- Respuesta: `List<TriviaModel>`.

### `getCompletedTrivias(String jugadorId)`
- Que hace: trae respuestas del jugador y consolida trivias completadas con puntaje.
- Query base:
  `from('trivia_respuestas').select('id, pregunta_id, jugador_id, puntos_ganados, trivia_preguntas(trivia_id, trivias(id, titulo)))').eq('jugador_id', jugadorId).order('id', ascending: false)`
- Logica adicional: valida completitud por trivia contando preguntas totales en `trivia_preguntas`.
- Respuesta: `List<CompletedTriviaInfoModel>`.

### `submitTriviaAnswers(String triviaId, String jugadorId, List<Map<String, dynamic>> respuestas)`
- Que hace: guarda respuestas del quiz una por una.
- Por cada respuesta:
  1. Lee `respuesta_correcta` desde `trivia_preguntas`.
  2. Inserta en `trivia_respuestas` con `es_correcta` y `puntos_ganados` (1/0).
- Respuesta: `void`.

### `getTotalGameificationPoints(String jugadorId)`
- Que hace: obtiene puntos totales usando RPC.
- Query:
  `rpc('obtener_puntos_totales_gamification', params: {'p_jugador_id': jugadorId})`
- Respuesta: `int` (si falla retorna `0`).

---

## Resumen de tablas/servicios usados

| Tabla / Servicio | Operaciones | Desde |
|---|---|---|
| `auth.users` (GoTrue) | signIn, signOut, currentSession | Auth |
| `usuarios` | select | Auth, User |
| `categorias` | select | Coach, User |
| `jugadores_perfil` | select | Coach, User, Gamification |
| `jugador_categoria_stats` | select, upsert | Evaluation |
| `evolucion_jugador` | insert | Evaluation |
| `actividades` | select, insert, update | Datebook |
| `citaciones` | select, insert, upsert | Datebook |
| `trivias` | select | Gamification |
| `trivia_preguntas` | select | Gamification |
| `trivia_respuestas` | select, insert | Gamification |
| `rpc.obtener_puntos_totales_gamification` | rpc | Gamification |

## Notas generales
- No hay transacciones en operaciones de multiples escrituras (`insertEvaluation`, `createActivity`).
- Los permisos dependen de politicas RLS en Supabase.
- Los DataSources usan logging con `dart:developer` y relanzan errores en la mayoria de casos.

*Ultima actualizacion: 2026-09-21*