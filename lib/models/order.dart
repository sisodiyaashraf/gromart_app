import 'package:project_01/models/product.dart';

/// Order and OrderItem models for Gromart app and Supabase persistence.
class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String weight;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.image,
    this.weight = '',
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: (json['product_id'] ?? json['id'] ?? json['name'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
        image: (json['image'] ?? '').toString(),
        weight: (json['weight'] ?? '').toString(),
      );
}

class OrderModel {
  final String id;
  final String? userId;
  final DateTime date;
  final List<OrderItem> items;
  final double total;
  final String status;

  // Delivery fields
  final String? deliveryType; // 'pickup' or 'delivery'
  final String? deliveryAddressText;
  final double? deliveryLat;
  final double? deliveryLng;
  final double? deliveryFee;
  final DateTime? deliverySlot;
  final String? deliveryInstructions;

  OrderModel({
    required this.id,
    this.userId,
    required this.date,
    required dynamic items,
    required this.total,
    this.status = "pending",
    this.deliveryType,
    this.deliveryAddressText,
    this.deliveryLat,
    this.deliveryLng,
    this.deliveryFee,
    this.deliverySlot,
    this.deliveryInstructions,
  }) : items = _normalizeItems(items);

  static List<OrderItem> _normalizeItems(dynamic rawItems) {
    if (rawItems is List<OrderItem>) return rawItems;
    if (rawItems is List<ProductModel>) {
      return rawItems
          .map((p) => OrderItem(
                productId: p.name,
                name: p.name,
                price: p.price,
                quantity: 1,
                image: p.image,
                weight: p.weight,
              ))
          .toList();
    }
    if (rawItems is List) {
      return rawItems.map((e) {
        if (e is OrderItem) return e;
        if (e is ProductModel) {
          return OrderItem(
            productId: e.name,
            name: e.name,
            price: e.price,
            quantity: 1,
            image: e.image,
            weight: e.weight,
          );
        }
        if (e is Map<String, dynamic>) return OrderItem.fromJson(e);
        return OrderItem(productId: '', name: '', price: 0, image: '');
      }).toList();
    }
    return [];
  }

  /// Status labels:
  /// pending -> Placed
  /// confirmed -> Confirmed
  /// packing -> Packing
  /// out_for_delivery -> Out for delivery
  /// delivered -> Delivered
  /// cancelled -> Cancelled
  static String formatStatus(String? rawStatus) {
    switch (rawStatus?.toLowerCase().trim()) {
      case 'pending':
        return 'Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'packing':
        return 'Packing';
      case 'out_for_delivery':
        return 'Out for delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return rawStatus ?? 'Placed';
    }
  }

  String get displayStatus => formatStatus(status);

  /// Convert to JSON for Supabase insertion.
  /// Sends ONLY allowed client fields.
  /// Never id, status, created_at, delivery_address, payment_method, or payment_intent_id.
  Map<String, dynamic> toJson(String userId) => {
        "user_id": userId,
        "items": items.map((p) => p.toJson()).toList(),
        "total": total,
        "delivery_type": deliveryType,
        "delivery_address_text": deliveryAddressText,
        "delivery_lat": deliveryLat,
        "delivery_lng": deliveryLng,
        "delivery_fee": deliveryFee,
        "delivery_slot": deliverySlot?.toUtc().toIso8601String(),
        "delivery_instructions": deliveryInstructions,
      };

  /// Tolerates null items/user_id, reads created_at as local time.
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: (json["id"] ?? "").toString(),
        userId: json["user_id"] as String?,
        date: json["created_at"] != null
            ? DateTime.parse(json["created_at"] as String).toLocal()
            : DateTime.now(),
        items: (json["items"] as List?)
                ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        total: (json["total"] as num?)?.toDouble() ?? 0.0,
        status: (json["status"] as String?) ?? "pending",
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

  // Helper for UI preview
  static List<OrderModel> getOrders() => [
        OrderModel(
          id: "#1001",
          date: DateTime(2025, 9, 20),
          total: 25.50,
          status: "delivered",
          items: [
            OrderItem(
              productId: "1",
              name: "Broccoli",
              price: 5.0,
              weight: "500g",
              image: "assets/images/broccali.png",
            ),
            OrderItem(
              productId: "2",
              name: "Banana",
              price: 2.5,
              weight: "1kg",
              image: "assets/images/milk.png",
            ),
          ],
        ),
      ];
}
