import 'dart:io';

import 'package:echo/core/app_settings.dart';
import 'package:echo/features/session/session_providers.dart';
import 'package:echo/firebase_options.dart';
import 'package:echo/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _echoChannel = AndroidNotificationChannel(
  'echo_default',
  'Echo',
  description: 'Echo alerts',
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Notification payloads are drawn by the system while the app is backgrounded.
  if (message.notification != null) return;

  final local = FlutterLocalNotificationsPlugin();
  await local.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
  await local
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_echoChannel);
  await _showLocal(local, message);
}

AppLocalizations _pushL10n() {
  final locale = PlatformDispatcher.instance.locale;
  try {
    return lookupAppLocalizations(locale);
  } catch (_) {
    return lookupAppLocalizations(const Locale('en'));
  }
}

({String title, String body}) _copyFor(RemoteMessage message) {
  final l10n = _pushL10n();
  switch (message.data['type']) {
    case 'boost':
      return (title: l10n.pushBoostTitle, body: l10n.pushBoostBody);
    case 'new_post':
      return (title: l10n.pushNewPostTitle, body: l10n.pushNewPostBody);
    default:
      final notification = message.notification;
      return (
        title: notification?.title ?? message.data['title']?.toString() ?? 'Echo',
        body: notification?.body ?? message.data['body']?.toString() ?? '',
      );
  }
}

Future<void> _showLocal(
  FlutterLocalNotificationsPlugin local,
  RemoteMessage message,
) async {
  final copy = _copyFor(message);
  await local.show(
    message.hashCode & 0x7fffffff,
    copy.title,
    copy.body,
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
    await androidPlugin?.createNotificationChannel(_echoChannel);

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
            locale: PlatformDispatcher.instance.locale.languageCode,
          );
    } catch (e) {
      debugPrint('Echo push: token sync failed ($e)');
    }
  }

  Future<void> _showForeground(RemoteMessage message) async {
    if (!_ref.read(appSettingsProvider).notificationsEnabled) return;
    await _showLocal(_local, message);
  }
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));
