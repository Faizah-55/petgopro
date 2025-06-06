class Product {
  final String id; 
  final String storeId; 
  final String name; 
  final double price; 
  final String shortDescription; 

  final String? description; 
  final String? imageUrl; 
  final String? extraImageUrl; 
  final String subCategoryId; 

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.price,
    required this.shortDescription,
    required this.subCategoryId,
    this.description,
    this.imageUrl,
    this.extraImageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num ).toDouble(),
      shortDescription: json['short_description'] as String,
      subCategoryId: json['sub_cat_id'] as String, 
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      extraImageUrl: json['extra_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'store_id': storeId,
      'name': name,
      'price': price,
      'short_description': shortDescription,
      'sub_cat_id': subCategoryId,
      'description': description,
      'image_url': imageUrl,
      'extra_image_url': extraImageUrl,
    };
  }
}