import 'package:flutter/material.dart';
import 'package:petgo_clone/services/favorite_service.dart';

class FavoriteProvider with ChangeNotifier {
  List<String> _favoriteStoreIds = [];

  List<String> get favoriteStoreIds => _favoriteStoreIds;

  bool isFavorite(String storeId) {
    return _favoriteStoreIds.contains(storeId);
  }

  Future<void> fetchFavorites() async {
    _favoriteStoreIds = await FavoriteService.getFavoritesIds();
    notifyListeners();
  }

  Future<void> toggleFavorite(String storeId) async {
    if (_favoriteStoreIds.contains(storeId)) {
      await FavoriteService.removeFromFavorites(storeId);
      _favoriteStoreIds.remove(storeId);
    } else {
      await FavoriteService.addToFavorites(storeId);
      _favoriteStoreIds.add(storeId);
    }
    notifyListeners();
  }
}