import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // ✅ Add Product with Quantity
  void addProduct(ProductModel product, int quantity) {
    final index = _cartItems.indexWhere(
      (item) => item['product'].name == product.name,
    );

    if (index >= 0) {
      // If already in cart, increase quantity
      _cartItems[index]['quantity'] += quantity;
    } else {
      // Add new item
      _cartItems.add({'product': product, 'quantity': quantity});
    }

    notifyListeners();
  }

  // ✅ Remove a product
  void removeProduct(ProductModel product) {
    _cartItems.removeWhere((item) => item['product'].name == product.name);
    notifyListeners();
  }

  // ✅ Update quantity
  void updateQuantity(ProductModel product, int quantity) {
    final index = _cartItems.indexWhere(
      (item) => item['product'].name == product.name,
    );

    if (index >= 0) {
      _cartItems[index]['quantity'] = quantity;
      notifyListeners();
    }
  }

  // ✅ Clear Cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // ✅ Total Price
  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item['product'].price * item['quantity'];
    }
    return total;
  }
}
