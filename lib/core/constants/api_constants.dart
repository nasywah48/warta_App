import 'package:flutter_dotenv/flutter_dotenv.dart';

// TODO 2: Setup API Constants
// 1. Definisikan baseUrl NewsAPI
// 2. Buat getter untuk mengambil API Key dari dotenv
// 3. Tentukan country (misal: 'us') dan language (misal: 'en')

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://newsapi.org/v2'; // Isi dengan base URL NewsAPI
  
  static String get apiKey => (dotenv.maybeGet('NEWS_API_KEY') ?? '').trim(); //ini getter, yang dipanggil key-nya

  // untuk klasifikasi negara yang akanditampilkan beritanya di top-headlines
  static const String country = 'us';

  // untuk bahasa yang akan ditampilkan ketika proses pencarian
  static const String language = 'en';

  // untuk memberitau berapa banyak berita yang akan ditampilakan dalam sekali request
  static const int pageSize = 30; // tidak ada maksimal, selama kita menggunakan future dart

  // sebagai batas waktu berapa lama aplikasi ata client dapat terhubung dengan API
  static const Duration timeout = Duration(seconds: 15);
}
