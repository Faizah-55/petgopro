import 'package:flutter/material.dart';
import 'package:petgo_clone/models/order_item_model.dart';
import 'package:petgo_clone/models/order_model.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/services/order_service.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/orders_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:petgo_clone/widgets/custom_textfelid_widget.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:moyasar/moyasar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// صفحة دفع ميسر


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

  void showPaymentSuccessSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'تم استلام طلبك بنجاح',
                style: AppTheme.font24Bold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'نجهز طلبك الآن، وتقدر تتابع حالته من صفحة الطلبات',
                style: AppTheme.font16Medium.copyWith(
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              CustomButton(
                title: 'اذهب لصفحة الطلبات',
                pressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(builder: (context) => OrdersView()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onPaymentResult(result) async {
  if (result is PaymentResponse) {
    if (result.status == PaymentStatus.paid) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final userId = widget.supabase.auth.currentUser?.id ?? '';

      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('المستخدم غير مسجل دخول')),
        );
        return;
      }

      final newOrder = OrderModel(
        orderId: '',
        userId: userId,
        status: 'pending',
        totalPrice: widget.amount,
        createdAt: DateTime.now(),
      );

      final orderItems = cartProvider.items.map((cartItem) {
        return OrderItemModel(
          orderId: '',
          productId: cartItem.productId,
          quantity: cartItem.quantity,
          selectedWeight: cartItem.selectedWeight,
          price: cartItem.price,
          itemTotal: cartItem.itemTotal,
        );
      }).toList();

      try {
        await orderService.addOrder(newOrder, orderItems);
        cartProvider.clear();
        showPaymentSuccessSheet(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء حفظ الطلب: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الدفع: ${result.status.name}')),
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
      appBar : CustomAppBar(       
          showShadow: true,
           rightButton: SquareIconButton(
          icon: Icons.close,
          onPressed: () {
              Navigator.pop(context);
            }
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

