import 'package:flutter/material.dart';

class PromoCodeProvider extends ChangeNotifier {
  double _discount = 0;
  bool _freeDelivery = false;
  String? _appliedCode;

  double get discount => _discount;
  bool get freeDelivery => _freeDelivery;
  String? get appliedCode => _appliedCode;

  // Available promo codes
  final Map<String, dynamic> _promoCodes = {
    "SAVE10": {"discount": 0.10, "freeDelivery": false},
    "FREESHIP": {"discount": 0.0, "freeDelivery": true},
    "WELCOME20": {"discount": 0.20, "freeDelivery": false},
  };

  /// Apply a promo code
  bool applyPromo(String code, double subtotal) {
    final promo = _promoCodes[code.toUpperCase()];
    if (promo != null) {
      _appliedCode = code.toUpperCase();
      _discount = subtotal * (promo["discount"] as double);
      _freeDelivery = promo["freeDelivery"] as bool;
      notifyListeners();
      return true;
    } else {
      _appliedCode = null;
      _discount = 0;
      _freeDelivery = false;
      notifyListeners();
      return false;
    }
  }

  /// Reset promo
  void clearPromo() {
    _appliedCode = null;
    _discount = 0;
    _freeDelivery = false;
    notifyListeners();
  }
}
