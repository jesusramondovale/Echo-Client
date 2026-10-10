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
    required this.reachBoost,
    required this.replyCount,
    this.viewerHasBoosted = false,
    this.media,
    this.lat,
    this.lon,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  /// Extra km beyond the base 15 km radius.
  final int reachBoost;
  final int replyCount;
  final bool viewerHasBoosted;
  final MediaDto? media;
  final double? lat;
  final double? lon;

  int get effectiveRadiusKm => 15 + reachBoost;

  PostSummary copyWith({
    int? reachBoost,
    bool? viewerHasBoosted,
    int? replyCount,
  }) {
    return PostSummary(
      id: id,
      body: body,
      createdAt: createdAt,
      reachBoost: reachBoost ?? this.reachBoost,
      replyCount: replyCount ?? this.replyCount,
      viewerHasBoosted: viewerHasBoosted ?? this.viewerHasBoosted,
      media: media,
      lat: lat,
      lon: lon,
    );
  }

  factory PostSummary.fromJson(Map<String, dynamic> json) => PostSummary(
        id: json['id'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        reachBoost: json['reachBoost'] as int? ?? 0,
        replyCount: json['replyCount'] as int? ?? 0,
        viewerHasBoosted: json['viewerHasBoosted'] as bool? ?? false,
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
    this.media,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  final MediaDto? media;

  factory ReplyItem.fromJson(Map<String, dynamic> json) => ReplyItem(
        id: json['id'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
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
    required this.reachBoost,
    required this.replies,
    this.viewerHasBoosted = false,
    this.media,
    this.lat,
    this.lon,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  final int reachBoost;
  final bool viewerHasBoosted;
  final MediaDto? media;
  final List<ReplyItem> replies;
  final double? lat;
  final double? lon;

  int get effectiveRadiusKm => 15 + reachBoost;

  PostDetail copyWith({
    int? reachBoost,
    bool? viewerHasBoosted,
    List<ReplyItem>? replies,
  }) {
    return PostDetail(
      id: id,
      body: body,
      createdAt: createdAt,
      reachBoost: reachBoost ?? this.reachBoost,
      viewerHasBoosted: viewerHasBoosted ?? this.viewerHasBoosted,
      media: media,
      replies: replies ?? this.replies,
      lat: lat,
      lon: lon,
    );
  }

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
        id: json['id'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        reachBoost: json['reachBoost'] as int? ?? 0,
        viewerHasBoosted: json['viewerHasBoosted'] as bool? ?? false,
        media: json['media'] == null
            ? null
            : MediaDto.fromJson(json['media'] as Map<String, dynamic>),
        replies: (json['replies'] as List<dynamic>? ?? [])
            .map((e) => ReplyItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        lat: (json['lat'] as num?)?.toDouble(),
        lon: (json['lon'] as num?)?.toDouble(),
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

class BoostResult {
  BoostResult({
    required this.reachBoost,
    this.viewerHasBoosted = true,
  });

  final int reachBoost;
  final bool viewerHasBoosted;

  factory BoostResult.fromJson(Map<String, dynamic> json) => BoostResult(
        reachBoost: json['reachBoost'] as int? ?? 0,
        viewerHasBoosted: json['viewerHasBoosted'] as bool? ?? true,
      );
}
