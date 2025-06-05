import 'package:petgo_clone/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Store>> getAllStores() async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('stores').select();

  final data = response as List;

  return data.map((json) => Store.fromJson(json)).toList();
}
  

Future<Store?> getStoreById(String storeId) async {
  final supabase = Supabase.instance.client;

  final data = await supabase
      .from('stores')
      .select()
      .eq('store_id', storeId)
      .maybeSingle();

  if (data == null || data is! Map<String, dynamic>) return null;

  return Store.fromJson(data);
}


//عشان ننتقل للمتجر المفعل فقط 
Future<Store?> getActiveStore() async {
  final supabase = Supabase.instance.client;

  final data = await supabase
      .from('stores')
      .select()
      .eq('is_active', true)
      .maybeSingle();

  if (data == null || data is! Map<String, dynamic>) return null;

  return Store.fromJson(data);
}