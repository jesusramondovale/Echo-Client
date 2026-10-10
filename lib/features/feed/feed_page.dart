import 'package:echo/core/config.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/features/feed/feed_providers.dart';
import 'package:echo/features/feed/post_tile.dart';
import 'package:echo/features/post/composer_page.dart';
import 'package:echo/features/post/post_detail_page.dart';
import 'package:echo/features/settings/settings_page.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    final l10n = AppLocalizations.of(context);
    final ink = EchoColors.inkOf(context);
    final muted = EchoColors.mutedOf(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Text(
              l10n.appName,
              style: GoogleFonts.syne(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text(l10n.zoneRadiusValue(AppConfig.feedRadiusKm)),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: l10n.settings,
              style: IconButton.styleFrom(
                backgroundColor: EchoColors.cardOf(context),
                side: BorderSide(color: EchoColors.outlineOf(context)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              icon: const Icon(Icons.tune_rounded),
            ),
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
        label: Text(l10n.write),
      ),
      body: feed.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, size: 40, color: muted),
                const SizedBox(height: 16),
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(feedProvider),
                  child: Text(l10n.retry),
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
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  const Icon(
                    Icons.radar_rounded,
                    size: 48,
                    color: EchoColors.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.emptyZoneTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.syne(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      l10n.emptyZoneBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, height: 1.45),
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
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
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
