// import '../data/models/article.dart';

// TODO 8: Implementasi HeadlinesProvider
// 1. Buat class HeadlinesNotifier extends AsyncNotifier<List<Article>>
// 2. Di dalam build(), panggil NewsRepository.getTopHeadlines()
// 3. Buat fungsi fetchHeadlines(String category) untuk memuat ulang data dengan kategori berbeda
// 4. Buat headlinesProvider (AsyncNotifierProvider) untuk digunakan di UI

// class HeadlinesNotifier {}

// kategori yang sedang dipilih halaman beranda
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/constants/news_category.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/data/repositories/news_repository.dart';
import 'package:news_app/providers/depedency_provider.dart';

class SelectedCategoryNotifier extends Notifier<NewsCategory>{
  @override
  NewsCategory build() => NewsCategory.general;

  void select(NewsCategory category) => state = category; // kenapa ini NewsCategory, yang sebelumnya String
}

final SelectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, NewsCategory>(
      SelectedCategoryNotifier.new,
    );

//Top Headlines per kategori
//Memakai '.family' sehingga setiap kategori di cache saat user kembali ke kategori 
//yang sama, data akan langsung tampil TANPA REQUEST ULANG (tanpa GET API)

final headlinesProvider = FutureProvider.family<List<Article>, NewsCategory>((ref, Category) {
  return ref.watch(NewsRepositoryProvider).getTopHeadlines(Category);
});