// import '../../core/constants/api_constants.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:news_app/core/constants/api_constants.dart';
import 'package:news_app/data/services/news_api_exception.dart';

import '../models/article.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO 3: Implementasi NewsApiService
// 1. Install package http: `flutter pub add http`
// 2. Import 'package:http/http.dart' as http;
// 3. Buat fungsi getTopHeadlines(String category) yang memanggil endpoint /v2/top-headlines
// 4. Buat fungsi searchArticles(String query) yang memanggil endpoint /v2/everything
// 5. Tangani error menggunakan NewsApiException

// secvide tingkat rendah yang berbicara lansung dengan NewsAPI.

/**
 * dependensis injaction adalah sesuatu teknik menguntikkan atau memasukkan object (http.Client) dari luar kelas, buka dibuat lansung di dalam kelas ini.
 * tujuan --> memudahkan testing atau uji coba aplikasi dengan memasukkan "client tiruan" (mock) tanpa harus terhubung ke internet sungguhan.
 * tanda ?? berati jika client tidak diisi (null), otomatis akan mengmbalikan http.Cliant standar bawaan
 */

class NewsApiService { // penamaan best practice
  // definisi injeksi harus didefinisikan sebelum proses asingkronus
  NewsApiService({http.Client? client}) : _client = client ?? http.Client();

  // pendeklarasian atribut news API
  //variable privat diawali tanda "_" untuk menyimpan client http untuk berkomunikasi sengan SERVER.
  final http.Client _client;

  // untuk mengambil daftar berita top headlines utama sesuai dengan kategori, negara, dan kategori 
  Future<List<Article>> fetchTopHeadlines(String category) async {
    // Implementasi fetch API di sini
    return _get('/top-headlines', {
        'country': ApiConstants.country,
        'category': category,
      }
    );
  }

  // untuk mencari artikel berdasarkan kata kunci (query) diurutkan dari yang paling baru terbit.
  Future<List<Article>> searchArticles(String query) async {
    // Implementasi fetch API di sini
    return _get ('/everything', {
      'q': query,
      'sortBy': 'publishedAt',
      'language': ApiConstants.language
      }
    ); 
  }

  // helper methode: berfungsi untuk membantu (priveta, diawali _) agar kita tidak menulis ulang code requeat HTTP berkali-kali
  Future<List<Article>> _get(String path, Map<String, String> params) async {
    // validasi: cek apakah API key sudah diisi di file .env agar tidak terjadi kegagalan otentifikasi
    final apiKey = ApiConstants.apiKey;
    if (apiKey.isEmpty) {
      // petunjuk teknis hana untuk developer (console), bukan untuk user.
      debugPrint('[Warta] NEWS_API_KEY kosong. Isi API key di file .env');
      throw NewsApiException.serviceUnavailable;
    }

    // membangun URL lengkap: menggabungkan beseURL (alamat server utama) + path (end point tujuan)
    // lalu menyisipkan query perameters (parameter pencarian serta batas jumlah data/pageSize)
    // masih membutuhkan keseluruhan struktur
    final uri = Uri.parse('${ApiConstants.baseUrl}$path').replace(
      queryParameters: {...params, 'pageSize': '${ApiConstants.pageSize}'} 
      // spread operator (...) untuk memastikan bahwa semua object ikut semua, tidak ada yang tertinggal.
    );

    try{
      // mengirim request GET ke srver dengan HEADER 'X-Api-Key' sebagai tiket izin akses,
      // setra batas waktu (time out) agar aplikasi tidak menggantung jika server lambat merespon.
      final response = await _client
          .get(uri, headers: {'X-Api-Key': apiKey})
          .timeout(ApiConstants.timeout);

        // cek status code HTTP: code 200 berarti request sukses (OK)
        // jika bukan 200 (misal 401, 429, 500), lempar error khusus sesuai kode statusnya
        // kradensial kunci unik yang hanya kamu miliki
        if (response.statusCode != 200) {
          debugPrint('[Warta] HTTP ${response.statusCode}: ${response.body}');
          throw _fromStatusCode(response.statusCode);
        }

        // decoding = mengubah bahasa pemrograman manjadi bahasa tertentu
        // JSON decoding: mengubah data mentah menjadi text String dari server mejadi format MAP DART
        final body = jsonDecode(response.body) as Map<String, dynamic>;

        // mengambil daftar artikel dari key 'articles'. jika tidak
        final articles = body['articles'] as List<dynamic>? ?? [];
        // Data Mapping: Mengubah setiap data JSON menjadi sebuah object atau properties, yang akan ditampilkan pada return hanyalah data yang valid atau lengkap
        return articles
            .map((json) => Article.fromJson(json as Map<String, dynamic>))
            .where((Article) => Article.isValid)
            .toList();

    // throw: meneruskan kembali NewsApiException ke fungsi pemanggil tanpa mengubah jenis errornya
    } on NewsApiException {
      rethrow;
      // socket: Error koneksi pada level sistem operasi (misal: HP user sedang offline/ mode pesawat)
    } on SocketException {
      throw NewsApiException.offline;
      // ClientException: error pada koneksi HTTP (misal: DNS gagal menemukan alamat server atau koneksi terputus tiba-tiba)
    } on http.ClientException {
      throw NewsApiException.offline;
      // TimeoutException: Batas waktu tunggu habisa kerana koneksi internet terlalu lambat atau 
    } on TimeoutException {
      throw NewsApiException.slowConnection;
      // Catch: menangkap segala error tak terduga lainnya (fallback), agar aplikasih tidak crash atau keluar sendiri (force close)
    } catch (error) {
      debugPrint('[Warta] Unexpected error: $error');
      throw NewsApiException.unknown;
    }
  }

  // Switch Exception (fitur pattern matching di dart 3): Cara ringkas mencocokkan kode status HTTP dengan error NewsApiException
  NewsApiException _fromStatusCode(int code) => switch (code) {
  // 401 (unauthorized): API Key salah/tidak ada. 403 () askses ditolak oleh server
  401 || 403 => NewsApiException.serviceUnavailable,

  // 429 (Too many requeat): Batas kuota requeat harian sudah habis terpakai
  429 => NewsApiException.tooManyRequests,

  // 500 ke atas (Server error): terjadi ketika masalah teknis di server
  >= 500 => NewsApiException.serverBusy,

  // Gris bawah (_): menangani wildcard/defaut kode HTTP lainnya yang tidak disebutkan di atas
  _ => NewsApiException.unknown
  };
}

