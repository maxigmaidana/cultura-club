import 'package:cultura_club/core/theme/widgets/app_card.dart';
import 'package:cultura_club/core/theme/widgets/app_linear_stat_bar.dart';
import 'package:cultura_club/core/theme/widgets/app_score_ring.dart';
import 'package:cultura_club/features/evaluation/domain/entities/player_stats_entity.dart';
import 'package:flutter/material.dart';

class PlayerStatsChartScreen extends StatelessWidget {
  final PlayerStatsEntity stats;

  const PlayerStatsChartScreen({super.key, required this.stats});

  static const String pathName = '/player/stats-chart/:categoriaId';
  static String buildPath(String categoriaId) =>
      '/player/stats-chart/$categoriaId';

  @override
  Widget build(BuildContext context) {
    final average = _calculateAverage();

    return Scaffold(
      appBar: AppBar(title: Text(stats.categoriaNombre ?? 'Estadísticas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Análisis de Habilidades',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                children: [
                  AppLinearStatBar(label: 'Velocidad', value: stats.velocidad),
                  const SizedBox(height: 16),
                  AppLinearStatBar(
                    label: 'Resistencia',
                    value: stats.resistencia,
                  ),
                  const SizedBox(height: 16),
                  AppLinearStatBar(label: 'Técnica', value: stats.tecnica),
                  const SizedBox(height: 16),
                  AppLinearStatBar(label: 'Táctica', value: stats.tactica),
                  const SizedBox(height: 16),
                  AppLinearStatBar(label: 'Actitud', value: stats.actitud),
                  const SizedBox(height: 16),
                  AppLinearStatBar(
                    label: 'Asistencia',
                    value: stats.asistencia,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: AppScoreRing(
                  value: average / 100,
                  centerLabel: average.round().toString(),
                  subtitle: _encouragementFor(average),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  double _calculateAverage() {
    return (stats.velocidad +
            stats.resistencia +
            stats.tecnica +
            stats.tactica +
            stats.actitud +
            stats.asistencia) /
        6;
  }

  String _encouragementFor(double average) {
    if (average >= 85) {
      return '¡Excelente trabajo! Estás manteniendo un nivel alto en la mayoría de tus habilidades.';
    }
    if (average >= 70) {
      return 'Buen nivel general. Seguí trabajando para destacar en todas las áreas.';
    }
    return 'Hay margen de mejora. Enfocate en tus próximos entrenamientos.';
  }
}

