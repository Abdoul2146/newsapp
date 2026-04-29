import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/home/model/news_article.dart';
import '../../features/home/model/search_history.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  throw UnimplementedError('Initialize DatabaseService in main()');
});

class DatabaseService {
  static const String articleBoxName = 'articles_box';
  static const String historyBoxName = 'history_box';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NewsArticleAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SearchHistoryAdapter());
    }

    await Hive.openBox<NewsArticle>(articleBoxName);
    await Hive.openBox<SearchHistory>(historyBoxName);
  }

  Box<NewsArticle> get _articleBox => Hive.box<NewsArticle>(articleBoxName);
  Box<SearchHistory> get _historyBox => Hive.box<SearchHistory>(historyBoxName);

  // --- Caching Logic ---

  Future<void> cacheArticles(List<NewsArticle> articles, String type) async {
    // Mark articles as cached for this type
    for (var article in articles) {
      final existing = _articleBox.get(article.url);
      if (existing != null) {
        existing.cacheType = type;
        await _articleBox.put(article.url, existing);
      } else {
        article.cacheType = type;
        await _articleBox.put(article.url, article);
      }
    }
    
    // Cleanup: Remove old articles of this type that aren't in the new list and aren't saved
    final allArticles = _articleBox.values.where((a) => a.cacheType == type).toList();
    for (var old in allArticles) {
      if (!articles.any((a) => a.url == old.url) && !old.isSaved) {
        await _articleBox.delete(old.url);
      }
    }
  }

  Future<List<NewsArticle>> getCachedArticles(String type) async {
    final cached = _articleBox.values
        .where((a) => a.cacheType == type)
        .toList();
    cached.sort((a, b) => b.date.compareTo(a.date));
    return cached;
  }

  // --- Bookmark Logic ---

  List<NewsArticle> getSavedArticles() {
    final saved = _articleBox.values.where((a) => a.isSaved).toList();
    saved.sort((a, b) => b.date.compareTo(a.date));
    return saved;
  }

  Stream<List<NewsArticle>> watchSavedArticles() async* {
    // Yield current state immediately
    yield getSavedArticles();
    // Then listen for future changes
    await for (final _ in _articleBox.watch()) {
      yield getSavedArticles();
    }
  }

  Future<bool> toggleSave(NewsArticle article) async {
    final existing = _articleBox.get(article.url);
    if (existing != null) {
      existing.isSaved = !existing.isSaved;
      final wasSaved = existing.isSaved;
      if (!existing.isSaved && existing.cacheType == null) {
        await _articleBox.delete(article.url);
      } else {
        await _articleBox.put(article.url, existing);
      }
      return wasSaved;
    } else {
      article.isSaved = true;
      await _articleBox.put(article.url, article);
      return true;
    }
  }

  Future<bool> isSaved(String url) async {
    return _articleBox.get(url)?.isSaved ?? false;
  }

  // --- Search History Logic ---

  Future<void> saveSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    // Remove if exists to move to top
    await _historyBox.delete(q);
    await _historyBox.put(q, SearchHistory(query: q, timestamp: DateTime.now()));

    // Keep only 5
    if (_historyBox.length > 5) {
      final keys = _historyBox.keys.toList();
      await _historyBox.delete(keys.first);
    }
  }

  Future<List<String>> getSearchHistory() async {
    final history = _historyBox.values.toList();
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history.map((h) => h.query).toList();
  }

  Future<void> clearSearchHistory() async {
    await _historyBox.clear();
  }
}
