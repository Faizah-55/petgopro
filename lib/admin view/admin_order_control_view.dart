import 'package:flutter/material.dart';
import 'package:petgo_clone/services/order_service.dart';
import 'package:petgo_clone/models/order_model.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderControlView extends StatefulWidget {
  const AdminOrderControlView({super.key});

  @override
  State<AdminOrderControlView> createState() => _AdminOrderControlViewState();
}

class _AdminOrderControlViewState extends State<AdminOrderControlView> {
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    setupRealtimeListener(); // ✅ التحديث اللحظي
  }

  Future<void> fetchOrders() async {
    final result =
        await OrderService(Supabase.instance.client).getAllOrders();
    setState(() {
      orders = result;
      isLoading = false;
    });
  }

  Future<void> updateStatus(String orderId, String newStatus) async {
    await OrderService(Supabase.instance.client)
        .updateOrderStatus(orderId, newStatus);
    fetchOrders(); // تحديث بعد التعديل
  }

  void setupRealtimeListener() {
    final supabase = Supabase.instance.client;
    supabase.channel('orders-updates').onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'orders',
      callback: (_) => fetchOrders(),
    ).subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'إدارة الطلبات',
        rightButton: SquareIconButton(
          icon: Icons.arrow_back_ios_new,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, index) {
                final order = orders[index];
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ المحتوى الأساسي
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.storeName,
                                  style: AppTheme.font16SemiBold.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'طلب رقم: #${order.orderId.substring(0, 6)}',
                                  style: AppTheme.font14Medium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'الحالة الحالية: ${order.status}',
                                  style: AppTheme.font13RegularGray,
                                ),
                                Text(
                                  'الإجمالي: ${order.totalPrice} ريال',
                                  style: AppTheme.font13RegularGray,
                                ),
                              ],
                            ),
                          ),
                          // ✅ زر تغيير الحالة
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              updateStatus(order.orderId, value);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                  value: 'جاري التجهيز',
                                  child: Text('جاري التجهيز')),
                              PopupMenuItem(
                                  value: 'جاهز للتوصيل',
                                  child: Text('جاهز للتوصيل')),
                              PopupMenuItem(
                                  value: 'الطلب بالطريق',
                                  child: Text('الطلب بالطريق')),
                              PopupMenuItem(
                                  value: 'طلبك قريب', child: Text('طلبك قريب')),
                              PopupMenuItem(
                                  value: 'تم التوصيل', child: Text('تم التوصيل')),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}