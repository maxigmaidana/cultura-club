import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/theme_local_data_source.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/get_app_theme_usecase.dart';

part 'theme_providers.g.dart';

@Riverpod(keepAlive: true)
ThemeLocalDataSource themeLocalDataSource(Ref ref) {
  return ThemeLocalDataSourceImpl();
}

@Riverpod(keepAlive: true)
ThemeRepository themeRepository(Ref ref) {
  final dataSource = ref.watch(themeLocalDataSourceProvider);
  return ThemeRepositoryImpl(dataSource);
}

@Riverpod(keepAlive: true)
GetAppThemeUseCase getAppThemeUseCase(Ref ref) {
  final repository = ref.watch(themeRepositoryProvider);
  return GetAppThemeUseCase(repository);
}
