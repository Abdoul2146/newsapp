import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/shared_app_bar.dart';
import '../../article_detail/screens/article_webview_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _openWebView(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleWebViewScreen(url: url, title: title),
      ),
    );
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@omegapitechnologies.com',
    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch email client')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    // Check if effective brightness is dark
    final bool isDark = themeMode == ThemeMode.dark || 
        (themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: const SharedAppBar(title: 'SETTINGS'),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildSection(context, 'Account', [
              _buildTile(
                context,
                Icons.lock_outline,
                'Privacy Policy',
                'Control your data and privacy',
                onTap: () => _openWebView(
                  context,
                  'Privacy Policy',
                  'https://omegapitechnologies.com/privacy-policy/',
                ),
              ),
            ]),
            _buildSection(context, 'Preferences', [
              _buildTile(
                context,
                Icons.dark_mode_outlined,
                'Dark Mode',
                'Toggle dark/light theme',
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme(value);
                  },
                ),
                onTap: () {
                  ref.read(themeProvider.notifier).toggleTheme(!isDark);
                },
              ),
            ]),
            _buildSection(context, 'Support', [
              _buildTile(
                context,
                Icons.info_outline,
                'About Us',
                'App version and info',
                onTap: () => _openWebView(
                  context,
                  'About Us',
                  'https://omegapitechnologies.com/about/',
                ),
              ),
              _buildTile(
                context,
                Icons.mail_outline,
                'Contact Us',
                'contact@omegapitechnologies.com',
                onTap: () => _sendEmail(context),
              ),
            ]),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'News App v1.0.0',
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        ...tiles,
        const Divider(),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
