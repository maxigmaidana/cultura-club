import '../../../../core/enums/injury_enums.dart';

/// Utility class para traducir y formatear valores de lesiones
abstract class InjuryPresentationUtils {
  /// Traduce el estado de la lesión al español
  static String statusLabel(String status) {
    final parsed = InjuryStatus.fromString(status);
    return parsed.label;
  }

  /// Traduce la severidad de la lesión al español
  static String? severityLabel(String? severity) {
    if (severity == null) return null;
    final parsed = InjurySeverity.fromString(severity);
    return parsed?.label;
  }

  /// Traduce el lado del cuerpo al español
  /// Retorna null si es NOT_APPLICABLE (para ocultar en UI)
  static String? bodySideLabel(String? bodySide) {
    if (bodySide == null) return null;
    final parsed = BodySide.fromString(bodySide);
    if (parsed == null || !parsed.isDisplayable) return null;
    return parsed.label;
  }

  /// Valida si un string de descripción debe mostrarse
  static bool shouldShowDescription(String? description) {
    return description != null && description.isNotEmpty;
  }

  /// Valida si un string de zona corporal debe mostrarse
  static bool shouldShowBodyArea(String? bodyArea) {
    return bodyArea != null && bodyArea.isNotEmpty;
  }

  /// Valida si notas del jugador deben mostrarse
  static bool shouldShowPlayerNotes(String? playerNotes) {
    return playerNotes != null && playerNotes.isNotEmpty;
  }
}
