## Before vs After - Detail Screen Improvements

### BEFORE (Raw Backend Values)
```
Detalle de la Lesión

Estado
Activa

Información
Título: Brazo roto
Descripción: Golpe durante partido
Zona Corporal: brazo
Lado: LEFT              ← Raw backend enum
Severidad: SEVERE       ← Raw backend enum
Inicio: 05/10/2026
Regreso Estimado: 12/10/2026

Disponibilidad
✓ Puede entrenar
✕ No puede jugar

Indicaciones
Usar cabestrillo durante entrenamientos
```

---

### AFTER (User-Friendly Translations & Smart Hiding)
```
Detalle de la Lesión

Estado
Activa

Información
Título: Brazo roto
Descripción: Golpe durante partido
Zona Corporal: brazo
Lado: Izquierda         ← Translated to Spanish
Severidad: Grave        ← Translated to Spanish
Inicio: 05/10/2026
Regreso Estimado: 12/10/2026

Disponibilidad
✓ Puede entrenar
✕ No puede jugar

Indicaciones
Usar cabestrillo durante entrenamientos
```

---

## Special Handling Examples

### Case 1: NO APPLICABLE BODY SIDE
**BEFORE**:
```
Lado
NOT_APPLICABLE  ← Useless visual clutter
```

**AFTER**:
```
[Lado field is completely hidden]
```

---

### Case 2: MISSING ESTIMATED RETURN DATE
**BEFORE** (if had fallback):
```
Regreso Estimado
05/10/2026  ← Wrong! Using startDate as fallback
```

**AFTER**:
```
[Regreso Estimado field is completely hidden]
← Correctly only shows if backend has actual value
```

---

### Case 3: MISSING DESCRIPTION
**BEFORE**:
```
Descripción
[empty]  ← Visual noise
```

**AFTER**:
```
[Descripción field is completely hidden]
```

---

### Case 4: EMPTY PLAYER NOTES
**BEFORE**:
```
Indicaciones
[blank card]  ← Empty section shown
```

**AFTER**:
```
[Indicaciones section is completely hidden]
```

---

## Translation Mappings Implemented

### Status
| Backend  | Display      |
|----------|--------------|
| ACTIVE   | Activa       |
| RECOVERING | En recuperación |
| CLOSED   | Alta médica  |

### Severity
| Backend   | Display   |
|-----------|-----------|
| MILD      | Leve      |
| MODERATE  | Moderada  |
| SEVERE    | Grave     |

### Body Side
| Backend       | Display   | UI Action |
|---------------|-----------|-----------|
| LEFT          | Izquierda | Show      |
| RIGHT         | Derecha   | Show      |
| BILATERAL     | Bilateral | Show      |
| NOT_APPLICABLE | (none)   | **Hide**  |

---

## Centralized Helper Functions

Location: `lib/features/injuries/presentation/utils/injury_presentation_utils.dart`

```dart
// Translate status
String label = InjuryPresentationUtils.statusLabel('ACTIVE');
// Returns: "Activa"

// Translate severity (null-safe)
String? label = InjuryPresentationUtils.severityLabel(injury.severity);
// Returns: "Grave" or null

// Translate body side (null if NOT_APPLICABLE)
String? label = InjuryPresentationUtils.bodySideLabel(injury.bodySide);
// Returns: "Izquierda" or null (for hiding)

// Validate field visibility
bool show = InjuryPresentationUtils.shouldShowDescription(injury.description);
// Returns: true only if not null and not empty
```

---

## Enum Architecture

Location: `lib/core/enums/injury_enums.dart`

All enums follow project pattern:
- Type-safe representation
- `.label` getter for Spanish text
- `.fromString()` static parser
- Clean null handling

```dart
enum InjurySeverity {
  mild,
  moderate,
  severe;

  String get label => switch (this) {
    InjurySeverity.mild => 'Leve',
    InjurySeverity.moderate => 'Moderada',
    InjurySeverity.severe => 'Grave',
  };

  static InjurySeverity? fromString(String? value) {
    // Safe parsing with null handling
  }
}
```
