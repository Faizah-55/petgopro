// يمثل عنصر واحد داخل الطلب 

// يحفظ تفاصيل كل منتج داخل الطلب
// بحيث في صفحة الطلبات السابقة و الحالية نقدر نشوف تفاصيل المنتجات الخاصة بكل طلب 


class OrderItemModel {
  final int? id;
  final String orderId;
  final String productId;
  final int quantity;
  final String? selectedWeight;
  final double price;
  final double itemTotal; // السعر × الكمية

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    this.selectedWeight,
    required this.price,
    required this.itemTotal,
  });



  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int?,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int,
      selectedWeight: json['selected_weight'] as String,
      price: (json['price'] as num).toDouble(),
      itemTotal: (json['item_total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'selected_weight': selectedWeight,
      'price': price,
      'item_total': itemTotal,
    };
  }
}