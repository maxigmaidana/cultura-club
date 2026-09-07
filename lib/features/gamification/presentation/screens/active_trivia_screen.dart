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

    return pendingTrivias.when(
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
          title: const Text('Quiz'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
          title: const Text('Error'),
        ),
        body: Center(child: Text('Error: $error')),
      ),
      data: (trivias) {
        TriviaEntity? trivia;
        try {
          trivia = trivias.firstWhere((t) => t.id == triviaId);
        } catch (e) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red[900],
              foregroundColor: Colors.white,
              title: const Text('Error'),
            ),
            body: const Center(child: Text('Trivia no encontrada')),
          );
        }

        return TriviaQuizView(trivia: trivia, jugadorId: jugadorId);
      },
    );
  }
}
