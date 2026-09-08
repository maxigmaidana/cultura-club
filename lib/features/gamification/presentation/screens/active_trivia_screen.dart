import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/trivia_entity.dart';
import '../providers/gamification_providers.dart';
import '../widgets/trivia_quiz_view.dart';

class ActiveTriviaScreen extends ConsumerWidget {
  final String triviaId;
  final String jugadorId;

  const ActiveTriviaScreen({
    super.key,
    required this.triviaId,
    required this.jugadorId,
  });

  static const String pathName = '/active-trivia';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingTrivias = ref.watch(pendingTriviasProvider(jugadorId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: const Text('Quiz'),
      ),
      body: pendingTrivias.when(
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Colors.red[900]),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando quiz...',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red[900],
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar el quiz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$error',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (trivias) {
          TriviaEntity? trivia;
          try {
            trivia = trivias.firstWhere((t) => t.id == triviaId);
          } catch (e) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.orange[800],
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Quiz no encontrado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'El quiz que buscas no está disponible',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return TriviaQuizView(trivia: trivia, jugadorId: jugadorId);
        },
      ),
    );
  }
}
