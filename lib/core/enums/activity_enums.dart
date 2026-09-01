enum ActivityTipo {
  entrenamiento,
  partido,
  evento;

  static ActivityTipo fromString(String? value) {
    switch ((value ?? '').trim().toUpperCase()) {
      case 'PARTIDO':
        return ActivityTipo.partido;
      case 'EVENTO':
        return ActivityTipo.evento;
      case 'ENTRENAMIENTO':
      default:
        return ActivityTipo.entrenamiento;
    }
  }

  String get value {
    switch (this) {
      case ActivityTipo.entrenamiento:
        return 'entrenamiento';
      case ActivityTipo.partido:
        return 'partido';
      case ActivityTipo.evento:
        return 'evento';
    }
  }

  String get label {
    switch (this) {
      case ActivityTipo.entrenamiento:
        return 'Entrenamiento';
      case ActivityTipo.partido:
        return 'Partido';
      case ActivityTipo.evento:
        return 'Evento';
    }
  }
}

enum CitacionEstado {
  pendiente,
  confirma,
  noAsiste;

  static CitacionEstado fromString(String? value) {
    switch ((value ?? '').trim().toUpperCase()) {
      case 'CONFIRMA':
        return CitacionEstado.confirma;
      case 'NO_ASISTE':
        return CitacionEstado.noAsiste;
      case 'PENDIENTE':
      default:
        return CitacionEstado.pendiente;
    }
  }

  String get value {
    switch (this) {
      case CitacionEstado.pendiente:
        return 'pendiente';
      case CitacionEstado.confirma:
        return 'confirma';
      case CitacionEstado.noAsiste:
        return 'no_asiste';
    }
  }

  String get label {
    switch (this) {
      case CitacionEstado.pendiente:
        return 'Pendiente';
      case CitacionEstado.confirma:
        return 'Confirmados';
      case CitacionEstado.noAsiste:
        return 'No Asisten';
    }
  }
}

enum ActivityEstado {
  borrador,
  publicada,
  cancelada;

  static ActivityEstado fromString(String? value) {
    switch ((value ?? '').trim().toUpperCase()) {
      case 'BORRADOR':
        return ActivityEstado.borrador;
      case 'CANCELADA':
        return ActivityEstado.cancelada;
      case 'PUBLICADA':
      default:
        return ActivityEstado.publicada;
    }
  }

  String get value {
    switch (this) {
      case ActivityEstado.borrador:
        return 'borrador';
      case ActivityEstado.publicada:
        return 'publicada';
      case ActivityEstado.cancelada:
        return 'cancelada';
    }
  }

  String get label {
    switch (this) {
      case ActivityEstado.borrador:
        return 'Borrador';
      case ActivityEstado.publicada:
        return 'Publicada';
      case ActivityEstado.cancelada:
        return 'Cancelada';
    }
  }
}
