import 'package:petgo_clone/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Store>> getAllStores() async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('stores').select();

  final data = response as List;

  return data.map((json) => Store.fromJson(json)).toList();
}
