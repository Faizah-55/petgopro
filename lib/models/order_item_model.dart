class OrderItemModel {
  final String? id;
  final String orderId;
  final String productId;
  final String productName; // ✅ جديد
  final int quantity;
  final String? selectedWeight;
  final double price;
  final double itemTotal;

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName, // ✅ جديد
    required this.quantity,
    this.selectedWeight,
    required this.price,
    required this.itemTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String?,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String? ?? '', // ✅ جديد
      quantity: json['quantity'] as int,
      selectedWeight: json['selected_weight'] as String?,
      price: (json['price'] as num).toDouble(),
      itemTotal: (json['item_total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName, // ✅ جديد
      'quantity': quantity,
      'selected_weight': selectedWeight,
      'price': price,
      'item_total': itemTotal,
    };
  }
}