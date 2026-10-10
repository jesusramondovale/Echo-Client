import 'package:dio/dio.dart';
import 'package:echo/core/api_exception.dart';
import 'package:echo/core/config.dart';
import 'package:echo/core/models.dart';
import 'package:echo/core/secure_store.dart';

class EchoApi {
  EchoApi(this._store) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _store.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(_mapError(error));
        },
      ),
    );
  }

  final SecureStore _store;
  late final Dio _dio;

  Future<void> bootstrap() async {
    final deviceKey = await _store.getOrCreateDeviceKey();
    final res = await _dio.post(
      '/api/session/bootstrap',
      data: {'deviceKey': deviceKey},
    );
    final token = res.data['accessToken'] as String;
    await _store.saveToken(token);
  }

  Future<FeedPage> getFeed({
    required double lat,
    required double lon,
    String? cursor,
  }) async {
    final res = await _dio.get(
      '/api/feed',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'cursor': ?cursor,
      },
    );
    return FeedPage.fromJson(res.data as Map<String, dynamic>);
  }

  Future<FeedPage> getMap({
    required double lat,
    required double lon,
  }) async {
    final res = await _dio.get(
      '/api/map',
      queryParameters: {'lat': lat, 'lon': lon},
    );
    return FeedPage.fromJson(res.data as Map<String, dynamic>);
  }

  Future<PostDetail> getPost({
    required String id,
    required double lat,
    required double lon,
  }) async {
    final res = await _dio.get(
      '/api/posts/$id',
      queryParameters: {'lat': lat, 'lon': lon},
    );
    return PostDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<PostSummary> createPost({
    required String body,
    required double lat,
    required double lon,
    String? mediaId,
  }) async {
    final res = await _dio.post(
      '/api/posts',
      data: {
        'body': body,
        'lat': lat,
        'lon': lon,
        'mediaId': ?mediaId,
      },
    );
    return PostSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<ReplyItem> createReply({
    required String postId,
    required String body,
    required double lat,
    required double lon,
    String? mediaId,
  }) async {
    final res = await _dio.post(
      '/api/posts/$postId/replies',
      data: {
        'body': body,
        'lat': lat,
        'lon': lon,
        'mediaId': ?mediaId,
      },
    );
    return ReplyItem.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> registerPushToken({
    required String token,
    required String platform,
  }) async {
    await _dio.put(
      '/api/me/push-token',
      data: {
        'token': token,
        'platform': platform,
      },
    );
  }

  /// +1 km of visibility for a post (one boost per user).
  Future<BoostResult> boostPost({
    required String postId,
    required double lat,
    required double lon,
  }) async {
    final res = await _dio.post(
      '/api/posts/$postId/boost',
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
    );
    final data = res.data as Map<String, dynamic>;
    return BoostResult(
      reachBoost: data['reachBoost'] as int? ?? 0,
      viewerHasBoosted: data['viewerHasBoosted'] as bool? ?? true,
    );
  }

  Future<MediaDto> uploadMedia({
    required String filePath,
    required String fileName,
    int? width,
    int? height,
  }) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'width': ?width,
      'height': ?height,
    });
    final res = await _dio.post(
      '/api/media',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );
    return MediaDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<MediaDto> setAvatar(String mediaId) async {
    final res = await _dio.put('/api/me/avatar', data: {'mediaId': mediaId});
    final avatar = (res.data as Map<String, dynamic>)['avatar']
        as Map<String, dynamic>;
    final media = MediaDto.fromJson(avatar);
    await _store.saveAvatarUrl(_resolveMediaUrl(media.url));
    return media;
  }

  String resolveMediaUrl(String url) => _resolveMediaUrl(url);

  String _resolveMediaUrl(String url) {
    final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), '');
    if (url.startsWith('http')) {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.path.contains('/media')) {
        // Rewrite absolute media hosts (public IP / wrong port) to current API base.
        return '$base${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}';
      }
      return url;
    }
    return '$base${url.startsWith('/') ? '' : '/'}$url';
  }

  DioException _mapError(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final code = data['code'] as String? ?? 'UNKNOWN';
      final message = data['message'] as String? ?? error.message ?? 'Error';
      return DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        error: ApiException(code, message, statusCode: error.response?.statusCode),
        message: message,
      );
    }
    return error;
  }
}

ApiException? asApiException(Object error) {
  if (error is ApiException) return error;
  if (error is DioException && error.error is ApiException) {
    return error.error as ApiException;
  }
  return null;
}
