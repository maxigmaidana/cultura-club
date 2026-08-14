import 'package:cultura_club/features/home/presentation/widgets/tab_inicio_generico.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../coach/presentation/screens/coach_dashboard_screen.dart';
import '../../../evaluation/presentation/screens/player_dashboard_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const String pathName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. Obtenemos el usuario de la sesión global
    final user = ref.watch(userSessionProvider).value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    // 2. Determinamos si es entrenador para armar la UI dinámica
    final isCoach = user.role.isCoach;

    // 3. Definimos las pantallas del BottomNav
    final List<Widget> screens = [
      TabInicioGenerico(user: user),
      isCoach
          ? CoachDashboardScreen(user: user)
          : PlayerDashboardScreen(user: user),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red[900],
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(isCoach ? Icons.sports : Icons.bar_chart),
            label: isCoach ? 'Categorías' : 'Mis Métricas',
          ),
        ],
      ),
    );
  }
}
