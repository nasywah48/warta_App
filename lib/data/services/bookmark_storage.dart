// penyimpanan lokal artikel yang di bookmark menggunakan sharedpreferences

import 'dart:convert';

import 'package:news_app/data/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkStorage {
  static const _key = 'bookmarked_articles';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<List<Article>> load() async {
    final raw = await _prefs.getStringList(_key) ?? [];
    return raw
        .map(
          (item) => Article.fromJson(jsonDecode(item) as Map<String, dynamic>),
        )
        // untuk mengubah String menjadi JSON, dan untuk mencocokkan tipe data yang sebelumnya Map menjadi List
        .toList();
  }

  // function yang dijalankan ketika user mem-bookmark sebuah artikel 
  Future<void> save(List<Article> articles) {
    final raw = articles
        .map((article) => jsonEncode(article.toJson()))
        .toList();
    return _prefs.setStringList(_key, raw);
  }
}