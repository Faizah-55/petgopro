import 'package:flutter/material.dart';
import 'package:petgo_clone/models/order_item_model.dart';
import 'package:petgo_clone/models/order_model.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/services/order_service.dart';
import 'package:petgo_clone/views/user%20views/order_success_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:moyasar/moyasar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoyasarPaymentView extends StatefulWidget {
  final double amount;
  final SupabaseClient supabase;

  const MoyasarPaymentView({
    super.key,
    required this.amount,
    required this.supabase,
  });

  @override
  State<MoyasarPaymentView> createState() => _MoyasarPaymentViewState();
}

class _MoyasarPaymentViewState extends State<MoyasarPaymentView> {
  late OrderService orderService;

  @override
  void initState() {
    super.initState();
    orderService = OrderService(widget.supabase);
  }

  void onPaymentResult(result) async {
    if (result is PaymentResponse && result.status == PaymentStatus.paid) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final userId = widget.supabase.auth.currentUser?.id ?? '';

      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('المستخدم غير مسجل دخول')),
        );
        return;
      }

      // استرجاع الموقع من جدول users
      final locationResponse = await widget.supabase
          .from('users')
          .select('latitude, longitude')
          .eq('user_id', userId)
          .single();

      final double latitude = (locationResponse['latitude'] as num).toDouble();
      final double longitude = (locationResponse['longitude'] as num).toDouble();

      final storeName = cartProvider.storeName;
      final storeUrl = cartProvider.storeUrl;
      final deliveryFee = cartProvider.deliveryPrice;

      // إنشاء الطلب
      final newOrder = OrderModel(
        orderId: '',
        userId: userId,
        status: 'بانتظار المندوب',
        totalPrice: widget.amount,
        deliveryFee: cartProvider.deliveryPrice,
        createdAt: DateTime.now(),
        storeName: storeName,
        storeUrl: storeUrl,
        latitude: latitude,
        longitude: longitude,
      );

      // إعداد عناصر الطلب
      final orderItems = cartProvider.items.map((cartItem) {
        return OrderItemModel(
          id: null,
          orderId: '',
          productId: cartItem.productId,
          productName: cartItem.name, // ✅ اسم المنتج
          quantity: cartItem.quantity,
          selectedWeight: cartItem.selectedWeight,
          price: cartItem.price,
          itemTotal: cartItem.itemTotal,
        );
      }).toList();

      try {
        await orderService.addOrder(newOrder, orderItems);
        cartProvider.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderSuccessView()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء حفظ الطلب: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPriceInHalalas = (widget.amount * 100).toInt();

    final paymentConfig = PaymentConfig(
      publishableApiKey: 'pk_test_MjF7XTpkA1aA4KzeoCNSjiQZzDeygNxFkaoJhQkh',
      amount: totalPriceInHalalas,
      description: 'تم الدفع',
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        rightButton: SquareIconButton(
          icon: Icons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 20),
        child: CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        ),
      ),
    );
  }
}