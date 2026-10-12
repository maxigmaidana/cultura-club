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
/coach/category/:categoryId/player/:playerId        CoachPlayerDetailScreen (COACH)
/coach/category/:categoryId/player/:playerId/sanctions   CoachPlayerSanctionsScreen
/player/stats-chart/:categoriaId                    PlayerStatsChartScreen

/profile/:userId                                    UserProfileScreen
/health                                             HealthScreen
/player-injuries/:playerId                          PlayerInjuriesScreen (Estado físico)
/player-injuries/:playerId/:injuryId                InjuryDetailScreen
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
- Tap en jugador: abre `CoachPlayerDetailScreen`.

---

## 7. Detalle de jugador (Coach)

### 7.1 `CoachPlayerDetailScreen`
- Ficha/menú del jugador con opciones.
- Header muestra:
  - Nombre completo
  - Categoría
  - Posiciones
  - Pierna hábil
  - Altura y peso (si están disponibles)
- Opciones disponibles (cards/menu):
  1. **Estado Físico** → Abre `PlayerInjuriesScreen`
     - Lista lesiones activas (status ACTIVE/RECOVERING) vs historial cerrado (CLOSED)
     - Disponibilidad del jugador: can_train, can_play
     - Detalles operativos permitidos: título, descripción, fecha inicio, fecha regreso, body area, severity
     - Textos neutrales ("Sin lesiones activas", no "No tenés...")
     - NO muestra datos médicos privados (diagnosis, clinical_notes, etc.)
  2. **Sanciones** → Abre `CoachPlayerSanctionsScreen`
     - Placeholder actual (abierto para conectar backend de sanciones deportivas)
     - Muestra "Sin sanciones registradas"
     - Separado conceptualmente de lesiones
  3. **Datos del Jugador** → Info en la ficha
     - Nombre, categoría, posiciones, pierna hábil, altura, peso, sector

NO tiene opción "Rendimiento". La evaluación manual ha sido eliminada del flujo del entrenador.

---

## 8. Estado Físico (Lesiones)

El módulo de lesiones es ahora el contenedor de "Estado físico" tanto para el entrenador como para el jugador.

**Para Entrenador:**
- Ruta: `/player-injuries/:playerId` (desde CoachPlayerDetailScreen)
- AppBar: "Estado físico"
- Textos neutrales
- Acceso explícito con playerId de la URL

**Para Jugador (en Settings):**
- Ruta: `/player-injuries/${user.id}` (desde SettingsScreen)
- AppBar: "Estado físico"
- Textos neutrales (funciona para ambos contextos)
- playerId es el del usuario autenticado

Información visible:
- ✅ Lesiones activas (ACTIVE, RECOVERING)
- ✅ Historial de lesiones cerradas (CLOSED)
- ✅ Detalles: título, descripción, fecha inicio, fecha regreso, body area, body side, severity traducida
- ✅ Flags operativos: can_train, can_play
- ✅ Player notes si existen
- ❌ Datos médicos privados: diagnosis, clinical_notes, treatment_plan, rehabilitation_plan, attachments
- ❌ Información clínica restringida a DOCTOR

---

## 9. Configuración (`SettingsScreen`)

Secciones visibles:
- Cuenta:
  - Perfil → navega a `/profile/:userId`.
  - Notificaciones (placeholder sin acción real).

Secciones solo jugador (`!isCoach`):
- Rendimiento:
  - Mi evolución → `/health`.
  - Gamificación → `/gamification/:jugadorId`.
  - Estado físico → `/player-injuries/${user.id}`.

Sesión:
- Cerrar sesión → signOut + limpiar sesión + `/login`.

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
