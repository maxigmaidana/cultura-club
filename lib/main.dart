import 'package:cultura_club/core/router/app_router.dart';
import 'package:cultura_club/core/theme/presentation/notifiers/app_theme_notifier.dart';
import 'package:cultura_club/core/theme/presentation/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(appThemeProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 600;

    return themeAsync.when(
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stackTrace) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: Text('No se pudo cargar el tema: $error'))),
      ),
      data: (theme) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Cultura Club',
        theme: buildLightThemeData(theme, isCompact: isCompact),
        darkTheme: buildDarkThemeData(theme, isCompact: isCompact),
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}