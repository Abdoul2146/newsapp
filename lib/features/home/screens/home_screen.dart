import 'package:flutter/material.dart';
import '../../../core/widgets/empty_state.dart';
import '../widgets/news_item_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/services/database_service.dart';
import '../widgets/news_card.dart';
import '../providers/news_provider.dart';
import '../model/news_article.dart';
import '../../../core/config/flavor_config.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Show/hide back to top button
    if (_scrollController.offset > 400 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 400 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }

    // Infinite scroll trigger
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(newsProvider.notifier).loadMore();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget _buildSearchHistory() {
    final historyAsync = ref.watch(searchHistoryProvider);
    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: history.map((query) => ActionChip(
                  label: Text(query, style: const TextStyle(fontSize: 12)),
                  onPressed: () {
                    _searchController.text = query;
                    ref.read(newsProvider.notifier).loadNews(searchQuery: query);
                  },
                )).toList(),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildNewsList(List<NewsArticle> news) {
    if (news.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_outlined,
        title: 'No results found',
        message: 'Try searching for something else or check your connection.',
        onAction: () => ref.read(newsProvider.notifier).loadNews(),
        actionLabel: 'Refresh Feed',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 8, bottom: 180),
      itemCount: news.length,
      itemBuilder: (ctx, idx) {
        final article = news[idx];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: InkWell(
            onTap: () => context.push('/article', extra: article),
            borderRadius: BorderRadius.circular(16),
            child: NewsCard(article: article),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsAsyncValue = ref.watch(newsProvider);
    final loadedCount = newsAsyncValue.valueOrNull?.length ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    ref.read(databaseServiceProvider).saveSearch(value);
                    ref.read(newsProvider.notifier).loadNews(searchQuery: value);
                    ref.invalidate(searchHistoryProvider);
                  }
                },
              )
            : Text(
                FlavorConfig.instance.labels['headerHome']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(newsProvider.notifier).loadNews();
                }
              });
            },
            color: Colors.white,
          ),
        ],
      ),
      floatingActionButton: _showBackToTop
          ? Padding(
              padding: const EdgeInsets.only(bottom: 140), // Lift above Ad + Navbar
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                mini: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            )
          : null,
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            if (_isSearching && _searchController.text.isEmpty) _buildSearchHistory(),
            if (_isSearching && _searchController.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Searching for "${_searchController.text}" ($loadedCount results)',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: newsAsyncValue.when(
                data: (news) => RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(newsProvider.notifier).loadNews(forceRefresh: true);
                  },
                  child: _buildNewsList(news),
                ),
                loading: () => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 10,
                  itemBuilder: (_, __) => const NewsItemSkeleton(),
                ),
                error: (err, stack) => ErrorDisplay(
                  message: err.toString(),
                  onRetry: () => ref.read(newsProvider.notifier).loadNews(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
