import 'package:fpdart/fpdart.dart';

import '../../../errors/failures.dart';
import '../../domain/entities/app_theme.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource dataSource;

  ThemeRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, AppTheme>> getAppTheme() async {
    try {
      final model = await dataSource.getAppTheme();
      return Right(model.entity);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
