import 'package:flutter/material.dart';


/// Model representing a user address.
class UserAddress {
  final String id; // unique identifier, can be generated locally (uuid) before sync
  final String label; // e.g., "Home", "Work"
  final String addressLine;
  final double latitude;
  final double longitude;
  bool isDefault;

  UserAddress({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'address_line': addressLine,
        'lat': latitude,
        'lng': longitude,
        'is_default': isDefault,
      };

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json['id'] as String,
        label: json['label'] as String,
        addressLine: json['address_line'] as String,
        latitude: (json['lat'] as num).toDouble(),
        longitude: (json['lng'] as num).toDouble(),
        isDefault: json['is_default'] as bool? ?? false,
      );
}

/// Provider that manages user saved addresses.
class AddressProvider extends ChangeNotifier {
  final List<UserAddress> _addresses = [];

  List<UserAddress> get addresses => List.unmodifiable(_addresses);

  UserAddress? get defaultAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere((a) => a.isDefault, orElse: () => _addresses.first);
  }

  /// Adds a new address. If this is the first address, it becomes the default.
  void addAddress(UserAddress address) {
    if (_addresses.isEmpty) {
      address.isDefault = true;
    }
    _addresses.add(address);
    notifyListeners();
  }

  /// Updates an existing address by id.
  void updateAddress(String id, UserAddress newAddress) {
    final index = _addresses.indexWhere((a) => a.id == id);
    if (index != -1) {
      _addresses[index] = newAddress;
      notifyListeners();
    }
  }

  /// Deletes an address. If the deleted address was default, promote the first one.
  void deleteAddress(String id) {
    final wasDefault = _addresses.any((a) => a.id == id && a.isDefault);
    _addresses.removeWhere((a) => a.id == id);
    if (wasDefault && _addresses.isNotEmpty) {
      _addresses.first.isDefault = true;
    }
    notifyListeners();
  }

  /// Sets an address as the default, clearing previous default.
  void setDefault(String id) {
    for (final a in _addresses) {
      a.isDefault = a.id == id;
    }
    notifyListeners();
  }
}
