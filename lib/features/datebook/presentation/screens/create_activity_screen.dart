import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccioná fecha y hora')));
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al ${_isEditing ? "editar" : "crear"} la actividad: ${failure.message}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        // Se refetchea recién cuando algo vuelva a mirar la lista de esta categoría
        ref.invalidate(datebookProvider(widget.categoriaId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? '¡Actividad actualizada!' : '¡Actividad creada!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        GoRouter.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Actividad' : 'Nueva Actividad'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'El título es obligatorio'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ActivityTipo>(
              initialValue: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: ActivityTipo.values
                  .map(
                    (tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _tipo = value);
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDateTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha y hora',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
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
              decoration: const InputDecoration(
                labelText: 'Lugar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _indicacionesController,
              decoration: const InputDecoration(
                labelText: 'Indicaciones',
                border: OutlineInputBorder(),
              ),
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
                selectedPlayerIds: _selectedPlayerIds,
                onChanged: (ids) => setState(() {
                  _selectedPlayerIds
                    ..clear()
                    ..addAll(ids);
                }),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  foregroundColor: Colors.white,
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_isEditing ? 'Guardar Cambios' : 'Crear Actividad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RosterPicker extends ConsumerWidget {
  final String categoriaId;
  final Set<String> selectedPlayerIds;
  final ValueChanged<Set<String>> onChanged;

  const _RosterPicker({
    required this.categoriaId,
    required this.selectedPlayerIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(rosterControllerProvider(categoriaId));

    return rosterState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator(color: Colors.red)),
      ),
      error: (error, stack) => Text(
        'Error al cargar el plantel: $error',
        style: const TextStyle(color: Colors.red),
      ),
      data: (roster) {
        if (roster.isEmpty) {
          return const Text(
            'No hay jugadores en esta categoría.',
            style: TextStyle(color: Colors.grey),
          );
        }

        final allSelected = selectedPlayerIds.length == roster.length;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text(
                  'Seleccionar todos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                activeColor: Colors.red[900],
                value: allSelected,
                onChanged: (checked) {
                  onChanged(
                    checked == true ? roster.map((p) => p.userId).toSet() : {},
                  );
                },
              ),
              const Divider(height: 1),
              ...roster.map(
                (player) => CheckboxListTile(
                  title: Text(player.fullName),
                  activeColor: Colors.red[900],
                  value: selectedPlayerIds.contains(player.userId),
                  onChanged: (checked) {
                    final updated = Set<String>.from(selectedPlayerIds);
                    if (checked == true) {
                      updated.add(player.userId);
                    } else {
                      updated.remove(player.userId);
                    }
                    onChanged(updated);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
