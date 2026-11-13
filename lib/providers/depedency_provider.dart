// depedency injection: service $ repository disediakan lewat provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/repositories/news_repository.dart';
import 'package:news_app/data/services/bookmark_storage.dart';
import 'package:news_app/data/services/news_api_service.dart';

final NewsApiServiceProvider = Provider<NewsApiService>(
  (ref) => NewsApiService(),
);

final NewsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(ref.watch(NewsApiServiceProvider)),
);

final BookmarkStorageProvider = Provider<BookmarkStorage>(
  (ref) => BookmarkStorage(),
);