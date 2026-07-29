import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/database_service.dart';
import '../../../core/config/flavor_config.dart';
import '../model/news_article.dart';

class NewsService {
  final DatabaseService _db;
  static const int _maxCacheItems = 50;
  static const int _defaultFetchSize = 50;

  NewsService(this._db);

  Future<List<NewsArticle>> fetchNews({
    String searchQuery = '',
  }) async {
    String queryPart = 'sourcecountry:${FlavorConfig.instance.countryQuery}';
    
    if (searchQuery.isNotEmpty) {
      queryPart = '$queryPart+AND+$searchQuery';
    }

    final url = Uri.parse(
      'https://api.gdeltproject.org/api/v2/doc/doc?query=$queryPart&mode=ArtList&sort=datedesc&maxrecords=$_defaultFetchSize&format=json&timespan=14d',
    );

    try {
      final articles = await _fetch(url);
      await _db.cacheArticles(articles.take(_maxCacheItems).toList(), 'home');
      return articles;
    } catch (e) {
      final cached = await _db.getCachedArticles('home');
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<NewsArticle>> fetchTrending({int maxRecords = 15}) async {
    try {
      final url = Uri.parse(
        'https://api.gdeltproject.org/api/v2/doc/doc?query=sourcecountry:${FlavorConfig.instance.countryQuery}&mode=ArtList&sort=relevance&maxrecords=$maxRecords&format=json&timespan=24h',
      );
      final articles = await _fetch(url);
      await _db.cacheArticles(articles.take(_maxCacheItems).toList(), 'trending');
      return articles;
    } catch (e) {
      final cached = await _db.getCachedArticles('trending');
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    final url = Uri.parse(
      'https://api.gdeltproject.org/api/v2/doc/doc?query=sourcecountry:${FlavorConfig.instance.countryQuery}+AND+$query&mode=ArtList&sort=datedesc&maxrecords=$_defaultFetchSize&format=json',
    );

    try {
      final articles = await _fetch(url);
      return articles;
    } catch (e) {
      throw Exception('Search failed: $e');
    }
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
