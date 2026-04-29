import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/model/news_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedArticlesNotifier extends StateNotifier<List<NewsArticle>> {
  static const _cacheKey = 'saved_articles';

  SavedArticlesNotifier() : super([]) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        final loaded = jsonList
            .map(
              (j) => NewsArticle(
                title: j['title'],
                url: j['url'],
                imageUrl: j['imageUrl'],
                date: DateTime.parse(j['date']),
              ),
            )
            .toList();
        state = loaded;
      } catch (_) {}
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state
        .map(
          (a) => {
            'title': a.title,
            'url': a.url,
            'imageUrl': a.imageUrl,
            'date': a.date.toIso8601String(),
          },
        )
        .toList();
    await prefs.setString(_cacheKey, json.encode(jsonList));
  }

  void toggleSave(NewsArticle article) {
    if (state.any((a) => a.url == article.url)) {
      state = state.where((a) => a.url != article.url).toList();
    } else {
      state = [...state, article];
    }
    _saveToPrefs();
  }

  bool isSaved(NewsArticle article) => state.any((a) => a.url == article.url);
}

final savedArticlesProvider =
    StateNotifierProvider<SavedArticlesNotifier, List<NewsArticle>>((ref) {
      return SavedArticlesNotifier();
    });
