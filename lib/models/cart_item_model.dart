// يمثل عنصر واحد بالسلة 

//ادارة السلة داخل التطبيق 
//اقدر اعدل خصائص المنتج داخل السلة
//اقدر باستخدامه احسب السعر الكلي



class CartItemModel {
  final String productId;
  final String name;
  final double price;
  int quantity;
  final String? selectedWeight;
  final String? imageUrl;
  final String? shortDescription;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
   this.selectedWeight,
    this.imageUrl,
    this.shortDescription,
  });

  double get itemTotal => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      selectedWeight: json['selected_weight'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'selected_weight': selectedWeight,
      'image_url': imageUrl,
    };
  }
}