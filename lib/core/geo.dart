import 'dart:math' as math;

class EchoGeo {
  /// Great-circle distance in kilometers.
  static double distanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const earthRadiusKm = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// e.g. `2.3km` (prefix like "A " comes from l10n).
  static String formatKm(double km) => '${km.toStringAsFixed(1)}km';

  static double _rad(double deg) => deg * math.pi / 180.0;
}
