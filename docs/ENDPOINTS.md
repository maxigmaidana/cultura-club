# API Endpoints — Cultura Club

> Este proyecto usa **Supabase como BaaS**: no hay un backend propio con rutas REST custom. Los "endpoints" documentados acá son los métodos de cada `DataSource` (`lib/features/*/data/datasource*/`) que llaman directamente al cliente de Supabase (`supabase_flutter`), agrupados por tabla/servicio. Todas las queries corren con el cliente autenticado del usuario logueado, por lo que están sujetas a las políticas de **Row Level Security (RLS)** configuradas en cada tabla.

## Índice
- Auth (`auth_remote_data_source.dart`)
- Coach (`coach_rempote_data_source.dart`)
- Evaluation (`evaluation_remote_data_source.dart`)
- Datebook (`datebook_remote_data_source.dart`)

---

## Auth — `lib/features/auth/data/datasources/auth_remote_data_source.dart`

Interactúa con `supabaseClient.auth` (GoTrue) y la tabla `usuarios`.

### `login(String email, String password)`
- **Qué hace:** autentica al usuario contra Supabase Auth y luego busca su perfil de negocio en `usuarios`.
- **Espera:** `email`, `password` (texto plano, viaja por HTTPS a Supabase).
- **Por qué:** Supabase Auth solo conoce `email`/`password`/`id`; el rol, el club y el nombre del usuario viven en la tabla `usuarios`, así que hace falta un segundo query para armar el `UserModel` completo.
- **Llamadas:**
  1. `supabaseClient.auth.signInWithPassword(email, password)` → devuelve `AuthResponse` con `user.id`, `user.email`.
  2. `supabaseClient.from('usuarios').select('club_id, rol, nombre_completo').eq('id', user.id).maybeSingle()`.
- **Respuesta:** `UserModel?` con `id`, `email`, `clubId`, `role` (`UserRole.fromString`), `fullName`. `null` si el login fue exitoso en Auth pero no existe fila en `usuarios` (perfil incompleto).
- **Errores:** si `signInWithPassword` falla, lanza `AuthException` (mal manejada en capas superiores como `Left(AuthFailure(...))`). Si el select de `usuarios` falla, se traga el error y retorna `null` (no relanza).

### `restoreSession()`
- **Qué hace:** intenta recuperar la sesión persistida localmente (token guardado por Supabase) y volver a traer el perfil de `usuarios`.
- **Espera:** nada — usa `supabaseClient.auth.currentSession`.
- **Por qué:** para no pedirle credenciales al usuario en cada apertura de la app (splash screen).
- **Respuesta:** `UserModel?`. `null` si no hay sesión guardada o si no existe fila en `usuarios`.

### `signOut()`
- **Qué hace:** cierra sesión en Supabase Auth (invalida el token).
- **Espera:** nada.
- **Respuesta:** `void`. Relanza cualquier error.

---

## Coach — `lib/features/coach/data/datasource/coach_rempote_data_source.dart`

### `getCategoriesByCoach(String coachId)`
- **Qué hace:** trae las categorías (equipos) que dirige un entrenador.
- **Espera:** `coachId` (uuid de `usuarios.id`).
- **Query:** `from('categorias').select('id, club_id, nombre, entrenador_id').eq('entrenador_id', coachId)`.
- **Por qué:** un entrenador puede tener asignadas 1+ categorías (`categorias.entrenador_id`); se usa en `CoachDashboardScreen` para listar "Mis Categorías".
- **Respuesta:** `List<CategoryEntity>` (`id`, `clubId`, `nombre`, `entrenadorId`).

### `getRosterByCategory(String categoryId)`
- **Qué hace:** trae el plantel de jugadores de una categoría, con datos de perfil.
- **Espera:** `categoryId` (uuid de `categorias.id`).
- **Query:** `from('jugadores_perfil').select('usuario_id, posiciones, pierna_habil, altura_cm, peso_kg, usuarios(nombre_completo)').eq('categoria_id', categoryId)` — usa un **join implícito de PostgREST** contra `usuarios` para traer el nombre.
- **Por qué:** `jugadores_perfil` no guarda el nombre del jugador (vive en `usuarios`), por eso el join anidado.
- **Respuesta:** `List<PlayerProfileEntity>` (`userId`, `fullName`, `posiciones` (enum `Posicion[]`), `piernaHabil` (enum), `alturaCm`, `pesoKg`).

---

## Evaluation — `lib/features/evaluation/data/datasource/evaluation_remote_data_source.dart`

### `getPlayerStats(String playerId, String categoryId)`
- **Qué hace:** trae las stats **absolutas** (0-100) de un jugador en una categoría puntual.
- **Query:** `from('jugador_categoria_stats').select('*, categorias(nombre)').eq('jugador_id', playerId).eq('categoria_id', categoryId).maybeSingle()`.
- **Por qué:** si el jugador nunca fue evaluado en esa categoría no hay fila — en ese caso se devuelve `PlayerStatsModel.defaultStats(...)` (todas las stats en 50) en vez de fallar, para que la UI siempre tenga algo que mostrar.
- **Respuesta:** `PlayerStatsModel` (`jugadorId`, `categoriaId`, `categoriaNombre`, `velocidad`, `resistencia`, `tecnica`, `tactica`, `actitud`, `asistencia`, `updatedAt`).

### `getAllStatsForPlayer(String playerId)`
- **Qué hace:** trae **todas** las filas de stats del jugador, sin filtrar por categoría (puede tener más de una si jugó en distintas categorías).
- **Query:** `from('jugador_categoria_stats').select('*, categorias(nombre)').eq('jugador_id', playerId)`.
- **Respuesta:** `List<PlayerStatsModel>`. Usado en `PlayerDashboardScreen` ("Mis Estadísticas") para listar una card por categoría.

### `insertEvaluation(EvaluationModel delta, PlayerStatsModel newStats)`
- **Qué hace:** guarda una evaluación del entrenador. Hace **dos escrituras**:
  1. `from('jugador_categoria_stats').upsert(statsPayload, onConflict: 'jugador_id,categoria_id')` → graba los **valores absolutos nuevos** (0-100) de esa categoría.
  2. `from('evolucion_jugador').insert(deltaPayload)` → graba el **historial de cambios** (deltas, ej: `+2`, `-1`), quién evaluó (`evaluador_id`) y comentarios (`comentarios_dt`).
- **Por qué dos tablas:** `jugador_categoria_stats` siempre refleja el estado actual (para mostrar en UI rápido); `evolucion_jugador` es el log histórico/auditable de por qué cambió cada stat.
- **Espera:**
  - `delta` → `EvaluationEntity` con `jugadorId`, `categoriaId`, `evaluadorId`, `fechaEvaluacion` (se manda como `YYYY-MM-DD`), deltas de cada stat, `comentariosDt` opcional.
  - `newStats` → `PlayerStatsEntity` con los valores absolutos ya calculados en la UI (original + delta).
- **Respuesta:** `void`. Si cualquiera de los dos writes falla, relanza (no hay rollback manual — no es una transacción atómica).

---

## Datebook — `lib/features/datebook/data/datasource/datebook_remote_data_source.dart`

Gestiona `actividades` (entrenamientos/partidos/eventos) y `citaciones` (respuesta de cada jugador a una actividad).

### `getActivitiesByCategory(String categoriaId)`
- **Qué hace:** trae todas las actividades de una categoría, con sus citaciones embebidas.
- **Query:** `from('actividades').select('*, citaciones(*)').eq('categoria_id', categoriaId).order('fecha_hora', ascending: true)`.
- **Por qué:** se usa en `DatebookScreen` para listar la agenda completa de esa categoría (jugador y coach comparten esta lista, cambia solo la navegación al tocar una card).
- **Respuesta:** `List<ActivityModel>` — cada una con `id`, `categoriaId`, `creadorId`, `tipo`, `titulo`, `fechaHora`, `lugar`, `indicaciones`, `estado`, `citaciones: List<CitationEntity>`.

### `respondToCitation(String actividadId, String jugadorId, String estadoRespuesta)`
- **Qué hace:** guarda/actualiza la respuesta de un jugador a una actividad puntual.
- **Query:** `from('citaciones').upsert({...}, onConflict: 'actividad_id,jugador_id')`.
- **Espera:** `estadoRespuesta` debe ser uno de los valores del `CHECK` constraint de `citaciones.estado_respuesta`: `'pendiente'`, `'confirma'`, `'no_asiste'` (ver enum `CitacionEstado`).
- **Por qué upsert:** la fila puede o no existir (si el coach ya generó la citación al crear la actividad, existe con `'pendiente'`; si no, el jugador la crea al responder). La clave compuesta `(actividad_id, jugador_id)` evita duplicados.
- **Side effect en el payload:** manda `fecha_respuesta: DateTime.now().toUtc()`.
- **Respuesta:** `void`.

### `createActivity({categoriaId, creadorId, tipo, titulo, fechaHora, lugar, indicaciones, jugadorIds})`
- **Qué hace:** crea una actividad nueva y, opcionalmente, cita de una vez a una lista de jugadores.
- **Espera:**
  - `categoriaId`, `creadorId` (coach), `tipo` (`'entrenamiento' | 'partido' | 'evento'`, enum `ActivityTipo`), `titulo`, `fechaHora` (se manda en UTC).
  - `lugar`, `indicaciones` — opcionales.
  - `jugadorIds` — lista opcional de uuids de jugadores a citar (viene del `_RosterPicker` en `CreateActivityScreen`, con opción "Seleccionar todos").
- **Query (2 pasos):**
  1. `from('actividades').insert({...., 'estado': 'publicada'}).select('id').single()` → inserta y devuelve el `id` generado.
  2. Si `jugadorIds` no está vacío: `from('citaciones').insert([{actividad_id, jugador_id, estado_respuesta: 'pendiente'}, ...])` → una fila por jugador citado, todas en `'pendiente'`.
- **Por qué el `estado` fijo en `'publicada'`:** la columna `actividades.estado` tiene un `CHECK` constraint que solo acepta `'borrador' | 'publicada' | 'cancelada'` (`'borrador'`: creada pero no visible aún para jugadores; `'publicada'`: visible y citable — default actual de la app; `'cancelada'`: baja lógica, no se borra la fila para no perder historial/respuestas). Hoy la app siempre crea en `'publicada'`; no hay UI todavía para guardar como borrador o cancelar.
- **Por qué pre-crear citaciones:** si no se insertan de entrada, un jugador no aparece en la pestaña "Pendientes" del dashboard del coach hasta que interactúa. Pre-creándolas en `'pendiente'`, el coach ve de entrada quién falta responder.
- **Respuesta:** `void`. Si el insert de `actividades` fue exitoso pero el de `citaciones` falla, la actividad **queda creada sin citaciones** (no hay transacción ni rollback).

### `getActivitiesForPlayer(String jugadorId)`
- **Qué hace:** trae **todas** las actividades citadas para un jugador, sin importar la categoría (soporta jugadores en más de una categoría).
- **Query:** `from('citaciones').select('*, actividades(*, citaciones(*))').eq('jugador_id', jugadorId).order('actividades(fecha_hora)', ascending: true)` — se consulta desde `citaciones` (no desde `actividades`) porque el filtro relevante (`jugador_id`) vive ahí.
- **Por qué el join anidado repite `citaciones` dentro de `actividades`:** cada `ActivityModel.fromJson` espera el array completo de citaciones (para que `ActivityDetailScreen`/`MyAgendaScreen` puedan mostrar el estado propio del jugador logueado sin un segundo query).
- **Respuesta:** `List<ActivityModel>` (se extrae `row['actividades']` de cada fila de `citaciones` y se parsea igual que en `getActivitiesByCategory`). Usado en `MyAgendaScreen` (tab "Agenda" del jugador en `HomeScreen`).

---

## Resumen de tablas usadas

| Tabla | Operaciones | Desde |
|---|---|---|
| `auth.users` (GoTrue) | signIn, signOut, currentSession | Auth |
| `usuarios` | select | Auth |
| `categorias` | select | Coach |
| `jugadores_perfil` | select (join `usuarios`) | Coach |
| `jugador_categoria_stats` | select, upsert | Evaluation |
| `evolucion_jugador` | insert | Evaluation |
| `actividades` | select (join `citaciones`), insert | Datebook |
| `citaciones` | select, upsert, insert (join `actividades`) | Datebook |

## Notas generales / deuda técnica
- **No hay transacciones**: los flujos de dos escrituras (`insertEvaluation`, `createActivity` con citaciones) pueden quedar a mitad de camino si la segunda escritura falla. No hay compensación/rollback manual.
- **RLS no está documentado en el código**: todas las queries asumen que las políticas de Supabase filtran correctamente por `club_id`/rol; no hay chequeos de permisos en el cliente más allá de mostrar/ocultar UI según `UserRole`.
- **Todos los errores se logean con `dart:developer log`** con prefijo `📡`/`✅`/`❌` antes de relanzar (o, en `AuthRemoteDataSource.restoreSession`/`login`, a veces se silencia el error y se retorna `null`).
