import 'package:cultura_club/features/evaluation/domain/entities/player_stats_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PlayerStatsChartScreen extends StatelessWidget {
  final PlayerStatsEntity stats;

  const PlayerStatsChartScreen({super.key, required this.stats});

  static const String pathName = '/player/stats-chart/:categoriaId';
  static String buildPath(String categoriaId) =>
      '/player/stats-chart/$categoriaId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stats.categoriaNombre ?? 'Estadísticas'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con promedio general
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.red[900], size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Promedio General',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _calculateAverage().toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Título del gráfico
            const Text(
              'Estadísticas Detalladas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Gráfico de barras
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.black87,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${_getStatLabel(groupIndex)}\\n${rod.toY.toInt()}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _getStatLabel(value.toInt()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 25,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300],
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                          left: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                      ),
                      barGroups: [
                        _buildBarGroup(0, stats.velocidad.toDouble()),
                        _buildBarGroup(1, stats.resistencia.toDouble()),
                        _buildBarGroup(2, stats.tecnica.toDouble()),
                        _buildBarGroup(3, stats.tactica.toDouble()),
                        _buildBarGroup(4, stats.actitud.toDouble()),
                        _buildBarGroup(5, stats.asistencia.toDouble()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lista detallada de stats
            const Text(
              'Valores Numéricos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Velocidad', stats.velocidad),
            _buildStatRow('Resistencia', stats.resistencia),
            _buildStatRow('Técnica', stats.tecnica),
            _buildStatRow('Táctica', stats.tactica),
            _buildStatRow('Actitud', stats.actitud),
            _buildStatRow('Asistencia', stats.asistencia),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: Colors.red[900],
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  String _getStatLabel(int index) {
    switch (index) {
      case 0:
        return 'VEL';
      case 1:
        return 'RES';
      case 2:
        return 'TEC';
      case 3:
        return 'TAC';
      case 4:
        return 'ACT';
      case 5:
        return 'ASI';
      default:
        return '';
    }
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

  Widget _buildStatRow(String label, int value) {
    final percentage = value / 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[900]!),
            ),
          ),
        ],
      ),
    );
  }
}
