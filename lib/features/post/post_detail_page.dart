import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/core/echo_api.dart';
import 'package:echo/core/geo.dart';
import 'package:echo/core/models.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/core/widgets/reach_boost_badge.dart';
import 'package:echo/features/feed/feed_providers.dart';
import 'package:echo/features/post/composer_page.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  PostDetail? _detail;
  String? _error;
  bool _loading = true;
  bool _boosting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(echoApiProvider);
      final fix = await ref.read(locationServiceProvider).currentFix();
      ref.read(viewerLocationProvider.notifier).update(fix);
      final detail = await api.getPost(
        id: widget.postId,
        lat: fix.latitude,
        lon: fix.longitude,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (e) {
      final api = asApiException(e);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = api?.message ?? e.toString();
      });
    }
  }

  Future<void> _boost() async {
    final detail = _detail;
    if (detail == null || _boosting || detail.viewerHasBoosted) return;
    setState(() => _boosting = true);
    try {
      final api = ref.read(echoApiProvider);
      final fix = await ref.read(locationServiceProvider).currentFix();
      final result = await api.boostPost(
        postId: widget.postId,
        lat: fix.latitude,
        lon: fix.longitude,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail.copyWith(
          reachBoost: result.reachBoost,
          viewerHasBoosted: result.viewerHasBoosted,
        );
        _boosting = false;
      });
      ref.read(feedProvider.notifier).patchBoost(
            widget.postId,
            result.reachBoost,
            result.viewerHasBoosted,
          );
    } catch (e) {
      if (!mounted) return;
      setState(() => _boosting = false);
      final api = asApiException(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(api?.message ?? e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(echoApiProvider);
    final l10n = AppLocalizations.of(context);
    final ink = EchoColors.inkOf(context);
    final muted = EchoColors.mutedOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.thread,
          style: GoogleFonts.syne(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => ComposerPage(postId: widget.postId),
            ),
          );
          if (ok == true) await _load();
        },
        icon: const Icon(Icons.reply_outlined),
        label: Text(l10n.reply),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _load,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    _RootPostBlock(
                      detail: _detail!,
                      mediaUrl: _detail!.media == null
                          ? null
                          : api.resolveMediaUrl(_detail!.media!.url),
                      boosting: _boosting,
                      onBoost: _boost,
                      distanceLabel: () {
                        final viewer = ref.watch(viewerLocationProvider);
                        final lat = _detail!.lat;
                        final lon = _detail!.lon;
                        if (viewer == null || lat == null || lon == null) {
                          return null;
                        }
                        return EchoGeo.formatKm(
                          EchoGeo.distanceKm(
                            lat1: viewer.latitude,
                            lon1: viewer.longitude,
                            lat2: lat,
                            lon2: lon,
                          ),
                        );
                      }(),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        l10n.repliesSection,
                        style: GoogleFonts.syne(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_detail!.replies.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Text(
                          l10n.noRepliesYet,
                          style: GoogleFonts.plusJakartaSans(color: muted),
                        ),
                      )
                    else
                      ..._detail!.replies.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ReplyBlock(
                            body: r.body,
                            createdAt: r.createdAt,
                            mediaUrl: r.media == null
                                ? null
                                : api.resolveMediaUrl(r.media!.url),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}

class _RootPostBlock extends StatelessWidget {
  const _RootPostBlock({
    required this.detail,
    required this.boosting,
    required this.onBoost,
    this.mediaUrl,
    this.distanceLabel,
  });

  final PostDetail detail;
  final String? mediaUrl;
  final bool boosting;
  final VoidCallback onBoost;
  final String? distanceLabel;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.MMMd().add_Hm().format(detail.createdAt.toLocal());
    final canBoost = !detail.viewerHasBoosted;

    final l10n = AppLocalizations.of(context);
    final ink = EchoColors.inkOf(context);
    final muted = EchoColors.mutedOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: EchoColors.cardOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EchoColors.outlineOf(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReachBoostBadge(reachBoost: detail.reachBoost, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        distanceLabel == null
                            ? l10n.distanceUnknown
                            : l10n.distanceAt(distanceLabel!),
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      Text(
                        l10n.fromYourPosition,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              detail.body,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
            if (mediaUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: mediaUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: canBoost && !boosting ? onBoost : null,
                icon: boosting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        canBoost
                            ? Icons.add_circle_outline_rounded
                            : Icons.check_circle_rounded,
                      ),
                label: Text(
                  canBoost ? l10n.boostPlusKmReach : l10n.alreadyBoosted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplyBlock extends StatelessWidget {
  const _ReplyBlock({
    required this.body,
    required this.createdAt,
    this.mediaUrl,
  });

  final String body;
  final DateTime createdAt;
  final String? mediaUrl;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.MMMd().add_Hm().format(createdAt.toLocal());

    return DecoratedBox(
      decoration: BoxDecoration(
        color: EchoColors.cardOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EchoColors.outlineOf(context)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: EchoColors.primary.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: EchoColors.mutedOf(context),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.4,
                          ),
                    ),
                    if (mediaUrl != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: mediaUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
