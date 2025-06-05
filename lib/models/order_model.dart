// يمثل الطلب كامل


// يستخدم في عرض الطلبات السابقة و الحالية و كذا 

import 'package:petgo_clone/models/order_item_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final List<OrderItemModel>? items; 

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'created_at': createdAt.toIso8601String(),
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}