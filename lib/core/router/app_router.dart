import 'package:cultura_club/features/auth/presentation/screens/splash_screen.dart';
import 'package:cultura_club/features/coach/presentation/screens/category_players_screen.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_dashboard_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_detail_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/create_activity_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/datebook_screen.dart';
import 'package:cultura_club/features/evaluation/domain/entities/player_stats_entity.dart';
import 'package:cultura_club/features/evaluation/presentation/screens/evaluation_form_screen.dart';
import 'package:cultura_club/features/evaluation/presentation/screens/player_stats_chart_screen.dart';
import 'package:cultura_club/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

class _RouteLoggerObserver extends NavigatorObserver {
  String _label(Route<dynamic> route) =>
      route.settings.name ?? route.settings.toString();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('👉 PUSH -> ${_label(route)}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
      '👈 POP <- ${_label(route)} (vuelve a ${previousRoute != null ? _label(previousRoute) : 'ninguna'})',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('🗑️ REMOVE ${_label(route)}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
      '🔁 REPLACE ${oldRoute != null ? _label(oldRoute) : '?'} -> ${newRoute != null ? _label(newRoute) : '?'}',
    );
  }
}

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  observers: [_RouteLoggerObserver()],
  initialLocation: SplashScreen.pathName,
  routes: [
    GoRoute(
      path: SplashScreen.pathName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: LoginScreen.pathName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: HomeScreen.pathName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: DatebookScreen.pathName,
      builder: (context, state) =>
          DatebookScreen(categoriaId: state.pathParameters['categoriaId']!),
    ),
    GoRoute(
      path: '/datebook/:categoriaId/activity/:activityId',
      builder: (context, state) => ActivityDetailScreen(
        categoriaId: state.pathParameters['categoriaId']!,
        activity: state.extra as ActivityEntity,
      ),
    ),
    GoRoute(
      path: '/datebook/:categoriaId/activity/:activityId/dashboard',
      builder: (context, state) => ActivityDashboardScreen(
        categoriaId: state.pathParameters['categoriaId']!,
        activity: state.extra as ActivityEntity,
      ),
    ),
    GoRoute(
      path: '/datebook/:categoriaId/create',
      builder: (context, state) => CreateActivityScreen(
        categoriaId: state.pathParameters['categoriaId']!,
      ),
    ),
    GoRoute(
      path: '/datebook/:categoriaId/activity/:activityId/edit',
      builder: (context, state) => CreateActivityScreen(
        categoriaId: state.pathParameters['categoriaId']!,
        existingActivity: state.extra as ActivityEntity,
      ),
    ),
    GoRoute(
      path: CategoryPlayersScreen.pathName,
      builder: (context, state) => CategoryPlayersScreen(
        categoryId: state.pathParameters['categoryId']!,
        categoryName: state.extra as String,
      ),
    ),
    GoRoute(
      path: EvaluationFormScreen.pathName,
      builder: (context, state) => EvaluationFormScreen(
        playerId: state.pathParameters['playerId']!,
        categoryId: state.pathParameters['categoryId']!,
        playerName: state.extra as String,
      ),
    ),
    GoRoute(
      path: PlayerStatsChartScreen.pathName,
      builder: (context, state) =>
          PlayerStatsChartScreen(stats: state.extra as PlayerStatsEntity),
    ),
  ],
);
