class AppConfig {
  /// Override with `--dart-define=API_BASE_URL=...` if needed.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://83.54.52.239',
  );

  static const feedRadiusKm = 15;
}
