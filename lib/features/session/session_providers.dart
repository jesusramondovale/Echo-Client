import 'package:echo/core/echo_api.dart';
import 'package:echo/core/secure_store.dart';
import 'package:echo/features/location/location_service.dart';
import 'package:echo/features/media/face_gate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

final echoApiProvider = Provider<EchoApi>((ref) {
  return EchoApi(ref.watch(secureStoreProvider));
});

final locationServiceProvider =
    Provider<LocationService>((ref) => LocationService());

final faceGateProvider = Provider<FaceGate>((ref) {
  final gate = FaceGate();
  ref.onDispose(() {
    gate.dispose();
  });
  return gate;
});

enum AppPhase { bootstrapping, needsLocation, ready, error }

class AppBootstrapState {
  const AppBootstrapState({
    required this.phase,
    this.errorMessage,
  });

  final AppPhase phase;
  final String? errorMessage;
}

class AppBootstrapNotifier extends AsyncNotifier<AppBootstrapState> {
  @override
  Future<AppBootstrapState> build() async {
    try {
      final api = ref.read(echoApiProvider);
      await api.bootstrap();
      final location = ref.read(locationServiceProvider);
      final ok = await location.ensurePermission();
      if (!ok) {
        return const AppBootstrapState(phase: AppPhase.needsLocation);
      }
      return const AppBootstrapState(phase: AppPhase.ready);
    } catch (e) {
      return AppBootstrapState(
        phase: AppPhase.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }

  Future<void> requestLocationAgain() async {
    final location = ref.read(locationServiceProvider);
    final ok = await location.ensurePermission();
    if (ok) {
      state = const AsyncData(AppBootstrapState(phase: AppPhase.ready));
    } else {
      state = const AsyncData(AppBootstrapState(phase: AppPhase.needsLocation));
    }
  }

  Future<void> resetIdentity() async {
    await ref.read(secureStoreProvider).resetIdentity();
    await retry();
  }
}

final appBootstrapProvider =
    AsyncNotifierProvider<AppBootstrapNotifier, AppBootstrapState>(
  AppBootstrapNotifier.new,
);
