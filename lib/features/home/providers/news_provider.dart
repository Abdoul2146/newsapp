import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../services/news_service.dart';
import '../model/news_article.dart';

export '../services/news_service.dart';

final newsServiceProvider = Provider((ref) {
  final db = ref.watch(databaseServiceProvider);
  return NewsService(db);
});

final searchHistoryProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(databaseServiceProvider);
  return db.getSearchHistory();
});

class NewsListNotifier extends StateNotifier<AsyncValue<List<NewsArticle>>> {
  final NewsService _service;
  final DatabaseService _db;
  String _currentSearchQuery = '';

  NewsListNotifier(this._service, this._db) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final cached = await _db.getCachedArticles('home');
    if (cached.isNotEmpty) {
      state = AsyncValue.data(cached);
      _refreshNews();
    } else {
      loadNews();
    }
  }

  Future<void> _refreshNews() async {
    try {
      final articles = await _service.fetchNews(
        searchQuery: _currentSearchQuery,
      );
      state = AsyncValue.data(articles);
    } catch (e) {
      debugPrint('Background refresh failed: $e');
    }
  }

  Future<void> loadNews({
    String searchQuery = '',
    bool forceRefresh = false,
  }) async {
    _currentSearchQuery = searchQuery;

    if (!state.hasValue || searchQuery.isNotEmpty || forceRefresh) {
      state = const AsyncValue.loading();
    }

    try {
      final articles = await _service.fetchNews(
        searchQuery: _currentSearchQuery,
      );
      state = AsyncValue.data(articles);
    } catch (e, st) {
      if (state.hasValue) {
        // Keep old data
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> loadMore() async {
    try {
      final newArticles = await _service.fetchNews(
        searchQuery: _currentSearchQuery,
      );
      
      final currentList = state.valueOrNull ?? [];
      final filteredNew = newArticles.where((a) => !currentList.any((existing) => existing.url == a.url)).toList();
      
      state = AsyncValue.data([...currentList, ...filteredNew]);
    } catch (e) {
      debugPrint('Load more failed: $e');
    }
  }
}

final newsProvider =
    StateNotifierProvider<NewsListNotifier, AsyncValue<List<NewsArticle>>>((
      ref,
    ) {
      final service = ref.watch(newsServiceProvider);
      final db = ref.watch(databaseServiceProvider);
      return NewsListNotifier(service, db);
    });

final trendingProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  return service.fetchTrending();
});
