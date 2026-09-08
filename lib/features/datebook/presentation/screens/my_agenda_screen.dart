import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/my_agenda_controller.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_detail_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarView { day, week, month }

class MyAgendaScreen extends ConsumerStatefulWidget {
  const MyAgendaScreen({super.key});

  @override
  ConsumerState<MyAgendaScreen> createState() => _MyAgendaScreenState();
}

class _MyAgendaScreenState extends ConsumerState<MyAgendaScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarView _view = CalendarView.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  String get _viewLabel {
    switch (_view) {
      case CalendarView.day:
        return 'Día';
      case CalendarView.week:
        return 'Semana';
      case CalendarView.month:
        return 'Mes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final agendaState = ref.watch(myAgendaControllerProvider);
    final currentUserId = ref.watch(userSessionProvider).value?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Agenda'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<CalendarView>(
            onSelected: (CalendarView result) {
              setState(() {
                _view = result;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CalendarView>>[
                  const PopupMenuItem<CalendarView>(
                    value: CalendarView.day,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20),
                        SizedBox(width: 12),
                        Text('Día'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<CalendarView>(
                    value: CalendarView.week,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_view_week, size: 20),
                        SizedBox(width: 12),
                        Text('Semana'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<CalendarView>(
                    value: CalendarView.month,
                    child: Row(
                      children: [
                        Icon(Icons.calendar_view_month, size: 20),
                        SizedBox(width: 12),
                        Text('Mes'),
                      ],
                    ),
                  ),
                ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      _view == CalendarView.day
                          ? Icons.calendar_today
                          : _view == CalendarView.week
                          ? Icons.calendar_view_week
                          : Icons.calendar_view_month,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _viewLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.red[900],
        onRefresh: () =>
            ref.read(myAgendaControllerProvider.notifier).refresh(),
        child: agendaState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (error, stack) =>
              Center(child: Text('Error al cargar tu agenda: $error')),
          data: (activities) {
            // Agrupar actividades por fecha
            final Map<DateTime, List<ActivityEntity>> activitiesByDate = {};
            for (final activity in activities) {
              final date = DateTime(
                activity.fechaHora.year,
                activity.fechaHora.month,
                activity.fechaHora.day,
              );
              activitiesByDate.putIfAbsent(date, () => []).add(activity);
            }

            // Actividades del día/semana/mes seleccionado según la vista
            final List<DateTime> daysToShow = _getDaysToShow();
            final selectedActivities = <ActivityEntity>[];

            for (final day in daysToShow) {
              selectedActivities.addAll(activitiesByDate[day] ?? []);
            }

            // Filtrar por usuario actual
            final myActivities = selectedActivities
                .where(
                  (a) => a.citaciones.any((c) => c.jugadorId == currentUserId),
                )
                .toList();

            return Column(
              children: [
                // Calendario según la vista
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020),
                      lastDay: DateTime.utc(2030),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarFormat: _getCalendarFormat(),
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Mes',
                        CalendarFormat.week: 'Semana',
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Colors.red[900],
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.red[200],
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.blue[900],
                          shape: BoxShape.circle,
                        ),
                        outsideTextStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.red[900],
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.red[900],
                        ),
                      ),
                      eventLoader: (day) {
                        final dateKey = DateTime(day.year, day.month, day.day);
                        return activitiesByDate[dateKey]
                                ?.where(
                                  (a) => a.citaciones.any(
                                    (c) => c.jugadorId == currentUserId,
                                  ),
                                )
                                .toList() ??
                            [];
                      },
                    ),
                  ),
                ),
                // Fecha/rango seleccionado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _getDateRangeText(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Actividades del período seleccionado
                Expanded(
                  child: myActivities.isEmpty
                      ? Center(
                          child: Text(
                            'No hay actividades en este período',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          itemCount: myActivities.length,
                          itemBuilder: (context, index) {
                            final activity = myActivities[index];
                            final myCitations = activity.citaciones.where(
                              (c) => c.jugadorId == currentUserId,
                            );
                            final myCitation = myCitations.isEmpty
                                ? null
                                : myCitations.first;
                            final estado = CitacionEstado.fromString(
                              myCitation?.estadoRespuesta,
                            );

                            return _AgendaCard(
                              activity: activity,
                              estado: estado,
                              onTap: () => GoRouter.of(context).push(
                                ActivityDetailScreen.buildPath(
                                  activity.categoriaId,
                                  activity.id,
                                ),
                                extra: activity,
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  CalendarFormat _getCalendarFormat() {
    switch (_view) {
      case CalendarView.day:
        return CalendarFormat.week; // No existe día, usamos semana
      case CalendarView.week:
        return CalendarFormat.week;
      case CalendarView.month:
        return CalendarFormat.month;
    }
  }

  List<DateTime> _getDaysToShow() {
    switch (_view) {
      case CalendarView.day:
        return [
          DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
        ];
      case CalendarView.week:
        // Obtener el inicio de la semana (lunes)
        final startOfWeek = _selectedDay.subtract(
          Duration(days: _selectedDay.weekday - 1),
        );
        return List.generate(
          7,
          (index) => startOfWeek.add(Duration(days: index)),
        );
      case CalendarView.month:
        // Solo el día seleccionado
        return [
          DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
        ];
    }
  }

  String _getDateRangeText() {
    switch (_view) {
      case CalendarView.day:
        return 'Hoy: ${formatActivityDate(_selectedDay)}';
      case CalendarView.week:
        final startOfWeek = _selectedDay.subtract(
          Duration(days: _selectedDay.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return 'Semana: ${startOfWeek.day}/${startOfWeek.month} - ${endOfWeek.day}/${endOfWeek.month}/${endOfWeek.year}';
      case CalendarView.month:
        return '${_getMonthName(_selectedDay.month)} ${_selectedDay.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }
}

class _AgendaCard extends StatelessWidget {
  final ActivityEntity activity;
  final CitacionEstado estado;
  final VoidCallback onTap;

  const _AgendaCard({
    required this.activity,
    required this.estado,
    required this.onTap,
  });

  Color get _estadoColor {
    switch (estado) {
      case CitacionEstado.confirma:
        return Colors.green[700]!;
      case CitacionEstado.noAsiste:
        return Colors.red[900]!;
      case CitacionEstado.pendiente:
        return Colors.orange[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoIcon = _getTipoIcon(activity.tipo);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(tipoIcon, color: Colors.blue[900], size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.tipo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _estadoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _estadoColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      estado.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _estadoColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.calendar_today,
                formatActivityDate(activity.fechaHora),
              ),
              if (activity.lugar != null && activity.lugar!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(Icons.place, activity.lugar!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  IconData _getTipoIcon(String tipo) {
    final tipoUpper = tipo.toUpperCase();
    if (tipoUpper.contains('PARTIDO')) return Icons.sports_soccer;
    if (tipoUpper.contains('ENTRENAMIENTO')) return Icons.fitness_center;
    if (tipoUpper.contains('EVENTO')) return Icons.event;
    return Icons.calendar_today;
  }
}
