import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:petgo_clone/models/cart_item_model.dart';



class CartProvider with ChangeNotifier {
  // قائمة العناصر في السلة
  final List<CartItemModel> _items = [];

  LatLng? _selectedLocation;

  List<CartItemModel> get items => List.unmodifiable(_items);

  double _deliveryPrice = 0.0; // سعر التوصيل

  // getter لسعر التوصيل
  double get deliveryPrice => _deliveryPrice;

  LatLng? get selectedLocation => _selectedLocation;

  void setSelectedLocation(LatLng location) { //  Setter للموقع
    _selectedLocation = location;
    notifyListeners();
  }

  // setter لتحديث سعر التوصيل
  void setDeliveryPrice(double delPrice) {
    _deliveryPrice = delPrice;
    notifyListeners();
  }

  // حساب مجموع سعر المنتجات في السلة بدون التوصيل
  double get itemTotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // حساب عدد المنتجات في السلة
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  // حساب المجموع الكلي (منتجات + توصيل)
  double get totalPrice => itemTotal + _deliveryPrice;

  // إضافة أو تحديث عنصر في السلة (إذا المنتج مع نفس الوزن موجود، نزود الكمية)
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

  // تحديث كمية عنصر معين في السلة
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

  // حذف عنصر معين من السلة
  void removeItem(String productId, String? selectedWeight) {
    _items.removeWhere((element) =>
        element.productId == productId &&
        element.selectedWeight == selectedWeight);
    notifyListeners();
  }

  // مسح كل العناصر في السلة
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // جلب كمية منتج معين (بناءً على productId فقط - لو تبي تفرق بين الأوزان تحتاج تعديل)
  int getQuantity(String productId) {
    int totalQuantity = 0;
    for (var item in _items) {
      if (item.productId == productId) {
        totalQuantity += item.quantity;
      }
    }
    return totalQuantity;
  }

  // إضافة أو تحديث منتج عن طريق بيانات مباشرة (يدعم selectedWeight اختياري)
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
      // لو موجود نفس المنتج بنفس الوزن نحدث الكمية
      _items[index].quantity = quantity;
    } else {
      // غير موجود نضيف عنصر جديد
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

  // حذف منتج كامل (بناءً على productId فقط، بدون وزن معين)
  void removeProduct(String productId) {
    _items.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }
}