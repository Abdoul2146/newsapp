import 'package:hive/hive.dart';

part 'news_article.g.dart';

@HiveType(typeId: 0)
class NewsArticle {
  @HiveField(0)
  final String url;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String imageUrl;
  
  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  bool isSaved;

  @HiveField(5)
  String? cacheType;

  NewsArticle({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.date,
    this.isSaved = false,
    this.cacheType,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    String dateStr = json['date'] ?? json['seendate'] ?? '';
    DateTime parsedDate = DateTime.now();

    if (dateStr.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(dateStr).toLocal();
      } catch (_) {
        if (dateStr.length >= 14) {
          try {
            final formattedStr =
                '${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}T${dateStr.substring(8, 10)}:${dateStr.substring(10, 12)}:${dateStr.substring(12, 14)}Z';
            parsedDate = DateTime.parse(formattedStr).toLocal();
          } catch (_) {}
        } else if (dateStr.length >= 8) {
          try {
            final formattedStr =
                '${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}';
            parsedDate = DateTime.parse(formattedStr).toLocal();
          } catch (_) {}
        }
      }
    }

    return NewsArticle(
      title: json['title'] ?? 'No Title',
      url: json['url'] ?? '',
      imageUrl: json['socialimage'] ?? '',
      date: parsedDate,
    );
  }
}
