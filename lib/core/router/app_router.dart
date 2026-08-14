import 'package:cultura_club/features/auth/presentation/screens/splash_screen.dart';
import 'package:cultura_club/features/home/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

final GoRouter appRouter = GoRouter(
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
  ],
);