import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/news_article.dart';

class NewsService {
  static const String _newsCacheKey = 'cached_news';
  static const String _trendingCacheKey = 'cached_trending';
  static const int _maxCacheItems = 50;
  static const int _defaultFetchSize = 50;

  Future<List<NewsArticle>> fetchNews({
    bool nextPage = false,
    String searchQuery = '',
  }) async {
    String queryPart = 'sourcecountry:unitedstates';
    if (searchQuery.isNotEmpty) {
      queryPart = '$queryPart+AND+$searchQuery';
    }

    final url = Uri.parse(
      'https://api.gdeltproject.org/api/v2/doc/doc?query=$queryPart&mode=ArtList&sort=datedesc&maxrecords=$_defaultFetchSize&format=json&timespan=14d',
    );

    try {
      final articles = await _fetch(url);
      await _cacheArticles(articles.take(_maxCacheItems).toList(), _newsCacheKey);
      return articles;
    } catch (e) {
      final cached = await getCachedArticles(_newsCacheKey);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<NewsArticle>> fetchTrending({int maxRecords = 15}) async {
    try {
      // Stable ArtList mode with relevance sorting for trending
      final url = Uri.parse(
        'https://api.gdeltproject.org/api/v2/doc/doc?query=sourcecountry:unitedstates&mode=ArtList&sort=relevance&maxrecords=$maxRecords&format=json&timespan=24h',
      );
      final articles = await _fetch(url);
      await _cacheArticles(articles.take(_maxCacheItems).toList(), _trendingCacheKey);
      return articles;
    } catch (e) {
      final cached = await getCachedArticles(_trendingCacheKey);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    final url = Uri.parse(
      'https://api.gdeltproject.org/api/v2/doc/doc?query=sourcecountry:unitedstates+AND+$query&mode=ArtList&sort=datedesc&maxrecords=$_defaultFetchSize&format=json',
    );

    try {
      final articles = await _fetch(url);
      return articles;
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<void> _cacheArticles(List<NewsArticle> articles, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = articles
        .map(
          (a) => {
            'title': a.title,
            'url': a.url,
            'imageUrl': a.imageUrl,
            'date': a.date.toIso8601String(),
          },
        )
        .toList();
    await prefs.setString(key, json.encode(jsonList));
  }

  Future<List<NewsArticle>> getCachedArticles(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(key);
      if (cached != null) {
        return await compute(_parseCachedJson, cached);
      }
    } catch (e) {
      debugPrint('Cache read error: $e');
    }
    return [];
  }

  static List<NewsArticle> _parseCachedJson(String cached) {
    final List<dynamic> jsonList = json.decode(cached);
    return jsonList
        .map(
          (j) => NewsArticle(
            title: j['title'],
            url: j['url'],
            imageUrl: j['imageUrl'],
            date: DateTime.parse(j['date']),
          ),
        )
        .toList();
  }

  Future<List<NewsArticle>> _fetch(Uri url) async {
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        return await compute(_parseNewsResponse, response.body);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static List<NewsArticle> _parseNewsResponse(String responseBody) {
    final Map<String, dynamic> data = json.decode(responseBody);
    final List articles = data['articles'] ?? [];
    return articles.map((json) => NewsArticle.fromJson(json)).toList();
  }
}
