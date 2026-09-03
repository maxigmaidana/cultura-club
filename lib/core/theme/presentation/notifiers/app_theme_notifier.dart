import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/app_theme.dart';
import '../providers/theme_providers.dart';

part 'app_theme_notifier.g.dart';

@Riverpod(keepAlive: true)
class AppThemeNotifier extends _$AppThemeNotifier {
  @override
  Future<AppTheme> build() async {
    final useCase = ref.watch(getAppThemeUseCaseProvider);
    final result = await useCase();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (theme) => theme,
    );
  }
}
