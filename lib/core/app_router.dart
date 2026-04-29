import 'package:go_router/go_router.dart';
import '../core/widgets/main_layout.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/model/news_article.dart';
import '../features/trending_news/screens/trending_screen.dart';
import '../features/saved_articles/screens/saved_articles_screen.dart';
import '../features/article_detail/screens/article_detail_screen.dart';
import '../features/settings/screens/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/trending',
          builder: (context, state) => const TrendingScreen(),
        ),
        GoRoute(
          path: '/saved',
          builder: (context, state) => const SavedArticlesScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/article',
      builder: (context, state) {
        final article = state.extra as NewsArticle;
        return ArticleDetailScreen(article: article);
      },
    ),
  ],
);
