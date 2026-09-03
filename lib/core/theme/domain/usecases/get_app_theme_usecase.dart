import 'package:fpdart/fpdart.dart';

import '../../../errors/failures.dart';
import '../entities/app_theme.dart';
import '../repositories/theme_repository.dart';

class GetAppThemeUseCase {
  final ThemeRepository repository;

  GetAppThemeUseCase(this.repository);

  Future<Either<Failure, AppTheme>> call() async {
    return repository.getAppTheme();
  }
}
