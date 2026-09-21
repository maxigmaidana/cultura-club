import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class AppSettingItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const AppSettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.watch(primaryColorProvider);

    // Derive colors from primaryColor
    final iconBgColor = isDestructive
        ? primaryColor.withOpacity(0.1)
        : primaryColor.withOpacity(0.05);
    final iconColor = isDestructive ? primaryColor : primaryColor;
    final borderColor = isDestructive
        ? primaryColor.withOpacity(0.2)
        : Colors.grey[300]!;
    final containerBgColor = isDestructive
        ? primaryColor.withOpacity(0.05)
        : Colors.grey[50];
    final textColor = isDestructive ? primaryColor : Colors.grey[900];
    final arrowColor = isDestructive
        ? primaryColor.withOpacity(0.4)
        : Colors.grey[400];

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        color: containerBgColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
