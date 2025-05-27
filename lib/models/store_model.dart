class Store {
  final String name;
  final String description;
  final String logoUrl;
  final double rating;
  final double distanceKm;
  final double deliveryPrice;

  Store({
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.rating,
    required this.distanceKm,
    required this.deliveryPrice,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      deliveryPrice: (json['delivery_price'] ?? 0).toDouble(),
    );
  }
}
