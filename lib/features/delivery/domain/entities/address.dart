/// Address domain entity.
class Address {
  final String id;
  final String? userId;
  final String label;
  final String line1;
  final String? line2;
  final String city;
  final String? state;
  final String? zip;
  final double lat;
  final double lng;
  final bool isDefault;

  const Address({
    required this.id,
    this.userId,
    required this.label,
    required this.line1,
    this.line2,
    required this.city,
    this.state,
    this.zip,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = [line1, line2, city, state, zip]
        .where((s) => s != null && s.trim().isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  Address copyWith({
    String? id,
    String? userId,
    String? label,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? zip,
    double? lat,
    double? lng,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
