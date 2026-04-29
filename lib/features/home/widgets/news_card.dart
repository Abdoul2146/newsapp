import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/ad_service.dart';
import '../model/news_article.dart';
import '../../saved_articles/providers/saved_articles_provider.dart';

class NewsCard extends ConsumerWidget {
  final NewsArticle article;

  const NewsCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedArticlesAsync = ref.watch(savedArticlesProvider);
    final isSaved = savedArticlesAsync.valueOrNull?.any((a) => a.url == article.url) ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: article.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                child: const Icon(Icons.broken_image),
              ),
            )
          else
            Container(
              height: 180,
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              child: const Center(child: Icon(Icons.image, size: 50)),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(article.date),
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      onPressed: () async {
                        final db = ref.read(databaseServiceProvider);
                        final adService = ref.read(adServiceProvider);
                        
                        final justSaved = await db.toggleSave(article);
                        
                        if (justSaved) {
                          adService.incrementSaveCounterAndShowAd();
                        }
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                justSaved ? 'Saved for later' : 'Removed from saved',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
