class MediaDto {
  MediaDto({
    required this.id,
    required this.url,
    required this.contentType,
    this.width,
    this.height,
  });

  final String id;
  final String url;
  final String contentType;
  final int? width;
  final int? height;

  factory MediaDto.fromJson(Map<String, dynamic> json) => MediaDto(
        id: json['id'] as String,
        url: json['url'] as String,
        contentType: json['contentType'] as String,
        width: json['width'] as int?,
        height: json['height'] as int?,
      );
}

class PostSummary {
  PostSummary({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.authorGlyph,
    required this.replyCount,
    this.media,
    this.lat,
    this.lon,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  final String authorGlyph;
  final int replyCount;
  final MediaDto? media;
  final double? lat;
  final double? lon;

  factory PostSummary.fromJson(Map<String, dynamic> json) => PostSummary(
        id: json['id'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        authorGlyph: json['authorGlyph'] as String,
        replyCount: json['replyCount'] as int? ?? 0,
        media: json['media'] == null
            ? null
            : MediaDto.fromJson(json['media'] as Map<String, dynamic>),
        lat: (json['lat'] as num?)?.toDouble(),
        lon: (json['lon'] as num?)?.toDouble(),
      );
}

class ReplyItem {
  ReplyItem({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.authorGlyph,
    this.media,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  final String authorGlyph;
  final MediaDto? media;

  factory ReplyItem.fromJson(Map<String, dynamic> json) => ReplyItem(
        id: json['id'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        authorGlyph: json['authorGlyph'] as String,
        media: json['media'] == null
            ? null
            : MediaDto.fromJson(json['media'] as Map<String, dynamic>),
      );
}

class PostDetail {
  PostDetail({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.authorGlyph,
    required this.replies,
    this.media,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  final String authorGlyph;
  final MediaDto? media;
  final List<ReplyItem> replies;

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
        id: json['id'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        authorGlyph: json['authorGlyph'] as String,
        media: json['media'] == null
            ? null
            : MediaDto.fromJson(json['media'] as Map<String, dynamic>),
        replies: (json['replies'] as List<dynamic>? ?? [])
            .map((e) => ReplyItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class FeedPage {
  FeedPage({required this.items, this.nextCursor});

  final List<PostSummary> items;
  final String? nextCursor;

  factory FeedPage.fromJson(Map<String, dynamic> json) => FeedPage(
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => PostSummary.fromJson(e as Map<String, dynamic>))
            .toList(),
        nextCursor: json['nextCursor'] as String?,
      );
}
