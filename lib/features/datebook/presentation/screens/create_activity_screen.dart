import 'dart:developer';

import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/core/enums/player_enums.dart';
import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/core/presentation/widgets/exports.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/domain/entities/roster_player_for_activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/activity_roster_controller.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/coach_commitments_controller.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/providers/datebook_providers.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateActivityScreen extends ConsumerStatefulWidget {
  final String categoriaId;
  final ActivityEntity? existingActivity;

  const CreateActivityScreen({
    super.key,
    required this.categoriaId,
    this.existingActivity,
  });

  static String buildPath(String categoriaId) =>
      '/datebook/$categoriaId/create';

  static String buildEditPath(String categoriaId, String activityId) =>
      '/datebook/$categoriaId/activity/$activityId/edit';

  @override
  ConsumerState<CreateActivityScreen> createState() =>
      _CreateActivityScreenState();
}

class _CreateActivityScreenState extends ConsumerState<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _lugarController = TextEditingController();
  final _indicacionesController = TextEditingController();

  ActivityTipo _tipo = ActivityTipo.entrenamiento;
  DateTime? _fechaHora;
  bool _isSubmitting = false;
  final Set<String> _selectedPlayerIds = {};

  bool get _isEditing => widget.existingActivity != null;

  @override
  void initState() {
    super.initState();
    final activity = widget.existingActivity;
    if (activity != null) {
      _tituloController.text = activity.titulo;
      _lugarController.text = activity.lugar ?? '';
      _indicacionesController.text = activity.indicaciones ?? '';
      _tipo = ActivityTipo.fromString(activity.tipo);
      _fechaHora = activity.fechaHora;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _lugarController.dispose();
    _indicacionesController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[900]!, width: 2),
      ),
    );
  }

  Set<String> _buildEligiblePlayerIds(
    List<RosterPlayerForActivityEntity> roster,
    ActivityTipo tipo,
  ) {
    switch (tipo) {
      case ActivityTipo.partido:
        return roster
            .where((player) => player.canPlay)
            .map((player) => player.userId)
            .toSet();
      case ActivityTipo.entrenamiento:
        return roster
            .where((player) => player.canTrain)
            .map((player) => player.userId)
            .toSet();
      case ActivityTipo.evento:
        return roster.map((player) => player.userId).toSet();
    }
  }

  void _syncSelectionWithActivityType(
    List<RosterPlayerForActivityEntity> roster,
    ActivityTipo tipo,
  ) {
    if (tipo == ActivityTipo.evento) return;

    final eligibleIds = _buildEligiblePlayerIds(roster, tipo);
    final toRemove = _selectedPlayerIds
        .where((playerId) => !eligibleIds.contains(playerId))
        .toList();

    if (toRemove.isEmpty) return;

    setState(() {
      _selectedPlayerIds.removeAll(toRemove);
    });

    if (!mounted) return;
    AppSnackBar.show(
      context,
      AppSnackBarType.info,
      'Se quitaron jugadores que no estan disponibles para este tipo de actividad.',
    );
  }

  String _buildCreateActivityErrorMessage(Failure failure) {
    final normalized = '${failure.code ?? ''} ${failure.message}'.toUpperCase();

    if (normalized.contains('ROSTER_CONTAINS_UNAVAILABLE_PLAYERS') ||
        normalized.contains('PLAYER_NOT_AVAILABLE_FOR_MATCH')) {
      return 'Uno o mas jugadores seleccionados ya no estan disponibles para este partido. Revisa la convocatoria e intenta nuevamente.';
    }

    if (normalized.contains('ROSTER_CONTAINS_UNAVAILABLE_TRAINING_PLAYERS') ||
        normalized.contains('PLAYER_NOT_AVAILABLE_FOR_TRAINING')) {
      return 'Uno o mas jugadores ya no estan disponibles para entrenar. Revisa la convocatoria e intenta nuevamente.';
    }

    return 'Error al crear la actividad: ${failure.message}';
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _fechaHora ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fechaHora ?? now),
    );
    if (time == null) return;

    setState(() {
      _fechaHora = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaHora == null) {
      AppSnackBar.show(
        context,
        AppSnackBarType.error,
        'Seleccioná fecha y hora',
      );
      return;
    }

    final currentUser = ref.read(userSessionProvider).value;
    if (currentUser == null) return;

    setState(() => _isSubmitting = true);

    final titulo = _tituloController.text.trim();
    final lugar = _lugarController.text.trim().isEmpty
        ? null
        : _lugarController.text.trim();
    final indicaciones = _indicacionesController.text.trim().isEmpty
        ? null
        : _indicacionesController.text.trim();

    final result = _isEditing
        ? await ref.read(updateActivityUseCaseProvider)(
            actividadId: widget.existingActivity!.id,
            tipo: _tipo.value,
            titulo: titulo,
            fechaHora: _fechaHora!,
            lugar: lugar,
            indicaciones: indicaciones,
          )
        : await ref.read(createActivityUseCaseProvider)(
            categoriaId: widget.categoriaId,
            creadorId: currentUser.id,
            tipo: _tipo.value,
            titulo: titulo,
            fechaHora: _fechaHora!,
            lugar: lugar,
            indicaciones: indicaciones,
            jugadorIds: _selectedPlayerIds.toList(),
          );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        if (!_isEditing) {
          log(
            'Create activity failure: code=${failure.code}, message=${failure.message}',
          );
        }

        AppSnackBar.show(
          context,
          AppSnackBarType.error,
          _isEditing
              ? 'Error al editar la actividad: ${failure.message}'
              : _buildCreateActivityErrorMessage(failure),
        );
      },
      (_) {
        // Se refetchea recién cuando algo vuelva a mirar la lista de esta categoría
        ref.invalidate(datebookProvider(widget.categoriaId));
        ref.invalidate(coachCommitmentsControllerProvider);
        AppSnackBar.show(
          context,
          AppSnackBarType.success,
          _isEditing ? '¡Actividad actualizada!' : '¡Actividad creada!',
        );
        GoRouter.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<RosterPlayerForActivityEntity>>>(
      activityRosterControllerProvider(widget.categoriaId),
      (_, next) {
        if (_isEditing || !next.hasValue) return;
        _syncSelectionWithActivityType(next.requireValue, _tipo);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Actividad' : 'Nueva Actividad'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0).copyWith(bottom: 40.0),
          children: [
            DropdownButtonFormField<ActivityTipo>(
              initialValue: _tipo,
              decoration: _buildInputDecoration('Tipo'),
              items: ActivityTipo.values
                  .map(
                    (tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() => _tipo = value);

                if (!_isEditing) {
                  final rosterState = ref.read(
                    activityRosterControllerProvider(widget.categoriaId),
                  );
                  if (rosterState.hasValue) {
                    _syncSelectionWithActivityType(
                      rosterState.requireValue,
                      value,
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tituloController,
              decoration: _buildInputDecoration('Título'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'El título es obligatorio'
                  : null,
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: _pickDateTime,
              child: InputDecorator(
                decoration: _buildInputDecoration(
                  'Fecha y hora',
                ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                child: Text(
                  _fechaHora == null
                      ? 'Seleccionar fecha y hora'
                      : _fechaHora.toString(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lugarController,
              decoration: _buildInputDecoration('Lugar'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _indicacionesController,
              decoration: _buildInputDecoration('Indicaciones'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            if (!_isEditing) ...[
              const Text(
                'Citar a jugadores',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _RosterPicker(
                categoriaId: widget.categoriaId,
                activityType: _tipo,
                selectedPlayerIds: _selectedPlayerIds,
                onChanged: (ids) => setState(() {
                  _selectedPlayerIds
                    ..clear()
                    ..addAll(ids);
                }),
              ),
            ],
            const SizedBox(height: 32),
            AppButton(
              onPressed: _isSubmitting ? null : _submit,
              label: _isEditing ? 'Guardar Cambios' : 'Crear Actividad',
              type: AppButtonType.primary,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

class _RosterPicker extends ConsumerWidget {
  final String categoriaId;
  final ActivityTipo activityType;
  final Set<String> selectedPlayerIds;
  final ValueChanged<Set<String>> onChanged;

  const _RosterPicker({
    required this.categoriaId,
    required this.activityType,
    required this.selectedPlayerIds,
    required this.onChanged,
  });

  bool _isSelectable(RosterPlayerForActivityEntity player) {
    switch (activityType) {
      case ActivityTipo.partido:
        return player.canPlay;
      case ActivityTipo.entrenamiento:
        return player.canTrain;
      case ActivityTipo.evento:
        return true;
    }
  }

  Set<String> _eligiblePlayerIds(List<RosterPlayerForActivityEntity> roster) {
    return roster.where(_isSelectable).map((player) => player.userId).toSet();
  }

  Map<SectorCancha, List<RosterPlayerForActivityEntity>> _groupBySector(
    List<RosterPlayerForActivityEntity> roster,
  ) {
    final grouped = <SectorCancha, List<RosterPlayerForActivityEntity>>{
      for (final sector in SectorCancha.values)
        sector: <RosterPlayerForActivityEntity>[],
    };

    for (final player in roster) {
      grouped[player.sectorCancha]!.add(player);
    }

    return grouped;
  }

  String? _availabilityMessage(RosterPlayerForActivityEntity player) {
    switch (activityType) {
      case ActivityTipo.partido:
        if (player.canPlay) return null;
        return player.hasRecoveringInjury
            ? 'No disponible para jugar. En recuperacion.'
            : 'No disponible para jugar';
      case ActivityTipo.entrenamiento:
        if (player.canTrain) return null;
        return 'No disponible para entrenar';
      case ActivityTipo.evento:
        return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(
      activityRosterControllerProvider(categoriaId),
    );

    return rosterState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      ),
      error: (error, stack) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error al cargar el plantel: $error',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              ref
                  .read(activityRosterControllerProvider(categoriaId).notifier)
                  .retry();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
      data: (roster) {
        if (roster.isEmpty) {
          return const Text(
            'No hay jugadores en esta categoría.',
            style: TextStyle(color: Colors.grey),
          );
        }

        final eligibleIds = _eligiblePlayerIds(roster);

        final allSelected =
            eligibleIds.isNotEmpty &&
            eligibleIds.every(selectedPlayerIds.contains);

        final grouped = _groupBySector(roster);
        final nonEmptyGroups = grouped.entries
            .where(
              (
                MapEntry<SectorCancha, List<RosterPlayerForActivityEntity>>
                entry,
              ) => entry.value.isNotEmpty,
            )
            .toList();

        return Column(
          children: [
            // Card para "Seleccionar todos"
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CheckboxListTile(
                title: const Text(
                  'Seleccionar todos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                activeColor: Colors.red[900],
                value: allSelected,
                onChanged: (checked) {
                  onChanged(checked == true ? eligibleIds : <String>{});
                },
              ),
            ),
            const SizedBox(height: 16),
            // Cards por sector
            ...nonEmptyGroups.map((
              MapEntry<SectorCancha, List<RosterPlayerForActivityEntity>> entry,
            ) {
              final SectorCancha sector = entry.key;
              final List<RosterPlayerForActivityEntity> players = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          sector.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ...players.map((RosterPlayerForActivityEntity player) {
                        final isSelectable = _isSelectable(player);
                        final availabilityMessage = _availabilityMessage(
                          player,
                        );
                        final availabilityColor = Colors.orange[800];

                        return CheckboxListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: player.posiciones
                                    .map(
                                      (Posicion posicion) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: Colors.blue[200]!,
                                          ),
                                        ),
                                        child: Text(
                                          posicion.name.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              if (availabilityMessage != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  availabilityMessage,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: availabilityColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          activeColor: Colors.red[900],
                          value: selectedPlayerIds.contains(player.userId),
                          onChanged: isSelectable
                              ? (checked) {
                                  final updated = Set<String>.from(
                                    selectedPlayerIds,
                                  );
                                  if (checked == true) {
                                    updated.add(player.userId);
                                  } else {
                                    updated.remove(player.userId);
                                  }
                                  onChanged(updated);
                                }
                              : null,
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
