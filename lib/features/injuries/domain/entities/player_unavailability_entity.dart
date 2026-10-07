class PlayerUnavailabilityEntity {
  final String id;
  final String playerId;
  final String title;
  final String? description;
  final String status; // ACTIVE, RECOVERING, CLOSED
  final String? bodyArea;
  final String? bodySide;
  final String? severity;
  final DateTime startDate;
  final DateTime? estimatedReturnDate;
  final bool canTrain;
  final bool canPlay;
  final String? playerNotes;
  final DateTime? closedAt;
  final DateTime createdAt;

  const PlayerUnavailabilityEntity({
    required this.id,
    required this.playerId,
    required this.title,
    this.description,
    required this.status,
    this.bodyArea,
    this.bodySide,
    this.severity,
    required this.startDate,
    this.estimatedReturnDate,
    required this.canTrain,
    required this.canPlay,
    this.playerNotes,
    this.closedAt,
    required this.createdAt,
  });

  // Helper to check if injury is current (active or recovering)
  bool get isCurrent => status == 'ACTIVE' || status == 'RECOVERING';

  // Helper to check if injury is closed
  bool get isClosed => status == 'CLOSED';

  // Helper to get status in Spanish
  String get statusInSpanish {
    switch (status) {
      case 'ACTIVE':
        return 'Activa';
      case 'RECOVERING':
        return 'En recuperación';
      case 'CLOSED':
        return 'Alta médica';
      default:
        return status;
    }
  }

  /// Helper to get severity in Spanish (without backend enum strings)
  String? get severityInSpanish {
    if (severity == null) return null;
    switch (severity) {
      case 'MILD':
        return 'Leve';
      case 'MODERATE':
        return 'Moderada';
      case 'SEVERE':
        return 'Grave';
      default:
        return severity;
    }
  }

  /// Helper to get body side in Spanish (returns null if NOT_APPLICABLE)
  String? get bodySideInSpanish {
    if (bodySide == null) return null;
    switch (bodySide) {
      case 'LEFT':
        return 'Izquierda';
      case 'RIGHT':
        return 'Derecha';
      case 'BILATERAL':
        return 'Bilateral';
      case 'NOT_APPLICABLE':
        return null; // Intentionally return null to hide this field
      default:
        return bodySide;
    }
  }
}
