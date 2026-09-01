# Manual de Funcionamiento — Cultura Club (UI)

> Este documento describe **cómo funciona la app hoy en día** a nivel de interfaz y flujos de usuario: qué pantallas existen, quién las ve, qué se puede hacer en cada una y qué pasa al ejecutar cada acción. Está pensado como referencia rápida para cualquiera que necesite entender el comportamiento actual sin leer todo el código.

Roles del sistema: `SUPER_ADMIN`, `ADMIN_CLUB`, `COACH` (entrenador), `PLAYER` (jugador).
En el código, `isCoach` es `true` para `ENTRENADOR` y `SUPER_ADMIN` (ambos ven la UI de entrenador).

---

## 1. Mapa de navegación

```
/                    SplashScreen        → redirige a /home o /login según sesión
/login               LoginScreen         → pantalla pública de acceso
/home                HomeScreen (hub con Bottom Navigation, tabs según rol)

/datebook/:categoriaId                                    DatebookScreen (agenda de la categoría)
/datebook/:categoriaId/create                              CreateActivityScreen (crear)
/datebook/:categoriaId/activity/:activityId                ActivityDetailScreen (PLAYER)
/datebook/:categoriaId/activity/:activityId/edit           CreateActivityScreen (editar, COACH)
/datebook/:categoriaId/activity/:activityId/dashboard       ActivityDashboardScreen (COACH)

/coach/category/:categoryId                                CategoryPlayersScreen (plantel)
/coach/category/:categoryId/evaluate/:playerId             EvaluationFormScreen (COACH)

/player/stats-chart/:categoriaId                           PlayerStatsChartScreen (PLAYER)
```

---

## 2. Login y sesión

1. Al abrir la app aparece el **Splash**: mientras se restaura la sesión guardada en Supabase se muestra un spinner.
2. Si hay sesión válida → va directo a `/home`. Si no → va a `/login`.
3. En **Login**, el usuario ingresa email y contraseña.
   - Si algún campo está vacío: SnackBar "Por favor, completa todos los campos".
   - Si las credenciales son inválidas: SnackBar rojo con el mensaje de error de Supabase.
   - Si todo es correcto: se guarda el usuario en la sesión global (`userSessionProvider`) y navega a `/home`.
4. **Logout**: desde el tab "Inicio", botón de logout en el AppBar. Cierra sesión en Supabase, limpia la sesión local y vuelve a `/login`.

---

## 3. Home (hub con Bottom Navigation)

Al entrar a `/home` se arma la navegación inferior según el rol:

| Tab | COACH | PLAYER |
|---|---|---|
| 0 — Inicio | ✔ TabInicioGenerico | ✔ TabInicioGenerico |
| 1 — Categorías / Mis Métricas | ✔ CoachDashboardScreen | ✔ PlayerDashboardScreen |
| 2 — Agenda | ✘ | ✔ MyAgendaScreen |

Pull-to-refresh en el hub invalida los providers de la pestaña activa (categorías o dashboard del jugador, y siempre la agenda).

### Tab Inicio
- Saludo con el nombre del usuario.
- Card fija de "Aviso Importante" (texto hardcodeado, no editable desde la UI todavía).
- Card dinámica según rol:
  - **COACH**: "Tu próximo compromiso" — recorre todas sus categorías y busca la actividad futura más cercana (sin importar si está confirmada).
  - **PLAYER**: "Tu próxima actividad confirmada" — busca, entre las actividades donde el jugador está citado, la más próxima en el tiempo cuya cita esté en estado `confirma`. Si no hay ninguna, la card no se muestra.

---

## 4. Agenda / Actividades (Datebook)

### 4.1 Ciclo de vida de una actividad

1. **Coach crea la actividad** desde `CreateActivityScreen` (accesible por FAB en `DatebookScreen` o en `CategoryPlayersScreen`).
   - Completa: título, tipo (entrenamiento / partido / evento), fecha y hora (date+time picker), lugar (opcional), indicaciones (opcional) y selecciona qué jugadores citar.
   - Al guardar: se crea la actividad y se insertan las citaciones de los jugadores seleccionados con estado `pendiente`.
   - Éxito: SnackBar verde, se invalida la agenda de la categoría y vuelve atrás.
   - Error: SnackBar rojo, permanece en el formulario.
2. **Jugador ve la actividad** en su pestaña "Agenda" (`MyAgendaScreen`), con un chip de color según su estado de citación:
   - Naranja = Pendiente
   - Verde = Confirmado
   - Rojo = No asiste
3. **Jugador responde** al tocar la actividad → `ActivityDetailScreen`, con dos botones: "Confirmar Asistencia" (verde) y "No Asistir" (rojo, outline).
   - Al responder: se actualiza la citación en Supabase, se invalidan la agenda de la categoría y "Mi Agenda", se muestra SnackBar verde "¡Respuesta guardada!" y se vuelve atrás automáticamente.
4. **Coach revisa respuestas** en `ActivityDashboardScreen` (al tocar la actividad desde `DatebookScreen`), con 3 tabs: Confirmados / Pendientes / No Asisten, cada uno listando los jugadores correspondientes.
5. **Coach edita la actividad** desde el botón de lápiz en `ActivityDashboardScreen` → reabre `CreateActivityScreen` en modo edición (no permite volver a elegir jugadores, solo editar los datos básicos).

### 4.2 Estados relevantes
- **Actividad** (`estado`): `borrador`, `publicada`, `cancelada`.
- **Citación** (`estadoRespuesta`): `pendiente`, `confirma`, `no_asiste`.

---

## 5. Evaluación de jugadores

### 5.1 Cómo evalúa el coach
1. Desde `CategoryPlayersScreen` (lista de jugadores de una categoría), el coach toca un jugador → `EvaluationFormScreen`.
2. Se cargan los stats actuales del jugador en esa categoría (valores 0–100: velocidad, resistencia, técnica, táctica, actitud, asistencia). Si el jugador no tiene stats previos, arrancan en 50 por defecto.
3. El coach mueve sliders para cada métrica y puede dejar un comentario.
4. Al guardar, la app calcula el **delta** (nuevo valor − valor anterior) por cada métrica y hace dos cosas en simultáneo:
   - Inserta un registro histórico en `evolucion_jugador` con los **deltas** (y el comentario).
   - Actualiza `jugador_categoria_stats` con los **valores absolutos** nuevos.
5. Éxito: SnackBar verde "¡Evaluación guardada con éxito!" y vuelve atrás. Error: SnackBar rojo.

### 5.2 Cómo el jugador ve sus métricas
1. `PlayerDashboardScreen` (tab "Mis Métricas") lista una card por cada categoría en la que tiene stats, con el promedio general y un mini-resumen de las 6 métricas.
2. Si no tiene stats en ninguna categoría, se muestra un mensaje: "Aún no tenés estadísticas. Tu entrenador debe evaluarte primero."
3. Al tocar una card, entra a `PlayerStatsChartScreen`: gráfico de barras (0–100) por métrica, más el detalle numérico y el promedio general.

---

## 6. Gestión de categorías y plantel (coach)

1. `CoachDashboardScreen` (tab "Categorías") lista las categorías donde el usuario es entrenador.
   - Vacío: "No tenés categorías asignadas."
2. Al tocar una categoría entra a `CategoryPlayersScreen`: lista de jugadores de esa categoría (nombre, posiciones, pierna hábil).
   - Icono de calendario en el AppBar lleva a la agenda de esa categoría (`DatebookScreen`).
   - FAB "Agendar" lleva a crear una actividad para esa categoría.
   - Tocar un jugador lleva al formulario de evaluación (`EvaluationFormScreen`).

---

## 7. Estados comunes en toda la app

- **Loading**: spinner centrado mientras se espera la respuesta de Supabase.
- **Error**: mensaje de texto o SnackBar rojo con el detalle del fallo.
- **Empty state**: mensaje explicativo cuando no hay datos (por ejemplo, sin categorías, sin actividades, sin estadísticas).
- **Feedback de acciones**: SnackBar verde en éxito, SnackBar rojo en error; casi siempre seguido de invalidar el/los providers relacionados para refrescar la data en pantalla.

---

## 8. Notas técnicas rápidas (para quien programe)

- Los "próximos" eventos (home, agenda) se calculan siempre comparando `fechaHora` contra `DateTime.now()` y quedándose con el mínimo entre los candidatos válidos — no se confía en el orden en que vienen los datos desde Supabase.
- Las mutaciones (crear actividad, responder citación, guardar evaluación) siempre invalidan los providers de lectura relacionados para forzar un refetch, en vez de actualizar el estado local a mano.
- Los stats de jugador se manejan con dos tablas: `jugador_categoria_stats` (valores absolutos actuales) y `evolucion_jugador` (histórico de deltas). Nunca se debe escribir un delta en la tabla de absolutos ni viceversa.

---

*Última actualización: 2026-08-31. Generado a partir de una exploración exhaustiva del código en `lib/features/`.*
