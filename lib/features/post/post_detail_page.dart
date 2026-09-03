import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/core/echo_api.dart';
import 'package:echo/core/models.dart';
import 'package:echo/features/post/composer_page.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(echoApiProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hilo')),
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
        label: const Text('Responder'),
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
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  children: [
                    _MessageBlock(
                      glyph: _detail!.authorGlyph,
                      body: _detail!.body,
                      createdAt: _detail!.createdAt,
                      mediaUrl: _detail!.media == null
                          ? null
                          : api.resolveMediaUrl(_detail!.media!.url),
                      emphasize: true,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Respuestas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_detail!.replies.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text('Aún no hay respuestas.'),
                      )
                    else
                      ..._detail!.replies.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MessageBlock(
                            glyph: r.authorGlyph,
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

class _MessageBlock extends StatelessWidget {
  const _MessageBlock({
    required this.glyph,
    required this.body,
    required this.createdAt,
    this.mediaUrl,
    this.emphasize = false,
  });

  final String glyph;
  final String body;
  final DateTime createdAt;
  final String? mediaUrl;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.MMMd().add_Hm().format(createdAt.toLocal());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(glyph, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Text(time, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: emphasize
              ? Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.4)
              : Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.35),
        ),
        if (mediaUrl != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: mediaUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
        ],
      ],
    );
  }
}
