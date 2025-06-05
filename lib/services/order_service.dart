import 'package:petgo_clone/models/order_item_model.dart';
import 'package:petgo_clone/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final SupabaseClient supabase;

  OrderService(this.supabase);

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final data = await supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false) as List<dynamic>;

      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<void> addOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      // Insert order without order_id (let Supabase auto-generate it)
      final response = await supabase.from('orders').insert({
        'user_id': order.userId,
        'status': order.status,
        'total_price': order.totalPrice,
        'created_at': order.createdAt.toIso8601String(),
      }).select().single();

      // Extract the generated order_id
      final String generatedOrderId = response['order_id'] as String;

      // Prepare items with generated order_id
      final itemsToInsert = items.map((item) {

        return {
          'order_id': generatedOrderId,
          'product_id': item.productId,
          'quantity': item.quantity,
          'selected_weight': item.selectedWeight,
          'price': item.price,
          'item_total':item.price * item.quantity,
        };
      }).toList();

      // Insert order items linked to the generated order_id
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