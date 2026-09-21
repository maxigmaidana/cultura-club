# Manual de Funcionamiento - Cultura Club (UI)

> Documento de referencia del estado actual de la app en runtime.
> Describe rutas, navegacion real, pantallas activas y comportamiento observable por rol.

Roles del sistema: `SUPER_ADMIN`, `ADMIN_CLUB`, `COACH` (ENTRENADOR), `PLAYER` (JUGADOR).
Regla actual de UI: `isCoach == true` para ENTRENADOR y SUPER_ADMIN.

---

## 1. Mapa de navegacion

```
/                                                   SplashScreen
/login                                              LoginScreen
/home                                               HomeScreen

/datebook/:categoriaId                              DatebookScreen
/datebook/:categoriaId/create                       CreateActivityScreen
/datebook/:categoriaId/activity/:activityId         ActivityDetailScreen (PLAYER)
/datebook/:categoriaId/activity/:activityId/edit    CreateActivityScreen (editar, COACH)
/datebook/:categoriaId/activity/:activityId/dashboard ActivityDashboardScreen (COACH)

/coach/category/:categoryId                         CategoryPlayersScreen
/coach/category/:categoryId/evaluate/:playerId      EvaluationFormScreen
/player/stats-chart/:categoriaId                    PlayerStatsChartScreen

/profile/:userId                                    UserProfileScreen
/health                                             HealthScreen
/gamification/:jugadorId                            GamificationScreen
/active-trivia/:triviaId/:jugadorId                ActiveTriviaScreen
```

---

## 2. Login y sesion

1. Al abrir la app se entra a `SplashScreen` y se intenta restaurar sesion.
2. Si hay sesion valida: navega a `/home`. Si no: `/login`.
3. En `LoginScreen`:
   - Campos vacios: SnackBar de validacion.
   - Credenciales invalidas: mensaje de error.
   - Exito: guarda sesion global (`userSessionProvider`) y entra a `/home`.
4. Logout:
   - Se ejecuta desde `SettingsScreen` -> opcion "Cerrar sesion".
   - Hace `signOut`, limpia `userSessionProvider` y navega a `/login`.

---

## 3. Home (Bottom Navigation)

`HomeScreen` arma 3 tabs para ambos roles:

### Coach (`isCoach == true`)
- Tab 0: `TabInicioGenerico`
- Tab 1: `CoachDashboardScreen`
- Tab 2: `SettingsScreen`

### Player (`isCoach == false`)
- Tab 0: `TabInicioGenerico`
- Tab 1: `MyAgendaScreen`
- Tab 2: `SettingsScreen`

### Pull-to-refresh en Home
- Coach: invalida `coachCategoriesControllerProvider` y `myAgendaControllerProvider`.
- Player: invalida `playerDashboardControllerProvider`, `pendingTriviasProvider(user.id)` y `myAgendaControllerProvider`.

> Nota: `PlayerDashboardScreen` existe en el codigo, pero hoy no esta conectado en la navegacion principal de `HomeScreen`.

---

## 4. Tab Inicio (`TabInicioGenerico`)

Contenido comun:
- Saludo con nombre del usuario.
- Card fija "Aviso Importante".

Contenido por rol:
- Coach: card `NextCoachCommitmentCard` (proxima actividad futura mas cercana entre sus categorias).
- Player:
  - `NextConfirmedActivityCard` (proxima actividad confirmada por el jugador).
  - `PendingTriviasSection` (trivias pendientes).

---

## 5. Agenda y actividades (Datebook)

### 5.1 Vista de categoria (`DatebookScreen`)
- Muestra actividades de una categoria ordenadas por fecha.
- Coach al tocar una actividad: va a `ActivityDashboardScreen`.
- Player al tocar una actividad: va a `ActivityDetailScreen`.
- Solo coach ve FAB para crear actividad (`CreateActivityScreen`).

### 5.2 Crear actividad (`CreateActivityScreen`)
- Campos: titulo, tipo, fecha/hora, lugar (opcional), indicaciones (opcional).
- Coach puede seleccionar jugadores para citar.
- Al guardar:
  - Crea actividad con estado `publicada`.
  - Inserta citaciones iniciales en `pendiente` para jugadores seleccionados.

### 5.3 Detalle para jugador (`ActivityDetailScreen`)
- Acciones:
  - Confirmar asistencia (`confirma`).
  - No asistir (`no_asiste`).
- Al responder: actualiza citacion, refresca providers y vuelve.

### 5.4 Dashboard para coach (`ActivityDashboardScreen`)
- Tabs de respuesta: Confirmados / Pendientes / No asisten.
- Accion de editar actividad -> abre `CreateActivityScreen` en modo edicion.

### 5.5 Estados
- Actividad: `borrador`, `publicada`, `cancelada`.
- Citacion: `pendiente`, `confirma`, `no_asiste`.

---

## 6. Categorias y plantel (Coach)

### 6.1 `CoachDashboardScreen`
- Lista categorias asignadas al entrenador.
- Empty state cuando no hay categorias.

### 6.2 `CategoryPlayersScreen`
- Lista jugadores de la categoria.
- Agrupa visualmente por `sector_cancha`.
- Action en AppBar: ir a agenda de la categoria (`DatebookScreen`).
- FAB "Agendar": crear actividad para la categoria.
- Tap en jugador: abre `EvaluationFormScreen`.

---

## 7. Evaluacion de jugadores

### 7.1 Flujo coach (`EvaluationFormScreen`)
1. Carga stats actuales del jugador (0-100).
2. Si no hay registro previo, inicia en 50 por metrica.
3. Coach ajusta sliders y opcionalmente deja comentarios.
4. Al guardar:
   - Calcula deltas (nuevo - original).
   - Upsert de absolutos en `jugador_categoria_stats`.
   - Insert de deltas en `evolucion_jugador`.
5. Feedback:
   - Exito: SnackBar de confirmacion y vuelve.
   - Error: SnackBar de error.

### 7.2 Visualizacion de stats de jugador
- `PlayerStatsChartScreen` muestra grafico por metrica + promedio general.
- Se abre desde puntos del flujo donde exista un `PlayerStatsEntity` disponible.

---

## 8. Configuracion (`SettingsScreen`)

Secciones visibles:
- Cuenta:
  - Perfil -> navega a `/profile/:userId`.
  - Notificaciones (placeholder sin accion real).

Secciones solo jugador (`!isCoach`):
- Rendimiento:
  - Mi evolucion -> `/health`.
  - Gamificacion -> `/gamification/:jugadorId`.
  - Sanciones (placeholder sin accion real).

Sesion:
- Cerrar sesion -> signOut + limpiar sesion + `/login`.

---

## 9. Perfil de usuario (`UserProfileScreen`)

- Carga datos por `userId` usando provider remoto.
- Muestra siempre:
  - Datos basicos (nombre, rol, email).
- Si es jugador y tiene `playerProfile`:
  - Categoria.
  - Datos fisicos (altura, peso, pierna habil).
  - Posiciones.
- Si es entrenador y tiene categorias asignadas:
  - Lista de categorias del coach.

---

## 10. Salud (`HealthScreen`)

- Pantalla de "Mi Evolucion" accesible desde Settings (jugador).
- Estado actual: UI estatica (placeholder), sin datasource ni escritura real.

---

## 11. Gamificacion

### 11.1 `GamificationScreen`
- Muestra:
  - Puntaje total.
  - Quizzes pendientes.
  - Historial de quizzes completados.
- Tiene pull-to-refresh que refresca puntos, pendientes y completados.

### 11.2 `ActiveTriviaScreen`
- Carga el quiz por `triviaId` desde pendientes del jugador.
- Si existe, renderiza `TriviaQuizView` para responder.
- Si no existe o falla, muestra estados de error/no encontrado.

---

## 12. Estados de UX comunes

- Loading: spinner o skeleton.
- Error: texto contextual o tarjeta de error.
- Empty state: mensaje explicativo.
- Mutaciones: feedback con SnackBar + invalidacion de providers para refrescar data.

---

*Ultima actualizacion: 2026-09-21*
