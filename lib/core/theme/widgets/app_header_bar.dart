import 'package:flutter/material.dart';

/// Header used on top-level tab screens: avatar (initials) + title + optional logout.
class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String avatarInitial;
  final bool showLogout;
  final VoidCallback? onLogout;

  const AppHeaderBar({
    super.key,
    required this.title,
    required this.avatarInitial,
    this.showLogout = false,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 12,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            child: Text(avatarInitial),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: scheme.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (showLogout)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: onLogout,
          ),
      ],
    );
  }
}
