import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/core/echo_api.dart';
import 'package:echo/core/geo.dart';
import 'package:echo/core/models.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/core/widgets/reach_boost_badge.dart';
import 'package:echo/features/feed/feed_providers.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PostTile extends ConsumerStatefulWidget {
  const PostTile({
    super.key,
    required this.post,
    required this.onTap,
  });

  final PostSummary post;
  final VoidCallback onTap;

  @override
  ConsumerState<PostTile> createState() => _PostTileState();
}

class _PostTileState extends ConsumerState<PostTile> {
  late PostSummary _post;
  bool _boosting = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(covariant PostTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id ||
        oldWidget.post.reachBoost != widget.post.reachBoost ||
        oldWidget.post.viewerHasBoosted != widget.post.viewerHasBoosted) {
      _post = widget.post;
    }
  }

  Future<void> _boost() async {
    if (_boosting || _post.viewerHasBoosted) return;
    setState(() => _boosting = true);
    try {
      final api = ref.read(echoApiProvider);
      final fix = await ref.read(locationServiceProvider).currentFix();
      final result = await api.boostPost(
        postId: _post.id,
        lat: fix.latitude,
        lon: fix.longitude,
      );
      if (!mounted) return;
      setState(() {
        _post = _post.copyWith(
          reachBoost: result.reachBoost,
          viewerHasBoosted: result.viewerHasBoosted,
        );
        _boosting = false;
      });
      ref.read(feedProvider.notifier).patchBoost(
            _post.id,
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

  String? _distanceLabel() {
    final viewer = ref.watch(viewerLocationProvider);
    final lat = _post.lat;
    final lon = _post.lon;
    if (viewer == null || lat == null || lon == null) return null;
    final km = EchoGeo.distanceKm(
      lat1: viewer.latitude,
      lon1: viewer.longitude,
      lat2: lat,
      lon2: lon,
    );
    return EchoGeo.formatKm(km);
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(echoApiProvider);
    final time = DateFormat.MMMd().add_Hm().format(_post.createdAt.toLocal());
    final textTheme = Theme.of(context).textTheme;
    final canBoost = !_post.viewerHasBoosted;
    final distance = _distanceLabel();
    final l10n = AppLocalizations.of(context);
    final muted = EchoColors.mutedOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: EchoColors.cardOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: EchoColors.outlineOf(context)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ReachBoostBadge(reachBoost: _post.reachBoost),
                    const SizedBox(width: 10),
                    Text(
                      distance == null
                          ? l10n.distanceUnknown
                          : l10n.distanceAt(distance),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: textTheme.bodySmall?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _post.body,
                  style: textTheme.bodyLarge?.copyWith(
                    height: 1.4,
                    letterSpacing: -0.1,
                  ),
                ),
                if (_post.media != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: api.resolveMediaUrl(_post.media!.url),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 188,
                      placeholder: (context, url) => Container(
                        height: 188,
                        color: EchoColors.surfaceOf(context),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 80,
                        color: EchoColors.surfaceOf(context),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: EchoColors.mutedOf(context),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.repliesCount(_post.replyCount),
                      style: textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: canBoost && !_boosting ? _boost : null,
                      icon: _boosting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              canBoost
                                  ? Icons.add_circle_outline_rounded
                                  : Icons.check_circle_rounded,
                              size: 18,
                            ),
                      label: Text(
                        canBoost ? l10n.boostPlusKm : l10n.boosted,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: EchoColors.primary,
                        disabledForegroundColor: muted,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
