import 'package:cultura_club/core/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file - works on mobile and web (from assets)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      print('[Web Init] Warning: Could not load .env file: $e');
    }
    // Continue anyway - Supabase credentials might be provided via environment
  }

  // Get Supabase credentials from dotenv or throw clear error
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];

  if (supabaseUrl == null || supabaseUrl.isEmpty) {
    if (kDebugMode) {
      print('[Web Init] ERROR: SUPABASE_URL not found in .env');
    }
    throw Exception(
      'SUPABASE_URL environment variable is required. '
      'Ensure .env file is in web/assets/ for web builds.',
    );
  }

  if (supabaseKey == null || supabaseKey.isEmpty) {
    if (kDebugMode) {
      print('[Web Init] ERROR: SUPABASE_PUBLISHABLE_KEY not found in .env');
    }
    throw Exception(
      'SUPABASE_PUBLISHABLE_KEY environment variable is required. '
      'Ensure .env file is in web/assets/ for web builds.',
    );
  }

  if (kDebugMode) {
    print('[Web Init] ✓ Loaded SUPABASE_URL from .env');
    print('[Web Init] ✓ Loaded SUPABASE_PUBLISHABLE_KEY from .env');
  }

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);

  if (kDebugMode) {
    print('[Web Init] ✓ Supabase initialized');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Cultura Club',
      routerConfig: appRouter,
    );
  }
}
