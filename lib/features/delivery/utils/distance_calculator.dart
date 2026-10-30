import 'dart:math' as math;

/// Utility class for geographic distance calculation using the Haversine formula.
class DistanceCalculator {
  static const double _earthRadiusKm = 6371.0;

  const DistanceCalculator._();

  /// Calculates the great-circle distance between two coordinates in kilometers.
  static double calculateDistanceKm({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final dLat = _degToRad(lat2 - lat1);
    final dLng = _degToRad(lng2 - lng1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  static double _degToRad(double degrees) => degrees * (math.pi / 180.0);
}
