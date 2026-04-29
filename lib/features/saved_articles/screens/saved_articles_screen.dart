import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shared_app_bar.dart';
import '../../home/widgets/news_card.dart';
import '../providers/saved_articles_provider.dart';
import 'package:go_router/go_router.dart';

class SavedArticlesScreen extends ConsumerWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedArticlesAsync = ref.watch(savedArticlesProvider);

    return Scaffold(
      appBar: const SharedAppBar(title: 'SAVED'),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: savedArticlesAsync.when(
          data: (savedArticles) => savedArticles.isEmpty
              ? EmptyState(
                  icon: Icons.bookmark_border_outlined,
                  title: 'Your collection is empty',
                  message: 'Tap the bookmark icon on any article to save it for later.',
                  onAction: () => GoRouter.of(context).go('/'),
                  actionLabel: 'Explore News',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: savedArticles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Your Collection',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }
                    final article = savedArticles[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () =>
                            GoRouter.of(context).push('/article', extra: article),
                        child: NewsCard(article: article),
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
