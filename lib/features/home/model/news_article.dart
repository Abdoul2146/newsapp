class NewsArticle {
  final String title;
  final String url;
  final String imageUrl;
  final DateTime date;

  NewsArticle({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.date,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    String dateStr = json['date'] ?? json['seendate'] ?? '';
    DateTime parsedDate = DateTime.now();

    if (dateStr.isNotEmpty) {
      try {
        // GDELT extended format: 20241004T203000Z
        parsedDate = DateTime.parse(dateStr).toLocal();
      } catch (_) {
        // Fallback for GDELT compressed format: 20241004203000
        if (dateStr.length >= 14) {
          try {
            final formattedStr =
                '${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}T${dateStr.substring(8, 10)}:${dateStr.substring(10, 12)}:${dateStr.substring(12, 14)}Z';
            parsedDate = DateTime.parse(formattedStr).toLocal();
          } catch (_) {}
        } else if (dateStr.length >= 8) {
          // Fallback for short format: 20241004
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
