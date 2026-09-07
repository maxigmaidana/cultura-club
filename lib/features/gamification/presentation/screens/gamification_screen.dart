import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/gamification_providers.dart';

class GamificationScreen extends ConsumerWidget {
  final String jugadorId;

  const GamificationScreen({super.key, required this.jugadorId});

  static const String pathName = '/gamification';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPoints = ref.watch(totalGameificationPointsProvider(jugadorId));
    final pendingTrivias = ref.watch(pendingTriviasProvider(jugadorId));
    final completedTrivias = ref.watch(completedTriviasProvider(jugadorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamificación'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(totalGameificationPointsProvider(jugadorId).future),
            ref.refresh(pendingTriviasProvider(jugadorId).future),
            ref.refresh(completedTriviasProvider(jugadorId).future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Tarjeta de Puntaje Total
            totalPoints.when(
              loading: () => _buildPointsCardSkeleton(),
              error: (error, stackTrace) => _buildPointsCardError(),
              data: (points) => _buildPointsCard(points),
            ),
            const SizedBox(height: 24),

            // Sección de Quizzes Pendientes
            Text(
              'Quizzes Pendientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 12),
            pendingTrivias.when(
              loading: () => const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
              error: (error, stackTrace) => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  'Error al cargar: $error',
                  style: TextStyle(color: Colors.red[900]),
                ),
              ),
              data: (trivias) {
                if (trivias.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        'No hay quizzes pendientes',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  );
                }

                return Column(
                  children: trivias.asMap().entries.map((entry) {
                    final index = entry.key;
                    final trivia = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < trivias.length - 1 ? 12.0 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.push(
                            '/active-trivia/${trivia.id}/$jugadorId',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange[200]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.orange[50],
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.orange[900],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.quiz,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trivia.titulo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Text(
                                    //   '${trivia.preguntas.length} preguntas • ${trivia.puntosTotales} puntos',
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.grey[600],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 32),

            // Sección de Historial
            Text(
              'Historial de Quizzes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 12),
            completedTrivias.when(
              loading: () => const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
              error: (error, stackTrace) => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  'Error al cargar: $error',
                  style: TextStyle(color: Colors.red[900]),
                ),
              ),
              data: (completed) {
                if (completed.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        'Aún no has completado ningún quiz',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  );
                }

                return Column(
                  children: completed.asMap().entries.map((entry) {
                    final index = entry.key;
                    final trivia = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < completed.length - 1 ? 12.0 : 0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green[200]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green[50],
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trivia.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${trivia.puntosObtenidos} puntos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _formatDate(trivia.respondidoAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard(int points) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[900]!, Colors.red[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red[900]!.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Puntuación Total',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                points.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.star, color: Colors.yellow[300], size: 40),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Sigue respondiendo quizzes para aumentar tu puntuación',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24.0),
      height: 150,
      child: const Center(child: CircularProgressIndicator(color: Colors.red)),
    );
  }

  Widget _buildPointsCardError() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          'Error al cargar puntuación',
          style: TextStyle(color: Colors.red[900], fontSize: 14),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
