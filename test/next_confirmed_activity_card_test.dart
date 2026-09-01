import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/domain/entities/citation_entity.dart';
import 'package:cultura_club/features/home/presentation/widgets/next_confirmed_activity_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('findClosestConfirmedActivity', () {
    test('returns the confirmed activity with the nearest future date', () {
      final now = DateTime(2026, 8, 31, 12, 0, 0);
      final activities = [
        ActivityEntity(
          id: '1',
          categoriaId: 'c1',
          creadorId: 'u1',
          tipo: 'entrenamiento',
          titulo: 'Lejana',
          fechaHora: now.add(const Duration(days: 20)),
          estado: 'publicada',
          citaciones: [
            CitationEntity(
              id: 'c1',
              actividadId: '1',
              jugadorId: 'user-1',
              estadoRespuesta: 'confirma',
            ),
          ],
        ),
        ActivityEntity(
          id: '2',
          categoriaId: 'c1',
          creadorId: 'u1',
          tipo: 'partido',
          titulo: 'Más cercana',
          fechaHora: now.add(const Duration(days: 2)),
          estado: 'publicada',
          citaciones: [
            CitationEntity(
              id: 'c2',
              actividadId: '2',
              jugadorId: 'user-1',
              estadoRespuesta: 'confirma',
            ),
          ],
        ),
        ActivityEntity(
          id: '3',
          categoriaId: 'c1',
          creadorId: 'u1',
          tipo: 'evento',
          titulo: 'No confirmada',
          fechaHora: now.add(const Duration(days: 1)),
          estado: 'publicada',
          citaciones: [
            CitationEntity(
              id: 'c3',
              actividadId: '3',
              jugadorId: 'user-1',
              estadoRespuesta: 'pendiente',
            ),
          ],
        ),
        ActivityEntity(
          id: '4',
          categoriaId: 'c1',
          creadorId: 'u1',
          tipo: 'entrenamiento',
          titulo: 'Pasada',
          fechaHora: now.subtract(const Duration(days: 1)),
          estado: 'publicada',
          citaciones: [
            CitationEntity(
              id: 'c4',
              actividadId: '4',
              jugadorId: 'user-1',
              estadoRespuesta: 'confirma',
            ),
          ],
        ),
      ];

      final result = findClosestConfirmedActivity(
        activities,
        'user-1',
        now: now,
      );

      expect(result, isNotNull);
      expect(result!.titulo, 'Más cercana');
    });

    test('ignores activities without confirmation and past dates', () {
      final now = DateTime(2026, 8, 31, 12, 0, 0);
      final activities = [
        ActivityEntity(
          id: 'a',
          categoriaId: 'c1',
          creadorId: 'u1',
          tipo: 'entrenamiento',
          titulo: 'Solo pendiente',
          fechaHora: now.add(const Duration(days: 1)),
          estado: 'publicada',
          citaciones: [
            CitationEntity(
              id: 'c1',
              actividadId: 'a',
              jugadorId: 'user-1',
              estadoRespuesta: 'pendiente',
            ),
          ],
        ),
      ];

      final result = findClosestConfirmedActivity(
        activities,
        'user-1',
        now: now,
      );

      expect(result, isNull);
    });
  });
}
