import 'package:petgo_clone/models/order_item_model.dart';
import 'package:petgo_clone/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final SupabaseClient supabase;

  OrderService(this.supabase);

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final ordersData = await supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false) as List;

      List<OrderModel> orders = [];

      for (final json in ordersData) {
        final orderId = json['order_id'] as String;

        final orderItemsData =
            await supabase.from('order_items').select().eq('order_id', orderId) as List;

        final items =
            orderItemsData.map((e) => OrderItemModel.fromJson(e)).toList();

        orders.add(
          OrderModel.fromJson({
            ...json,
            'items': items.map((e) => e.toJson()).toList(),
          }),
        );
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// ✅ دالة جديدة للأدمن: ترجع جميع الطلبات
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final ordersData = await supabase
          .from('orders')
          .select()
          .order('created_at', ascending: false) as List;

      List<OrderModel> orders = [];

      for (final json in ordersData) {
        final orderId = json['order_id'] as String;

        final orderItemsData =
            await supabase.from('order_items').select().eq('order_id', orderId) as List;

        final items =
            orderItemsData.map((e) => OrderItemModel.fromJson(e)).toList();

        orders.add(
          OrderModel.fromJson({
            ...json,
            'items': items.map((e) => e.toJson()).toList(),
          }),
        );
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch all orders: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await supabase
          .from('orders')
          .update({'status': newStatus})
          .eq('order_id', orderId);
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }

  Future<void> addOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      final response = await supabase
          .from('orders')
          .insert({
            'user_id': order.userId,
            'status': order.status,
            'delivery_fee': order.deliveryFee,
            'total_price': order.totalPrice,
            'created_at': order.createdAt.toIso8601String(),
            'store_name': order.storeName,
            'store_url': order.storeUrl,
            'latitude': order.latitude,
            'longitude': order.longitude,
          })
          .select('order_id')
          .single();

      final String generatedOrderId = response['order_id'] as String;

      final itemsToInsert = items.map((item) {
        return {
          'order_id': generatedOrderId,
          'product_id': item.productId,
          'product_name': item.productName,
          'quantity': item.quantity,
          'selected_weight': item.selectedWeight,
          'price': item.price,
          'item_total': item.price * item.quantity,
        };
      }).toList();

      await supabase.from('order_items').insert(itemsToInsert);
    } catch (e) {
      throw Exception('Failed to add order or order items: $e');
    }
  }

  Future<List<OrderItemModel>> getOrderItems(String orderId) async {
    try {
      final data = await supabase
          .from('order_items')
          .select()
          .eq('order_id', orderId) as List<dynamic>;

      return data.map((json) => OrderItemModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch order items: $e');
    }
  }
}