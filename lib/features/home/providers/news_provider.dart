import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/news_service.dart';
import '../model/news_article.dart';

export '../services/news_service.dart';

final newsServiceProvider = Provider((ref) => NewsService());

class NewsListNotifier extends StateNotifier<AsyncValue<List<NewsArticle>>> {
  final NewsService _service;
  String _currentSearchQuery = '';

  NewsListNotifier(this._service) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    // Immediate cache load
    final cached = await _service.getCachedArticles('cached_news');
    if (cached.isNotEmpty) {
      state = AsyncValue.data(cached);
      // Refresh in background
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
      // If refresh fails but we have data, stay silent or handle accordingly
      debugPrint('Background refresh failed: $e');
    }
  }

  Future<void> loadNews({String searchQuery = '', bool forceRefresh = false}) async {
    _currentSearchQuery = searchQuery;

    // Show loading if we don't have data, if we're searching, or if explicitly requested
    if (!state.hasValue || searchQuery.isNotEmpty || forceRefresh) {
      state = const AsyncValue.loading();
    }

    try {
      final articles = await _service.fetchNews(searchQuery: searchQuery);
      state = AsyncValue.data(articles);
    } catch (e, st) {
      if (state.hasValue) {
        // Fallback to existing data on error
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> searchNews(String query) async {
    state = const AsyncValue.loading();
    _currentSearchQuery = query;
    try {
      final articles = await _service.searchNews(query);
      state = AsyncValue.data(articles);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    // GDELT API doesn't support reliable pagination
    // Instead, we'll just refresh with more results
    try {
      final newArticles = await _service.fetchNews(
        searchQuery: _currentSearchQuery,
      );
      state = AsyncValue.data(newArticles);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool get hasMore => false; // Disable pagination due to API limitations
}

final newsProvider =
    StateNotifierProvider<NewsListNotifier, AsyncValue<List<NewsArticle>>>((
      ref,
    ) {
      final service = ref.watch(newsServiceProvider);
      return NewsListNotifier(service);
    });

final trendingProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  return service.fetchTrending();
});
