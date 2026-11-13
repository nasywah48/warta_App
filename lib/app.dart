import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/theme_provider.dart';

import 'core/theme/app_theme.dart';
import 'ui/screens/main_shell/main_shell_screen.dart';

// TODO: Ubah NewsApp menjadi ConsumerWidget jika Riverpod sudah ditambahkan
class NewsApp extends ConsumerWidget {
  // ConsumerWidget adalah class yang berfungsi untuk mendengarkan dan merespons perubahan status (state), kemudian memperbarui bagian antar muka (UI) yang terkait secara otomatis tanpa harus merender ulang seluruh halaman aplikasi
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Warta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // TODO: Gunakan ref.watch untuk mengambil mode tema
      themeMode: ref.watch(themeModeProvider),
      home: const MainShellScreen(),
    );
  }
}
