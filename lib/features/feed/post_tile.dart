import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/core/models.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PostTile extends ConsumerWidget {
  const PostTile({
    super.key,
    required this.post,
    required this.onTap,
  });

  final PostSummary post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(echoApiProvider);
    final time = DateFormat.MMMd().add_Hm().format(post.createdAt.toLocal());

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  post.authorGlyph,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.35),
            ),
            if (post.media != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: api.resolveMediaUrl(post.media!.url),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  placeholder: (context, url) => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 80,
                    child: Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              '${post.replyCount} respuestas',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.black.withValues(alpha: 0.08), height: 1),
          ],
        ),
      ),
    );
  }
}
