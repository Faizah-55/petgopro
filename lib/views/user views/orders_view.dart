import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/order_tracking_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/current_order_card.dart';
import 'package:petgo_clone/models/order_model.dart';
import 'package:petgo_clone/services/order_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  bool isCurrentTab = true;
  List<OrderModel> allOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    listenToRealtimeUpdates();
  }

  Future<void> fetchOrders() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final orderService = OrderService(Supabase.instance.client);
    final fetchedOrders = await orderService.getOrdersByUser(userId);

    setState(() {
      allOrders = fetchedOrders;
      isLoading = false;
    });
  }

  void listenToRealtimeUpdates() {
    final supabase = Supabase.instance.client;

    supabase
        .channel('orders-realtime-user')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (_) async {
            await fetchOrders(); // ✅ هنا لازم async/await
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    final currentOrders =
        allOrders.where((o) => o.status != 'تم التوصيل').toList();
    final previousOrders =
        allOrders.where((o) => o.status == 'تم التوصيل').toList();

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: 'الطلبات', showShadow: true),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton('الحالية', isCurrentTab, () {
                    setState(() => isCurrentTab = true);
                  }),
                  const SizedBox(width: 8),
                  _buildTabButton('السابقة', !isCurrentTab, () {
                    setState(() => isCurrentTab = false);
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (isCurrentTab ? currentOrders : previousOrders).isEmpty
                    ? const Center(child: Text('لا يوجد طلبات'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          isCurrentTab
                              ? currentOrders.length
                              : previousOrders.length,
                     itemBuilder: (context, index) {
  final order =
      isCurrentTab ? currentOrders[index] : previousOrders[index];

  return CurrentOrderCard(
    storeName: order.storeName,
    status: order.status,
    imageUrl: order.storeUrl,
    totalPrice: order.totalPrice,
    buttonText: order.status == 'تم التوصيل'
        ? 'تفاصيل الطلب'
        : 'تتبع الطلب',
    onTrackPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderTrackingView(
            orderId: order.orderId,
            location: (order.latitude != 0 && order.longitude != 0)
                ? LatLng(order.latitude, order.longitude)
                : null,
            status: order.status,
            items: order.items ?? [],
            deliveryFee: order.deliveryFee,
            totalPrice: order.totalPrice,
          ),
        ),
      );
      fetchOrders();
    },
  );
}
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.greenLocationColor : AppTheme.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Text(
          title,
          style: AppTheme.font15SemiBold.copyWith(
            color: selected ? AppTheme.whiteColor : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
