import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/services/theme_storage.dart';
import 'package:news_app/providers/theme_provider.dart';

import 'app.dart';

Future<void> main() async {
  // Selama proses inisialisasi ini, native splash screen tetap tampil.
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(isOptional: true);
  await initializeDateFormatting('id_ID');
  final initialTheme = await ThemeStorage().load(); //buat menyesuaikan ke user tergantu sistem default yang user pake (contoh ketika default hp user make dark mode, maka warta app akan langsung kebuka dengan mode dark mode (menyesuaikan user))

  runApp(
    // TODO: Bungkus NewsApp dengan ProviderScope saat mengimplementasikan Riverpod (kenapa pake riverpood biar klo ada perubahan setiapkali apk di buka, itu udah siap )

    ProviderScope(
      //matikan auto retry bawaan reiverpood agar kuota api tidak cepat habis
      retry: (retryCount, error) => null,
      overrides: [
        //TODO: lengkapi pemnggilan theme provider
        initialThemeModeProvider.overrideWithValue(initialTheme),
      ],
      child: NewsApp(),
    ),
  );
}