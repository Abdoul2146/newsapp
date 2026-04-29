import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/shared_app_bar.dart';
import '../../home/providers/trending_notifier.dart';
import '../widgets/trending_item_skeleton.dart';
import '../widgets/trending_item.dart';

class TrendingScreen extends ConsumerWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsyncValue = ref.watch(trendingNotifierProvider);

    return Scaffold(
      appBar: const SharedAppBar(title: 'TRENDING'),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(trendingNotifierProvider.notifier).loadTrending(forceRefresh: true);
        },
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: trendingAsyncValue.when(
            data: (news) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Trending Pulse',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'LIVE NEWS VELOCITY',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Top stories card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOP STORIES',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...news.take(15).map((article) {
                          final index = news.indexOf(article) + 1;
                          return InkWell(
                            onTap: () => context.push('/article', extra: article),
                            child: TrendingItem(
                              rank: index,
                              article: article,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (ref.read(trendingNotifierProvider.notifier).hasMore)
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(trendingNotifierProvider.notifier).loadMore(),
                      child: const Text('Load more'),
                    ),
                ],
              ),
            ),
            loading: () => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 15,
              itemBuilder: (_, __) => const TrendingItemSkeleton(),
            ),
            error: (err, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load trending news.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(trendingNotifierProvider.notifier).loadTrending(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
