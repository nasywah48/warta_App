import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/bookmark_button.dart';

/// Kartu berita: gambar 16:9, label sumber, judul, waktu, share + bookmark.
class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => AppRouter.openArticle(context, article),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ArticleImage(url: article.imageUrl, radius: 0),
            ),
            const SizedBox(height: 12),
            Text(
              article.sourceName.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontFamily: 'monospace',
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(article.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormatter.relative(article.publishedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Bagikan',
                  icon: const Icon(Icons.share_outlined, size: 18),
                  onPressed: () {
                    // TODO: bagikan artikel
                  },
                ),
                BookmarkButton(article: article),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
