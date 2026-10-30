import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config/store_config.dart';
import '../../domain/entities/address.dart';
import '../../utils/distance_calculator.dart';

enum DeliveryMode { pickup, delivery }

/// Provider managing checkout delivery options, fee computation, and order parameters.
class DeliveryProvider extends ChangeNotifier {
  String _type = 'pickup'; // 'pickup' or 'delivery'
  String? _selectedAddressId;
  String? _selectedAddressText;
  double? _selectedLat;
  double? _selectedLng;
  double _fee = 0.0;
  DateTime? _slot;
  String _instructions = '';
  StreamSubscription<AuthState>? _authSub;

  DeliveryProvider() {
    _initAuth();
  }

  void _initAuth() {
    try {
      _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        if (data.event == AuthChangeEvent.signedOut) {
          reset();
        }
      });
    } catch (_) {
      // Allows unit testing without initializing Supabase singleton
    }
  }

  String get type => _type;
  DeliveryMode get mode =>
      _type == 'delivery' ? DeliveryMode.delivery : DeliveryMode.pickup;
  bool get isDelivery => _type == 'delivery';
  bool get isPickup => _type == 'pickup';

  String? get selectedAddressId => _selectedAddressId;
  String? get selectedAddressText => _selectedAddressText;
  double? get selectedLat => _selectedLat;
  double? get selectedLng => _selectedLng;

  double get fee => _fee;
  DateTime? get slot => _slot;
  DateTime? get selectedSlot => _slot;
  String get instructions => _instructions;

  double? get distanceKm {
    if (_selectedLat == null || _selectedLng == null) return null;
    if (_selectedLat!.isNaN || _selectedLng!.isNaN) return null;
    return DistanceCalculator.calculateDistanceKm(
      lat1: StoreConfig.storeLat,
      lng1: StoreConfig.storeLng,
      lat2: _selectedLat!,
      lng2: _selectedLng!,
    );
  }

  bool get isAddressSet =>
      _selectedAddressText != null &&
      _selectedAddressText!.trim().isNotEmpty &&
      _selectedLat != null &&
      _selectedLng != null &&
      !_selectedLat!.isNaN &&
      !_selectedLng!.isNaN;

  bool get isWithinMaxKm {
    final km = distanceKm;
    return km != null && km <= StoreConfig.maxDeliveryKm;
  }

  /// Valid delivery requires address text, valid non-null coordinates, and within max km.
  bool get isValidDelivery => isAddressSet && isWithinMaxKm;

  /// Indicates if user selected an address that lacks coordinates.
  bool get needsMapLocation =>
      isDelivery &&
      _selectedAddressText != null &&
      (_selectedLat == null || _selectedLng == null);

  String? get validationError {
    if (isPickup) return null;
    if (_selectedAddressText == null || _selectedAddressText!.trim().isEmpty) {
      return "Please select a delivery address";
    }
    if (_selectedLat == null || _selectedLng == null) {
      return "Selected address has no GPS coordinates. Please pick on map.";
    }
    final km = distanceKm;
    if (km != null && km > StoreConfig.maxDeliveryKm) {
      return "Address is ${km.toStringAsFixed(1)} km away. Max delivery radius is ${StoreConfig.maxDeliveryKm.toInt()} km.";
    }
    return null;
  }

  void setType(String type) {
    if (_type != type) {
      _type = type;
      _recalculateFee();
      notifyListeners();
    }
  }

  void setMode(DeliveryMode mode) {
    setType(mode == DeliveryMode.delivery ? 'delivery' : 'pickup');
  }

  void selectAddress(Address address) {
    _selectedAddressId = address.id;
    _selectedAddressText = address.fullAddress;
    _selectedLat = address.lat;
    _selectedLng = address.lng;
    _recalculateFee();
    notifyListeners();
  }

  void setAddressDetails({
    String? id,
    required String text,
    required double? lat,
    required double? lng,
  }) {
    _selectedAddressId = id;
    _selectedAddressText = text;
    _selectedLat = lat;
    _selectedLng = lng;
    _recalculateFee();
    notifyListeners();
  }

  void clearSelectedAddress() {
    _selectedAddressId = null;
    _selectedAddressText = null;
    _selectedLat = null;
    _selectedLng = null;
    _recalculateFee();
    notifyListeners();
  }

  /// Sets time slot, rejecting slots in the past.
  bool setSlot(DateTime slot) {
    if (slot.isBefore(DateTime.now())) {
      return false;
    }
    _slot = slot;
    notifyListeners();
    return true;
  }

  void clearSlot() {
    _slot = null;
    notifyListeners();
  }

  void setInstructions(String text) {
    _instructions = text;
    notifyListeners();
  }

  void _recalculateFee() {
    if (_type == 'pickup') {
      _fee = 0.0;
      return;
    }
    if (_selectedLat == null || _selectedLng == null) {
      _fee = 0.0;
      return;
    }
    final km = distanceKm;
    if (km == null || km.isNaN) {
      _fee = 0.0;
      return;
    }
    final rawFee = StoreConfig.baseFee + (km * StoreConfig.perKmRate);
    _fee = double.parse(rawFee.toStringAsFixed(2));
  }

  /// Reset all delivery state after a successful order or on signOut.
  void reset() {
    _type = 'pickup';
    _selectedAddressId = null;
    _selectedAddressText = null;
    _selectedLat = null;
    _selectedLng = null;
    _fee = 0.0;
    _slot = null;
    _instructions = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
