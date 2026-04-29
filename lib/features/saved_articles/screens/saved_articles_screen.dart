import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/shared_app_bar.dart';
import '../../home/widgets/news_card.dart';
import '../providers/saved_articles_provider.dart';
import 'package:go_router/go_router.dart';

class SavedArticlesScreen extends ConsumerWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedArticles = ref.watch(savedArticlesProvider);

    return Scaffold(
      appBar: const SharedAppBar(title: 'SAVED'),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: savedArticles.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 80,
                      color: Theme.of(context).dividerColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No saved articles yet',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon to save articles',
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
