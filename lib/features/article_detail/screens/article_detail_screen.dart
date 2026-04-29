import 'package:flutter/material.dart';
import '../../home/model/news_article.dart';
import '../widgets/detail_action_buttons.dart';
import 'article_webview_screen.dart';

class ArticleDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
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
                // const ListTile(
                //   leading: CircleAvatar(child: Icon(Icons.person)),
                //   title: Text('News Contributor'),
                //   subtitle: Text('Verified Source'),
                // ),
                // const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArticleWebViewScreen(
                          url: article.url,
                          title: article.title,
                        ),
                      ),
                    );
                  },
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
