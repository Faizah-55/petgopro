import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteService {
  static final _supabase = Supabase.instance.client;

  static Future<void> addToFavorites(String storeId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('favorites').insert({
      'user_id': userId,
      'store_id': storeId,
    });
  }

  static Future<void> removeFromFavorites(String storeId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('store_id', storeId);
  }

  static Future<List<String>> getFavoritesIds() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final res = await _supabase
        .from('favorites')
        .select('store_id')
        .eq('user_id', userId);

    return (res as List).map((e) => e['store_id'] as String).toList();
  }
}