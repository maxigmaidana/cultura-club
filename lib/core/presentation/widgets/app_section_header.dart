import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class AppSectionHeader extends ConsumerWidget {
  final String title;

  const AppSectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.watch(primaryColorProvider);

    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
