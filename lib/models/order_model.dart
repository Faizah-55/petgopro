import 'package:petgo_clone/models/order_item_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String status;
  final double totalPrice;
  final double deliveryFee; // ✅ جديد
  final DateTime createdAt;
  final String storeName;
  final String storeUrl;
  final double latitude;
  final double longitude;
  final List<OrderItemModel>? items;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.deliveryFee, // ✅ جديد
    required this.createdAt,
    required this.storeName,
    required this.storeUrl,
    required this.latitude,
    required this.longitude,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? '',
      userId: json['user_id'] ?? '',
      status: json['status'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0, // ✅ جديد
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      storeName: json['store_name'] ?? '',
      storeUrl: json['store_url'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => OrderItemModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'status': status,
      'total_price': totalPrice,
      'delivery_fee': deliveryFee, // ✅ جديد
      'created_at': createdAt.toIso8601String(),
      'store_name': storeName,
      'store_url': storeUrl,
      'latitude': latitude,
      'longitude': longitude,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}