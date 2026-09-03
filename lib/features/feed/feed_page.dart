import 'package:echo/features/feed/feed_providers.dart';
import 'package:echo/features/feed/post_tile.dart';
import 'package:echo/features/post/composer_page.dart';
import 'package:echo/features/post/post_detail_page.dart';
import 'package:echo/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Echo'),
        actions: [
          IconButton(
            tooltip: 'Ajustes',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const ComposerPage()),
          );
          if (created == true) {
            await ref.read(feedProvider.notifier).refresh();
          }
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Escribir'),
      ),
      body: feed.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(feedProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.read(feedProvider.notifier).refresh(),
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      'Nadie ha escrito cerca todavía.\nSé el primero en tu zona.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(feedProvider.notifier).refresh(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.pixels > n.metrics.maxScrollExtent - 200) {
                  ref.read(feedProvider.notifier).loadMore();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.items.length + (state.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final post = state.items[index];
                  return PostTile(
                    post: post,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(postId: post.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
