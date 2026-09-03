import 'package:echo/core/config.dart';
import 'package:echo/core/models.dart';
import 'package:echo/features/post/post_detail_page.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final teal = Theme.of(context).colorScheme.primary;
    final coral = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () => ref.read(mapViewProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
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
                  child: const Text('Reintentar'),
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
                        color: teal.withValues(alpha: 0.08),
                        borderColor: teal.withValues(alpha: 0.45),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      ...data.posts.map(
                        (post) => Marker(
                          point: LatLng(post.lat!, post.lon!),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () => _openPost(post),
                            child: Icon(
                              Icons.chat_bubble,
                              color: coral,
                              size: 32,
                              shadows: const [
                                Shadow(color: Colors.white, blurRadius: 6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Marker(
                        point: data.user,
                        width: 48,
                        height: 48,
                        child: Icon(
                          Icons.person_pin_circle,
                          color: teal,
                          size: 44,
                          shadows: const [
                            Shadow(color: Colors.white, blurRadius: 8),
                          ],
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
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Text(
                      '${data.posts.length} ecos en 15 km  ·  tú estás en el pin verde',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 76,
                child: FloatingActionButton.small(
                  heroTag: 'recenter',
                  onPressed: () => _controller.move(data.user, 12.2),
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openPost(PostSummary post) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.authorGlyph, style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(post.body, style: Theme.of(ctx).textTheme.bodyLarge),
            const SizedBox(height: 16),
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
                child: const Text('Abrir hilo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
