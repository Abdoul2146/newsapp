import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/model/news_article.dart';
import '../../saved_articles/providers/saved_articles_provider.dart';
// import 'package:intl/intl.dart';

class TrendingItem extends ConsumerWidget {
  final int rank;
  final NewsArticle article;

  const TrendingItem({super.key, required this.rank, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref
        .watch(savedArticlesProvider)
        .any((a) => a.url == article.url);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Semantics(
                label: 'Rank $rank',
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rank <= 3 ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              size: 20,
              color: isSaved
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            onPressed: () {
              final notifier = ref.read(savedArticlesProvider.notifier);
              notifier.toggleSave(article);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? 'Removed from saved' : 'Saved for later',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
