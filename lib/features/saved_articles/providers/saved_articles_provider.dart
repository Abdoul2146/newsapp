import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../../home/model/news_article.dart';

final savedArticlesProvider = StreamProvider<List<NewsArticle>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db.watchSavedArticles();
});

// For backward compatibility and easy toggle access
final savedArticlesNotifierProvider = Provider((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db;
});
