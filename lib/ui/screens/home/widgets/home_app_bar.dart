import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/navigation_provider.dart';

import '../../../../core/utils/date_formatter.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: 56,
      title: Text(
        'HERMES',
        style: theme.textTheme.headlineMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Cari berita',
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            ref.read(navigationProvider.notifier).select(1);
          },
        ),
        IconButton(
          tooltip: 'Notifikasi',
          icon: Badge(
            smallSize: 8,
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.notifications_none_rounded),
          ),
          onPressed: () {
            // TODO: halaman notifikasi
          },
        ),
        IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {
            // TODO: menu / drawer
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Text(
            DateFormatter.today().toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.4,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}