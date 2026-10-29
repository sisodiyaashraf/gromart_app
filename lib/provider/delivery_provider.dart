import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';


/// Enum for delivery mode.
enum DeliveryMode { pickup, delivery }

/// Provider that handles delivery options and fee calculation.
class DeliveryProvider extends ChangeNotifier {
  DeliveryMode _mode = DeliveryMode.pickup;
  double _fee = 0.0;
  DateTime? _selectedSlot;
  String _instructions = '';
  LatLng? _selectedLocation;

  DeliveryMode get mode => _mode;
  double get fee => _fee;
  DateTime? get selectedSlot => _selectedSlot;
  String get instructions => _instructions;
  LatLng? get selectedLocation => _selectedLocation;

  bool get isDelivery => _mode == DeliveryMode.delivery;

  /// Switch between pickup and delivery.
  void setMode(DeliveryMode mode) {
    _mode = mode;
    // Reset delivery‑specific data when switching to pickup.
    if (mode == DeliveryMode.pickup) {
      _fee = 0.0;
      _selectedLocation = null;
      _selectedSlot = null;
      _instructions = '';
    }
    notifyListeners();
  }

  /// Update the delivery fee (e.g., after distance calculation).
  void updateFee(double fee) {
    _fee = fee;
    notifyListeners();
  }

  /// Set a delivery time slot.
  void setSlot(DateTime slot) {
    // Reject past slots.
    if (slot.isBefore(DateTime.now())) return;
    _selectedSlot = slot;
    notifyListeners();
  }

  /// Set additional instructions.
  void setInstructions(String text) {
    _instructions = text;
    notifyListeners();
  }

  /// Store the chosen location (lat/lng). Called after map picker.
  void setLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }

  /// Helper to clear all delivery data (used on checkout cancel).
  void clearDeliveryData() {
    if (_mode == DeliveryMode.delivery) {
      _fee = 0.0;
      _selectedLocation = null;
      _selectedSlot = null;
      _instructions = '';
    }
    notifyListeners();
  }
}
