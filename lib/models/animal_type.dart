class AnimalType {
  final String id;
  final String name;
  final int sortOrder;

  AnimalType({required this.id, required this.name, required this.sortOrder});

  factory AnimalType.fromJson(Map<String, dynamic> json) {
    return AnimalType(
      id: json['animal_id'],
      name: json['name'],
      sortOrder : json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'animal_id': id,
      'name': name,
      'sortOrder' : sortOrder,
    };
  }
}