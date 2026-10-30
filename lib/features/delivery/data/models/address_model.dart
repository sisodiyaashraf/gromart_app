import '../../domain/entities/address.dart';

/// Address model for serialization to/from Supabase.
class AddressModel extends Address {
  const AddressModel({
    required super.id,
    super.userId,
    required super.label,
    required super.line1,
    super.line2,
    required super.city,
    super.state,
    super.zip,
    required super.lat,
    required super.lng,
    super.isDefault,
  });

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      label: entity.label,
      line1: entity.line1,
      line2: entity.line2,
      city: entity.city,
      state: entity.state,
      zip: entity.zip,
      lat: entity.lat,
      lng: entity.lng,
      isDefault: entity.isDefault,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: (json['id'] ?? '').toString(),
      userId: json['user_id'] as String?,
      label: (json['label'] ?? 'Home').toString(),
      line1: (json['line1'] ?? '').toString(),
      line2: json['line2'] as String?,
      city: (json['city'] ?? '').toString(),
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  /// Sends ONLY allowed columns for inserting into Supabase addresses table.
  /// Never sends id, created_at, or updated_at.
  Map<String, dynamic> toInsertJson(String userId) => {
        'user_id': userId,
        'label': label,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'zip': zip,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      };

  /// Sends ONLY allowed columns for updating in Supabase addresses table.
  /// Sets updated_at to UTC timestamp. Never sends id, user_id, or created_at.
  Map<String, dynamic> toUpdateJson() => {
        'label': label,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'zip': zip,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

  Map<String, dynamic> toJson({String? userId}) => {
        if (userId != null) 'user_id': userId,
        if (id.isNotEmpty) 'id': id,
        'label': label,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'zip': zip,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      };
}
