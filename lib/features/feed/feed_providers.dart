import 'package:echo/core/echo_api.dart';
import 'package:echo/core/models.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedState {
  const FeedState({
    required this.items,
    this.nextCursor,
    this.loadingMore = false,
    this.refreshing = false,
    this.error,
  });

  final List<PostSummary> items;
  final String? nextCursor;
  final bool loadingMore;
  final bool refreshing;
  final String? error;

  FeedState copyWith({
    List<PostSummary>? items,
    String? nextCursor,
    bool? loadingMore,
    bool? refreshing,
    String? error,
    bool clearError = false,
  }) {
    return FeedState(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class FeedNotifier extends AsyncNotifier<FeedState> {
  @override
  Future<FeedState> build() async {
    final fix = await ref.read(locationServiceProvider).currentFix();
    final page = await ref.read(echoApiProvider).getFeed(
          lat: fix.latitude,
          lon: fix.longitude,
        );
    return FeedState(items: page.items, nextCursor: page.nextCursor);
  }

  Future<void> refresh() async {
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData(current.copyWith(refreshing: true, clearError: true));
    }
    try {
      final fix = await ref.read(locationServiceProvider).currentFix();
      final page = await ref.read(echoApiProvider).getFeed(
            lat: fix.latitude,
            lon: fix.longitude,
          );
      state = AsyncData(
        FeedState(items: page.items, nextCursor: page.nextCursor),
      );
    } catch (e) {
      final api = asApiException(e);
      state = AsyncData(
        (current ?? const FeedState(items: [])).copyWith(
          refreshing: false,
          error: api?.message ?? e.toString(),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null ||
        current.nextCursor == null ||
        current.loadingMore) {
      return;
    }
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final fix = await ref.read(locationServiceProvider).currentFix();
      final page = await ref.read(echoApiProvider).getFeed(
            lat: fix.latitude,
            lon: fix.longitude,
            cursor: current.nextCursor,
          );
      state = AsyncData(
        FeedState(
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor,
        ),
      );
    } catch (e) {
      final api = asApiException(e);
      state = AsyncData(
        current.copyWith(
          loadingMore: false,
          error: api?.message ?? e.toString(),
        ),
      );
    }
  }

  void prepend(PostSummary post) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(items: [post, ...current.items]),
    );
  }
}

final feedProvider =
    AsyncNotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);
