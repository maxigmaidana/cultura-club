import 'package:cultura_club/core/enums/user_rol_enums.dart';

class UserEntity {
  final String id;
  final String clubId;
  final String email;
  final UserRole role;
  final String fullName;

  const UserEntity({
    required this.id,
    required this.clubId,
    required this.email,
    required this.role,
    required this.fullName,
  });
}