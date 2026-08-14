import 'package:cultura_club/features/evaluation/presentation/controllers/evaluation_controller.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/evaluation_entity.dart';

class EvaluationFormScreen extends ConsumerStatefulWidget {
  final String playerId;
  final String playerName;

  const EvaluationFormScreen({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  

  @override
  ConsumerState<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends ConsumerState<EvaluationFormScreen> {
  // Valores iniciales (por defecto todos arrancan en 5)
  double _velocidad = 5;
  double _resistencia = 5;
  double _tecnica = 5;
  double _tactica = 5;
  double _actitud = 5;
  double _asistencia = 5;
  
  final _comentariosController = TextEditingController();

  @override
  void dispose() {
    _comentariosController.dispose();
    super.dispose();
  }

  void _submit() {
    final currentUser = ref.read(userSessionProvider).value;
    if (currentUser == null) return;

    final evaluation = EvaluationEntity(
      jugadorId: widget.playerId,
      evaluadorId: currentUser.id,
      fechaEvaluacion: DateTime.now(),
      velocidad: _velocidad.toInt(),
      resistencia: _resistencia.toInt(),
      tecnica: _tecnica.toInt(),
      tactica: _tactica.toInt(),
      actitud: _actitud.toInt(),
      asistencia: _asistencia.toInt(),
      comentariosDt: _comentariosController.text.trim(),
    );

    ref.read(evaluationControllerProvider.notifier).submitEvaluation(evaluation);
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado del controlador para mostrar errores o cerrar la pantalla
    ref.listen<AsyncValue<void>>(
      evaluationControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar: $error'), backgroundColor: Colors.red),
            );
          },
          data: (_) {
            if (previous?.isLoading == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Evaluación guardada con éxito!'), backgroundColor: Colors.green),
              );
              Navigator.of(context).pop(); // Volvemos a la lista de jugadores
            }
          },
        );
      },
    );

    final evaluationState = ref.watch(evaluationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluar a ${widget.playerName}'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: evaluationState.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rendimiento (1 al 10)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  _buildSlider('Velocidad', _velocidad, (val) => setState(() => _velocidad = val)),
                  _buildSlider('Resistencia', _resistencia, (val) => setState(() => _resistencia = val)),
                  _buildSlider('Técnica', _tecnica, (val) => setState(() => _tecnica = val)),
                  _buildSlider('Táctica', _tactica, (val) => setState(() => _tactica = val)),
                  _buildSlider('Actitud', _actitud, (val) => setState(() => _actitud = val)),
                  _buildSlider('Asistencia', _asistencia, (val) => setState(() => _asistencia = val)),

                  const SizedBox(height: 24),
                  const Text('Comentarios (Opcional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _comentariosController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Ej: Mejoró mucho en la marca, pero falta definición...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _submit,
                      child: const Text('GUARDAR EVALUACIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  // Widget de ayuda para dibujar los sliders sin repetir tanto código
  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(value.toInt().toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9, // Para que salte de 1 en 1 exacto
          activeColor: Colors.red[900],
          inactiveColor: Colors.red[100],
          onChanged: onChanged,
        ),
      ],
    );
  }
}