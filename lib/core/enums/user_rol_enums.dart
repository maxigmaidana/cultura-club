enum UserRole {
  entrenador,
  superAdmin,
  jugador,
  adminClub;

  static UserRole fromString(String? value) {
    switch ((value ?? '').trim().toUpperCase()) {
      case 'ENTRENADOR':
        return UserRole.entrenador;
      case 'SUPER_ADMIN':
      case 'SUPERADMIN':
        return UserRole.superAdmin;
      case 'JUGADOR':
        return UserRole.jugador;
      case 'ADMIN_CLUB':
      case 'ADMINCLUB':
        return UserRole.adminClub;
      default:
        return UserRole.jugador;
    }
  }

  String get value {
    switch (this) {
      case UserRole.entrenador:
        return 'ENTRENADOR';
      case UserRole.superAdmin:
        return 'SUPER_ADMIN';
      case UserRole.jugador:
        return 'JUGADOR';
      case UserRole.adminClub:
        return 'ADMIN_CLUB';
    }
  }

  bool get isCoach => this == UserRole.entrenador || this == UserRole.superAdmin;

  String get label {
    switch (this) {
      case UserRole.entrenador:
        return 'Entrenador';
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.jugador:
        return 'Jugador';
      case UserRole.adminClub:
        return 'Admin Club';
    }
  }
}
