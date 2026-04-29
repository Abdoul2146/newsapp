import 'package:hive/hive.dart';

part 'search_history.g.dart';

@HiveType(typeId: 1)
class SearchHistory {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final DateTime timestamp;

  SearchHistory({
    required this.query,
    required this.timestamp,
  });
}
