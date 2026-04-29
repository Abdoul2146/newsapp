import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/ad_service.dart';
import '../../home/model/news_article.dart';
import '../widgets/detail_action_buttons.dart';
import 'article_webview_screen.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final NewsArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  void _openFullArticle(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleWebViewScreen(
          url: article.url,
          title: article.title,
        ),
      ),
    );
  }

  Future<void> _handleReadFullArticle(BuildContext context, WidgetRef ref) async {
    final adService = ref.read(adServiceProvider);

    if (!adService.isRewardedAdLoaded) {
      // If ad not loaded, allow access for better UX, but trigger a load
      adService.loadRewardedAd();
      _openFullArticle(context);
      return;
    }

    final shouldShowAd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlock Full Article'),
        content: const Text('Watch a short video to read the complete story from the source.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('WATCH AD'),
          ),
        ],
      ),
    );

    if (shouldShowAd == true) {
      final success = await adService.showRewardedAd();
      if (success && context.mounted) {
        _openFullArticle(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: article.imageUrl.isNotEmpty
                  ? Image.network(article.imageUrl, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[400],
                      child: const Icon(Icons.image, size: 100),
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _handleReadFullArticle(context, ref),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('READ FULL ARTICLE'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 16),
                DetailActionButtons(article: article),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
