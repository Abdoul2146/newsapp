import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../home/model/news_article.dart';
import '../../saved_articles/providers/saved_articles_provider.dart';

class DetailActionButtons extends ConsumerWidget {
  final NewsArticle article;

  const DetailActionButtons({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Correct reactive way to watch if this specific article is saved
    final isSaved = ref
        .watch(savedArticlesProvider)
        .any((a) => a.url == article.url);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                final notifier = ref.read(savedArticlesProvider.notifier);
                notifier.toggleSave(article);

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSaved ? 'Removed from saved' : 'Saved to collection',
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              color: isSaved ? Theme.of(context).colorScheme.primary : null,
              iconSize: 28,
            ),
            const Text('Save', style: TextStyle(fontSize: 12)),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                final shareText = 'Check out this news: ${article.title}\n\nRead more at: ${article.url}';
                try {
                  await Share.share(shareText);
                } catch (e) {
                  // Fallback to Clipboard if plugin is not linked yet
                  await Clipboard.setData(ClipboardData(text: shareText));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share sheet unavailable. Link copied to clipboard!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.share_outlined),
              iconSize: 28,
            ),
            const Text('Share', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
