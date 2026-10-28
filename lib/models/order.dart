import 'dart:ui';
import 'package:project_01/models/product.dart';

/// Order model used throughout the app.
/// Includes optional delivery information.
class OrderModel {
  // Core fields
  final String id;
  final DateTime date;
  final List<ProductModel> items;
  final double total;
  final String status;

  // Delivery fields (optional)
  final String? deliveryType; // 'pickup' or 'delivery'
  final String? deliveryAddressText;
  final double? deliveryLat;
  final double? deliveryLng;
  final double? deliveryFee;
  final DateTime? deliverySlot;
  final String? deliveryInstructions;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = "Pending",
    this.deliveryType,
    this.deliveryAddressText,
    this.deliveryLat,
    this.deliveryLng,
    this.deliveryFee,
    this.deliverySlot,
    this.deliveryInstructions,
  });

  /// Convert to JSON for Supabase insertion.
  /// `userId` is the authenticated user's UUID.
  Map<String, dynamic> toJson(String userId) => {
        "user_id": userId,
        "items": items
            .map((p) => {
                  "product_id": p.name, // placeholder: using name as id
                  "name": p.name,
                  "price": p.price,
                  "quantity": 1,
                  "image": p.image,
                })
            .toList(),
        "total": total,
        "delivery_type": deliveryType,
        "delivery_address_text": deliveryAddressText,
        "delivery_lat": deliveryLat,
        "delivery_lng": deliveryLng,
        "delivery_fee": deliveryFee,
        "delivery_slot": deliverySlot?.toUtc().toIso8601String(),
        "delivery_instructions": deliveryInstructions,
        "status": status,
        "created_at": date.toUtc().toIso8601String(),
      };

  /// Build an OrderModel from Supabase JSON.
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"] as String,
        date: DateTime.parse(json["created_at"] as String).toLocal(),
        items: (json["items"] as List)
            .map((e) => ProductModel(
                  name: e["name"] as String,
                  price: (e["price"] as num).toDouble(),
                  weight: "",
                  image: e["image"] as String,
                  boxColor: const Color(0xFFE0E0E0),
                  unit: "1",
                  category: "",
                ))
            .toList(),
        total: (json["total"] as num).toDouble(),
        status: json["status"] as String,
        deliveryType: json["delivery_type"] as String?,
        deliveryAddressText: json["delivery_address_text"] as String?,
        deliveryLat: (json["delivery_lat"] as num?)?.toDouble(),
        deliveryLng: (json["delivery_lng"] as num?)?.toDouble(),
        deliveryFee: (json["delivery_fee"] as num?)?.toDouble(),
        deliverySlot: json["delivery_slot"] != null
            ? DateTime.parse(json["delivery_slot"] as String).toLocal()
            : null,
        deliveryInstructions: json["delivery_instructions"] as String?,
      );

  // Dummy data for UI preview – delivery fields are left null.
  static List<OrderModel> getOrders() => [
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
