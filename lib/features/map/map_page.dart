import 'dart:ui';

import 'package:echo/core/config.dart';
import 'package:echo/core/geo.dart';
import 'package:echo/core/models.dart';
import 'package:echo/core/theme.dart';
import 'package:echo/core/widgets/reach_boost_badge.dart';
import 'package:echo/features/post/post_detail_page.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MapViewData {
  const MapViewData({
    required this.user,
    required this.posts,
  });

  final LatLng user;
  final List<PostSummary> posts;
}

class MapViewNotifier extends AsyncNotifier<MapViewData> {
  @override
  Future<MapViewData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<MapViewData> _load() async {
    final fix = await ref.read(locationServiceProvider).currentFix();
    ref.read(viewerLocationProvider.notifier).update(fix);
    final page = await ref.read(echoApiProvider).getMap(
          lat: fix.latitude,
          lon: fix.longitude,
        );
    return MapViewData(
      user: LatLng(fix.latitude, fix.longitude),
      posts: page.items.where((p) => p.lat != null && p.lon != null).toList(),
    );
  }
}

final mapViewProvider =
    AsyncNotifierProvider<MapViewNotifier, MapViewData>(MapViewNotifier.new);

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final _controller = MapController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(mapViewProvider);
    final l10n = AppLocalizations.of(context);
    final ink = EchoColors.inkOf(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          l10n.map,
          style: GoogleFonts.syne(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: l10n.refresh,
              style: IconButton.styleFrom(
                backgroundColor: EchoColors.cardOf(context),
                side: BorderSide(color: EchoColors.outlineOf(context)),
              ),
              onPressed: () => ref.read(mapViewProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
      body: map.when(
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
                  onPressed: () => ref.read(mapViewProvider.notifier).refresh(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  initialCenter: data.user,
                  initialZoom: 12.2,
                  minZoom: 4,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.echo.echo',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: data.user,
                        radius: AppConfig.feedRadiusKm * 1000,
                        useRadiusInMeter: true,
                        color: EchoColors.primary.withValues(alpha: 0.08),
                        borderColor: EchoColors.primary.withValues(alpha: 0.45),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      ...data.posts.map(
                        (post) => Marker(
                          point: LatLng(post.lat!, post.lon!),
                          width: 42,
                          height: 42,
                          child: GestureDetector(
                            onTap: () => _openPost(post, data.user),
                            child: const _MapPin(
                              color: EchoColors.secondary,
                              icon: Icons.chat_bubble_rounded,
                            ),
                          ),
                        ),
                      ),
                      Marker(
                        point: data.user,
                        width: 48,
                        height: 48,
                        child: const _MapPin(
                          color: EchoColors.primary,
                          icon: Icons.near_me_rounded,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: EchoColors.outline),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          l10n.mapOverlay(
                            data.posts.length,
                            AppConfig.feedRadiusKm,
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: EchoColors.inkOf(context),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 78,
                child: FloatingActionButton.small(
                  heroTag: 'recenter',
                  onPressed: () => _controller.move(data.user, 12.2),
                  child: const Icon(Icons.my_location_rounded),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openPost(PostSummary post, LatLng user) {
    final distance = (post.lat != null && post.lon != null)
        ? EchoGeo.formatKm(
            EchoGeo.distanceKm(
              lat1: user.latitude,
              lon1: user.longitude,
              lat2: post.lat!,
              lon2: post.lon!,
            ),
          )
        : null;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ReachBoostBadge(reachBoost: post.reachBoost, size: 40),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nearbyEcho,
                        style: GoogleFonts.plusJakartaSans(
                          color: EchoColors.mutedOf(ctx),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        distance == null
                            ? l10n.distanceUnknown
                            : l10n.distanceAt(distance),
                        style: GoogleFonts.plusJakartaSans(
                          color: EchoColors.inkOf(ctx),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                post.body,
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(postId: post.id),
                      ),
                    );
                  },
                  child: Text(l10n.openThread),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.color,
    required this.icon,
    this.size = 42,
  });

  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.45),
    );
  }
}
