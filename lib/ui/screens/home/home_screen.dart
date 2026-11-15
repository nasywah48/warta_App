import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/headlines_provider.dart';
// Sesuaikan jika provider kategori ada di file lain:
// import 'package:news_app/providers/category_provider.dart';

import 'widgets/headlines_section.dart';
import 'widgets/home_app_bar.dart';

/// Beranda: app bar, filter kategori, daftar top headlines.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    final provider = headlinesProvider(ref.read(SelectedCategoryProvider));
    ref.invalidate(provider);
    try {
      await ref.read(provider.future);
    } catch (_) {
      // Error sudah ditangani oleh HeadlinesSection (state error di UI),
      // jadi di sini cukup diabaikan agar indikator refresh tetap selesai.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => _refresh(ref),
      child: const CustomScrollView(
        slivers: [
          HomeAppBar(),
          HeadlinesSection(),
        ],
      ),
    );
  }
}