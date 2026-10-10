import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    required this.darkMode,
    required this.notificationsEnabled,
  });

  final bool darkMode;
  final bool notificationsEnabled;

  AppSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const _darkKey = 'echo_dark_mode';
  static const _notifKey = 'echo_notifications';

  @override
  AppSettings build() {
    Future.microtask(_load);
    return const AppSettings(darkMode: false, notificationsEnabled: true);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      darkMode: prefs.getBool(_darkKey) ?? false,
      notificationsEnabled: prefs.getBool(_notifKey) ?? true,
    );
  }

  Future<void> setDarkMode(bool value) async {
    state = state.copyWith(darkMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifKey, value);
  }

  ThemeMode get themeMode =>
      state.darkMode ? ThemeMode.dark : ThemeMode.light;
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);
