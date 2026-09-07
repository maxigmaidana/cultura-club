import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/trivia_entity.dart';
import '../providers/gamification_providers.dart';

class TriviaQuizView extends ConsumerStatefulWidget {
  final TriviaEntity trivia;
  final String jugadorId;

  const TriviaQuizView({
    super.key,
    required this.trivia,
    required this.jugadorId,
  });

  @override
  ConsumerState<TriviaQuizView> createState() => _TriviaQuizViewState();
}

class _TriviaQuizViewState extends ConsumerState<TriviaQuizView> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _selectedAnswers = {};
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    //TODO FALTA PROVIDER
    final preguntas = widget.trivia.preguntas;
    final currentPregunta = preguntas[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == preguntas.length - 1;
    final isAnswerSelected = _selectedAnswers.containsKey(currentPregunta.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: Text(widget.trivia.titulo),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // _ProgressIndicator(
          //   currentIndex: _currentQuestionIndex,
          //   totalQuestions: preguntas.length,
          //   totalPoints: widget.trivia.puntosTotales,
          // ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPregunta.pregunta,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AnswerOptions(
                    pregunta: currentPregunta,
                    selectedAnswerId: _selectedAnswers[currentPregunta.id],
                    onSelectAnswer: (opcionId) {
                      setState(() {
                        _selectedAnswers[currentPregunta.id] = opcionId;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          _NavigationButtons(
            isAnswerSelected: isAnswerSelected,
            isSubmitting: _isSubmitting,
            isLastQuestion: isLastQuestion,
            canGoPrevious: _currentQuestionIndex > 0,
            onNextQuestion: () {
              setState(() {
                if (_currentQuestionIndex < preguntas.length - 1) {
                  _currentQuestionIndex++;
                }
              });
            },
            onPreviousQuestion: () {
              setState(() {
                if (_currentQuestionIndex > 0) {
                  _currentQuestionIndex--;
                }
              });
            },
            onSubmit: () async {
              await _submitTrivia();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitTrivia() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final respuestas = _selectedAnswers.entries
          .map(
            (entry) => RespuestaEntity(
              preguntaId: entry.key,
              opcionElegidaId: entry.value,
            ),
          )
          .toList();

      final submitUseCase = ref.read(submitTriviaAnswersUseCaseProvider);
      final result = await submitUseCase(
        widget.trivia.id,
        widget.jugadorId,
        respuestas,
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isSubmitting = false;
          });
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Quiz completado con éxito!'),
              backgroundColor: Colors.green[700],
            ),
          );

          // ref.invalidate(pendingTriviasProvider(widget.jugadorId));
          // ref.invalidate(completedTriviasProvider(widget.jugadorId));
          // ref.invalidate(totalGameificationPointsProvider(widget.jugadorId));

          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              GoRouter.of(context).go('/home');
            }
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

/// Widget que muestra el indicador de progreso del quiz
class _ProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final int totalPoints;

  const _ProgressIndicator({
    required this.currentIndex,
    required this.totalQuestions,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pregunta ${currentIndex + 1} de $totalQuestions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Puntos: $totalPoints',
                style: TextStyle(
                  fontSize: 14,
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
              value: (currentIndex + 1) / totalQuestions,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.red[900]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar opciones de respuesta
class _AnswerOptions extends StatelessWidget {
  final PreguntaEntity pregunta;
  final String? selectedAnswerId;
  final Function(String) onSelectAnswer;

  const _AnswerOptions({
    required this.pregunta,
    required this.selectedAnswerId,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: pregunta.opciones.asMap().entries.map((entry) {
        final opcion = entry.value;
        final isSelected = selectedAnswerId == opcion;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GestureDetector(
            onTap: () => onSelectAnswer(opcion),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.red[900]! : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? Colors.red[50] : Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Colors.red[900]!
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? Colors.red[900] : Colors.white,
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opcion,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Widget para botones de navegación del quiz
class _NavigationButtons extends StatelessWidget {
  final bool isAnswerSelected;
  final bool isSubmitting;
  final bool isLastQuestion;
  final bool canGoPrevious;
  final VoidCallback onNextQuestion;
  final VoidCallback onPreviousQuestion;
  final VoidCallback onSubmit;

  const _NavigationButtons({
    required this.isAnswerSelected,
    required this.isSubmitting,
    required this.isLastQuestion,
    required this.canGoPrevious,
    required this.onNextQuestion,
    required this.onPreviousQuestion,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: !isAnswerSelected || isSubmitting
                  ? null
                  : () {
                      isLastQuestion ? onSubmit() : onNextQuestion();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isLastQuestion
                          ? 'Finalizar y Enviar'
                          : 'Siguiente Pregunta',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          if (canGoPrevious) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onPreviousQuestion,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red[900]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Anterior',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
