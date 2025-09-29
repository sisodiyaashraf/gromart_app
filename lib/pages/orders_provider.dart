import 'package:flutter/material.dart';
import 'package:project_01/models/order.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(OrderModel order) {
    _orders.insert(0, order); // newest first
    notifyListeners();
  }
}
