import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../services/news_service.dart';
import 'news_provider.dart';
import '../../home/model/news_article.dart';

final trendingNotifierProvider = StateNotifierProvider<TrendingNotifier, AsyncValue<List<NewsArticle>>>((ref) {
  final service = ref.read(newsServiceProvider);
  final db = ref.read(databaseServiceProvider);
  return TrendingNotifier(service, db);
});

class TrendingNotifier extends StateNotifier<AsyncValue<List<NewsArticle>>> {
  final NewsService _service;
  final DatabaseService _db;
  int _currentLimit = 15;

  TrendingNotifier(this._service, this._db) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final cached = await _db.getCachedArticles('trending');
    if (cached.isNotEmpty) {
      state = AsyncValue.data(cached);
      _refreshTrending();
    } else {
      loadTrending();
    }
  }

  Future<void> _refreshTrending() async {
    try {
      final articles = await _service.fetchTrending(maxRecords: _currentLimit);
      state = AsyncValue.data(articles);
    } catch (e) {
      debugPrint('Background trending refresh failed: $e');
    }
  }

  Future<void> loadTrending({bool forceRefresh = false}) async {
    if (!state.hasValue || forceRefresh) {
      state = const AsyncValue.loading();
    }
    try {
      final articles = await _service.fetchTrending(maxRecords: _currentLimit);
      state = AsyncValue.data(articles);
    } catch (e, st) {
      if (!state.hasValue) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> loadMore() async {
    _currentLimit += 15; // Consistent increment
    await loadTrending();
  }

  bool get hasMore => state.valueOrNull?.length == _currentLimit;
}
