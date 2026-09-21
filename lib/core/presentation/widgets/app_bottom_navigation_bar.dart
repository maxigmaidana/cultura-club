import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';

/// Modelo para un item del BottomNavigationBar
class AppBottomNavItem {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  AppBottomNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Widget reutilizable para BottomNavigationBar con estilos consistentes
class AppBottomNavigationBar extends ConsumerWidget {
  final List<AppBottomNavItem> items;
  final int currentIndex;
  final Color? selectedColor;

  const AppBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lee el color primario del provider (fallback a red[900] si no está disponible)
    final primaryColor = selectedColor ?? ref.watch(primaryColorProvider);

    return BottomNavigationBar(
      enableFeedback: false,
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index < items.length) {
          items[index].onTap();
        }
      },
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: items
          .map(
            (item) =>
                BottomNavigationBarItem(icon: item.icon, label: item.label),
          )
          .toList(),
    );
  }
}
