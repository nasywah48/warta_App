import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/headlines_provider.dart';
import 'package:news_app/ui/widgets/empty_state.dart';
import 'package:news_app/ui/widgets/error_state.dart';
import 'package:news_app/ui/widgets/loading_skeleton.dart';

import '../../../widgets/article_tile.dart';
import 'article_card.dart';
import 'category_chips.dart';
import 'featured_article_card.dart';

/// TODO: Ubah HeadlinesSection menjadi ConsumerWidget
/// TODO: Gunakan AsyncValue.when dari headlinesProvider
class HeadlinesSection extends ConsumerWidget {
  const HeadlinesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Category = ref.watch(SelectedCategoryProvider);
    final headlines = ref.watch(headlinesProvider(Category));

    return headlines.when(
      loading: () => const SliverToBoxAdapter(child: LoadingSkeleton(),),
            error: (error, _) => SliverMainAxisGroup(
        slivers: [
          const SliverToBoxAdapter(child: CategoryChips()),
          SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorState(
              error: error,
              onRetry: () => ref.invalidate(headlinesProvider(Category)),
            ),
          ),
        ],
      ),
      data: (articles) {
        if (articles.isEmpty) {
          return const SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(child: CategoryChips()),
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.newspaper_rounded,
                  title: 'Belum ada berita',
                  message: 'Coba pilih kategori, atau refresh',
                ),
              ),
            ],
          );
        }

        final theme = Theme.of(context);
        final latest = articles.skip(1).take(2).toList();
        final rest = articles.skip(3).toList();

        return SliverPadding(
          padding: const EdgeInsets.only(bottom: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              FeaturedArticleCard(article: articles.first),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'BERITA TERBARU',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      'Lihat Semua',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
              for (final a in latest) ArticleCard(article: a),
              const CategoryChips(),
              for (final a in rest) ...[
                ArticleTile(article: a),
                const Divider(indent: 16, endIndent: 16),
              ],
            ]),
          ),
        );
      },
    );
  }
}
