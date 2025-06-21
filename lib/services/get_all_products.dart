import 'package:petgo_clone/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petgo_clone/models//animal_type.dart';
import 'package:petgo_clone/models/sub_category.dart';

class StoreDataService {
  final supabase = Supabase.instance.client;

 Future<List<AnimalType>> getAnimalTypes() async {
  final response = await supabase
      .from('animal_types') 
      .select()
      .order('sort_order', ascending: true); 

  return (response as List)
      .map((json) => AnimalType.fromJson(json))
      .toList();
}
  Future<List<SubCategory>> getSubCategories(String animalTypeId) async {
    final response = await supabase
        .from('sub_category')
        .select()
        .eq('animal_type_id', animalTypeId);
    return (response as List).map((json) => SubCategory.fromJson(json)).toList();
  }

  Future<List<Product>> getProducts(String subCategoryId) async {
    final response = await supabase
        .from('products')
        .select()
        .eq('sub_cat_id', subCategoryId);
    return (response as List).map((json) => Product.fromJson(json)).toList();
  }
}