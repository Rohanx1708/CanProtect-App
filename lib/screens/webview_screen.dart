import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatelessWidget {
  final String? url;
  final String? title;

  const WebViewScreen({super.key, this.url, this.title});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String resolvedUrl = url ?? '';
    String resolvedTitle = title ?? 'Web';

    if (args is Map) {
      if (args['url'] is String) resolvedUrl = args['url'] as String;
      if (args['title'] is String) resolvedTitle = args['title'] as String;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(resolvedTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Web Content (UI only)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(resolvedUrl.isEmpty ? 'No URL provided' : resolvedUrl),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: resolvedUrl.isEmpty
                          ? null
                          : () async {
                              final uri = Uri.tryParse(resolvedUrl);
                              if (uri == null) return;
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('OPEN IN BROWSER'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Later we can embed an in-app WebView using the webview_flutter package. For now, this is UI-only.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
