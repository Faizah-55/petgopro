import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:petgo_clone/models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];

  LatLng? _selectedLocation;
  double _deliveryPrice = 0.0;

  String? _storeName;
  String? _storeUrl;
  String? _storeId;

  // ✅ Getters للمتجر
  String get storeName => _storeName ?? '';
  String get storeUrl => _storeUrl ?? '';
  String get storeId => _storeId ?? '';

  // ✅ Setter للمتجر
  void setStoreInfo({required String name, required String url, required String id}) {
    _storeName = name;
    _storeUrl = url;
    _storeId  = id;

    notifyListeners();
  }

  List<CartItemModel> get items => List.unmodifiable(_items);
  double get deliveryPrice => _deliveryPrice;
  LatLng? get selectedLocation => _selectedLocation;

  void setSelectedLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setDeliveryPrice(double delPrice) {
    _deliveryPrice = delPrice;
    notifyListeners();
  }

  double get itemTotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => itemTotal + _deliveryPrice;

  void addItem(CartItemModel item) {
    final index = _items.indexWhere((element) =>
        element.productId == item.productId &&
        element.selectedWeight == item.selectedWeight);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(String productId, String? selectedWeight, int quantity) {
    final index = _items.indexWhere((element) =>
        element.productId == productId &&
        element.selectedWeight == selectedWeight);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeItem(String productId, String? selectedWeight) {
    _items.removeWhere((element) =>
        element.productId == productId &&
        element.selectedWeight == selectedWeight);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _deliveryPrice = 0.0;
    _selectedLocation = null;
    _storeName = null;
    _storeUrl = null;
    notifyListeners();
  }

  int getQuantity(String productId) {
    int totalQuantity = 0;
    for (var item in _items) {
      if (item.productId == productId) {
        totalQuantity += item.quantity;
      }
    }
    return totalQuantity;
  }

  void addOrUpdateProduct({
    required String productId,
    required String name,
    required double price,
    required int quantity,
    String? selectedWeight,
    String? imageUrl,
    String? shortDescription,
  }) {
    final index = _items.indexWhere((element) =>
        element.productId == productId &&
        element.selectedWeight == selectedWeight);

    if (index >= 0) {
      _items[index].quantity = quantity;
    } else {
      _items.add(CartItemModel(
        productId: productId,
        name: name,
        price: price,
        quantity: quantity,
        selectedWeight: selectedWeight,
        imageUrl: imageUrl,
        shortDescription: shortDescription,
      ));
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }
}