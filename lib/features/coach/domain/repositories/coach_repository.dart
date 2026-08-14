import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_profile_entity.dart';

abstract class CoachRepository {
  Future<Either<Failure, List<PlayerProfileEntity>>> getRoster(String coachId);
}