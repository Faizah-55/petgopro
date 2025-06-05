class SubCategory {
  final String id;
  final String name;
  final String animalTypeId;

  SubCategory({
    required this.id,
    required this.name,
    required this.animalTypeId,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      animalTypeId: json['animal_type_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'animal_type_id': animalTypeId,
    };
  }
}