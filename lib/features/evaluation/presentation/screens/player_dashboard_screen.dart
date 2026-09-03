import 'package:cultura_club/core/theme/widgets/app_card.dart';
import 'package:cultura_club/core/theme/widgets/app_header_bar.dart';
import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultura_club/features/evaluation/presentation/controllers/player_dashboard_controller.dart';
import 'package:cultura_club/features/evaluation/presentation/screens/player_stats_chart_screen.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlayerDashboardScreen extends ConsumerWidget {
  final UserEntity user;

  const PlayerDashboardScreen({super.key, required this.user});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(signOutUseCaseProvider)();
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cerrar sesión: ${failure.message}')),
        );
      },
      (_) {
        ref.read(userSessionProvider.notifier).clearUser();
        if (context.mounted) GoRouter.of(context).go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado de las stats del jugador
    final statsState = ref.watch(playerDashboardControllerProvider);

    return Scaffold(
      appBar: AppHeaderBar(
        title: 'Mis Métricas',
        avatarInitial: user.fullName.isEmpty ? '?' : user.fullName[0].toUpperCase(),
        showLogout: true,
        onLogout: () => _signOut(context, ref),
      ),
      body: statsState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[900]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar estadísticas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        data: (statsList) {
          if (statsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Aún no tenés estadísticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu entrenador debe evaluarte primero',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: statsList.length,
            itemBuilder: (context, index) {
              final stats = statsList[index];

              // Calculamos el promedio de stats
              final avgStats =
                  (stats.velocidad +
                      stats.resistencia +
                      stats.tecnica +
                      stats.tactica +
                      stats.actitud +
                      stats.asistencia) /
                  6;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppCard(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      GoRouter.of(context).push(
                        PlayerStatsChartScreen.buildPath(stats.categoriaId),
                        extra: stats,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.groups,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stats.categoriaNombre ?? 'Sin categoría',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Promedio: ${avgStats.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.red[900],
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Mini preview de stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMiniStat('VEL', stats.velocidad),
                            _buildMiniStat('RES', stats.resistencia),
                            _buildMiniStat('TEC', stats.tecnica),
                            _buildMiniStat('TAC', stats.tactica),
                            _buildMiniStat('ACT', stats.actitud),
                            _buildMiniStat('ASI', stats.asistencia),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMiniStat(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red[900],
          ),
        ),
      ],
    );
  }
}
