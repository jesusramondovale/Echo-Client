import 'dart:io';

import 'package:echo/core/app_settings.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class PushService {
  PushService(this._ref);

  final Ref _ref;
  final _local = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      debugPrint('Echo push: Firebase not configured ($e). Skipping FCM.');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(
      const InitializationSettings(android: androidInit),
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'echo_default',
        'Echo',
        description: 'Echo alerts',
        importance: Importance.high,
      ),
    );

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen((_) {});

    _ready = true;
    await syncToken();
  }

  Future<void> syncToken() async {
    if (!_ready) return;
    final enabled = _ref.read(appSettingsProvider).notificationsEnabled;
    if (!enabled) return;

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      final platform = Platform.isIOS ? 'ios' : 'android';
      await _ref.read(echoApiProvider).registerPushToken(
            token: token,
            platform: platform,
          );
    } catch (e) {
      debugPrint('Echo push: token sync failed ($e)');
    }
  }

  Future<void> _showForeground(RemoteMessage message) async {
    if (!_ref.read(appSettingsProvider).notificationsEnabled) return;
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] ?? 'Echo';
    final body = notification?.body ?? message.data['body'] ?? '';
    await _local.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'echo_default',
          'Echo',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));
