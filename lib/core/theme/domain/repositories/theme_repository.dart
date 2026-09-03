import 'package:fpdart/fpdart.dart';

import '../../../errors/failures.dart';
import '../entities/app_theme.dart';

abstract class ThemeRepository {
  Future<Either<Failure, AppTheme>> getAppTheme();
}
