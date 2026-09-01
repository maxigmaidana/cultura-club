import 'package:cultura_club/features/evaluation/presentation/controllers/evaluation_controller.dart';
import 'package:cultura_club/features/evaluation/presentation/controllers/player_stats_controller.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/evaluation_entity.dart';
import '../../domain/entities/player_stats_entity.dart';

class EvaluationFormScreen extends ConsumerStatefulWidget {
  final String playerId;
  final String playerName;
  final String categoryId;

  const EvaluationFormScreen({
    super.key,
    required this.playerId,
    required this.playerName,
    required this.categoryId,
  });

  static const String pathName =
      '/coach/category/:categoryId/evaluate/:playerId';
  static String buildPath(String categoryId, String playerId) =>
      '/coach/category/$categoryId/evaluate/$playerId';

  @override
  ConsumerState<EvaluationFormScreen> createState() =>
      _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends ConsumerState<EvaluationFormScreen> {
  // Stats actuales (0-100), inicializados cuando se cargan los datos
  double? _velocidad;
  double? _resistencia;
  double? _tecnica;
  double? _tactica;
  double? _actitud;
  double? _asistencia;

  // Stats originales para calcular el delta
  PlayerStatsEntity? _originalStats;

  // Flag para saber si ya inicializamos en este ciclo
  bool _isInitialized = false;

  final _comentariosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Invalidamos el provider para forzar un fetch fresco de datos
    Future.microtask(() {
      ref.invalidate(
        playerStatsControllerProvider(widget.playerId, widget.categoryId),
      );
    });
    // Reseteamos el flag de inicialización
    _isInitialized = false;
  }

  @override
  void dispose() {
    _comentariosController.dispose();
    super.dispose();
  }

  void _initializeStats(PlayerStatsEntity stats) {
    // Solo inicializamos una vez por ciclo de vida del widget
    if (!_isInitialized) {
      setState(() {
        _originalStats = stats;
        _velocidad = stats.velocidad.toDouble();
        _resistencia = stats.resistencia.toDouble();
        _tecnica = stats.tecnica.toDouble();
        _tactica = stats.tactica.toDouble();
        _actitud = stats.actitud.toDouble();
        _asistencia = stats.asistencia.toDouble();
        _isInitialized = true;
      });
    }
  }

  void _submit() {
    if (_originalStats == null || _velocidad == null) return;

    final currentUser = ref.read(userSessionProvider).value;
    if (currentUser == null) return;

    // Calculamos los DELTAS (nuevo - original)
    final deltaVelocidad = _velocidad!.toInt() - _originalStats!.velocidad;
    final deltaResistencia =
        _resistencia!.toInt() - _originalStats!.resistencia;
    final deltaTecnica = _tecnica!.toInt() - _originalStats!.tecnica;
    final deltaTactica = _tactica!.toInt() - _originalStats!.tactica;
    final deltaActitud = _actitud!.toInt() - _originalStats!.actitud;
    final deltaAsistencia = _asistencia!.toInt() - _originalStats!.asistencia;

    // Creamos la entidad DELTA
    final deltaEvaluation = EvaluationEntity(
      jugadorId: widget.playerId,
      categoriaId: widget.categoryId,
      evaluadorId: currentUser.id,
      fechaEvaluacion: DateTime.now(),
      velocidad: deltaVelocidad,
      resistencia: deltaResistencia,
      tecnica: deltaTecnica,
      tactica: deltaTactica,
      actitud: deltaActitud,
      asistencia: deltaAsistencia,
      comentariosDt: _comentariosController.text.trim(),
    );

    // Creamos la entidad de STATS ABSOLUTOS (nuevos valores)
    final newStats = PlayerStatsEntity(
      jugadorId: widget.playerId,
      categoriaId: widget.categoryId,
      velocidad: _velocidad!.toInt(),
      resistencia: _resistencia!.toInt(),
      tecnica: _tecnica!.toInt(),
      tactica: _tactica!.toInt(),
      actitud: _actitud!.toInt(),
      asistencia: _asistencia!.toInt(),
    );

    ref
        .read(evaluationControllerProvider.notifier)
        .submitEvaluation(deltaEvaluation, newStats);
  }

  @override
  Widget build(BuildContext context) {
    // Cargamos los stats actuales del jugador en esta categoría
    final statsState = ref.watch(
      playerStatsControllerProvider(widget.playerId, widget.categoryId),
    );

    // Escuchamos el estado del controlador para mostrar errores o cerrar la pantalla
    ref.listen<AsyncValue<void>>(evaluationControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Evaluación guardada con éxito!'),
                backgroundColor: Colors.green,
              ),
            );
            GoRouter.of(context).pop(); // Volvemos a la lista de jugadores
          }
        },
      );
    });

    final evaluationState = ref.watch(evaluationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluar a ${widget.playerName}'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: statsState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[900]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar stats: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (stats) {
          // Inicializamos los sliders con los valores actuales
          _initializeStats(stats);

          if (_velocidad == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          return evaluationState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stats del Jugador (0-100)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildSlider(
                        'Velocidad',
                        _velocidad!,
                        (val) => setState(() => _velocidad = val),
                      ),
                      _buildSlider(
                        'Resistencia',
                        _resistencia!,
                        (val) => setState(() => _resistencia = val),
                      ),
                      _buildSlider(
                        'Técnica',
                        _tecnica!,
                        (val) => setState(() => _tecnica = val),
                      ),
                      _buildSlider(
                        'Táctica',
                        _tactica!,
                        (val) => setState(() => _tactica = val),
                      ),
                      _buildSlider(
                        'Actitud',
                        _actitud!,
                        (val) => setState(() => _actitud = val),
                      ),
                      _buildSlider(
                        'Asistencia',
                        _asistencia!,
                        (val) => setState(() => _asistencia = val),
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'Comentarios (Opcional)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _comentariosController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Ej: Mejoró mucho en la marca, pero falta definición...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text(
                            'GUARDAR EVALUACIÓN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
        },
      ),
    );
  }

  // Widget de ayuda para dibujar los sliders sin repetir tanto código
  Widget _buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    final int delta = _originalStats != null
        ? value.toInt() - _getOriginalValue(label)
        : 0;
    final String deltaText = delta > 0
        ? '+$delta'
        : delta < 0
        ? '$delta'
        : '±0';
    final Color deltaColor = delta > 0
        ? Colors.green
        : delta < 0
        ? Colors.red
        : Colors.grey;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: deltaColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    deltaText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: deltaColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          activeColor: Colors.red[900],
          inactiveColor: Colors.red[100],
          onChanged: onChanged,
        ),
      ],
    );
  }

  int _getOriginalValue(String label) {
    if (_originalStats == null) return 50;
    switch (label) {
      case 'Velocidad':
        return _originalStats!.velocidad;
      case 'Resistencia':
        return _originalStats!.resistencia;
      case 'Técnica':
        return _originalStats!.tecnica;
      case 'Táctica':
        return _originalStats!.tactica;
      case 'Actitud':
        return _originalStats!.actitud;
      case 'Asistencia':
        return _originalStats!.asistencia;
      default:
        return 50;
    }
  }
}
