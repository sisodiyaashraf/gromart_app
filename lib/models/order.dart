import 'dart:ui';

import 'package:project_01/models/product.dart';

class OrderModel {
  final String id;
  final DateTime date;
  final List<ProductModel> items;
  final double total;
  final String status;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = "Pending",
  });

  // Dummy orders
  static List<OrderModel> getOrders() {
    return [
      OrderModel(
        id: "#1001",
        date: DateTime(2025, 9, 20),
        total: 25.50,
        status: "Delivered",
        items: [
          ProductModel(
            name: "Broccoli",
            price: 5.0,
            weight: "500g",
            image: "assets/images/broccali.png",
            boxColor: const Color(0xFFE8F5E9),
            unit: '4',
            category: "Vegetable",
          ),
          ProductModel(
            name: "Milk",
            price: 15.5,
            weight: "1L",
            image: "assets/images/milk.png",
            boxColor: const Color(0xFFE3F2FD),
            unit: '3',
            category: "Sweet",
          ),
        ],
      ),
      OrderModel(
        id: "#1002",
        date: DateTime(2025, 9, 19),
        total: 12.75,
        status: "Pending",
        items: [
          ProductModel(
            name: "Tomato",
            price: 7.5,
            weight: "1kg",
            image: "assets/images/broccali.png",
            boxColor: const Color(0xFFFFEBEE),
            unit: '1',
            category: "Vegetable",
          ),
          ProductModel(
            name: "Banana",
            price: 5.25,
            weight: "1 Dozen",
            image: "assets/images/milk.png",
            boxColor: const Color(0xFFFFF9C4),
            unit: '2',
            category: "Vegetable",
          ),
        ],
      ),
    ];
  }
}
