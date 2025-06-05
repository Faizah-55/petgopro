import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/payment_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:petgo_clone/widgets/section_row_widget.dart';
import 'package:petgo_clone/widgets/product_card_widget.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:petgo_clone/models/cart_item_model.dart';
import '../../provider/cart_provider.dart';


// صفحة السلة


class CartView extends StatelessWidget {
  const  CartView ({super.key});

// عشان احسب مجموع المنتجات
Future<double> fetchItemTotal(String orderId) async {
  final response = await Supabase.instance.client
      .from('order_items')
      .select('price, quantity')
      .eq('order_id', orderId);

  double total = 0;
  for (var item in response) {
    final double price = item['price']?.toDouble() ?? 0;
    final int quantity = item['quantity'] ?? 0;
    total += price * quantity;
  }

  return total;
}

 // عشان اجيب سعر التوصيل 
Future<double> fetchDeliveryPrice(String storeId) async {
  final response = await Supabase.instance.client
      .from('stores')
      .select('delivery_price')
      .eq('store_id', storeId)
      .single();

  return response['delivery_price']?.toDouble() ?? 0.0;
}

//عشان اجيب السعر الاجمالي  النهائي
Future<double> fetchTotalPrice(String orderId) async {
  final response = await Supabase.instance.client
      .from('orders')
      .select('total_price')
      .eq('order_id', orderId)
      .single();

  return response['total_price']?.toDouble() ?? 0.0;
}



  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final itemTotal = cartProvider.itemTotal;
    final deliveryFee = cartProvider.deliveryPrice;
    final totalPrice = cartProvider.totalPrice;


    return Scaffold(
      appBar: CustomAppBar(       
          showShadow: true,
           title: 'السلة',
           rightButton: SquareIconButton(
          icon: Icons.arrow_back,
          onPressed: () {
              Navigator.pop(context);
            }
           ),
           ),
   
        body: Directionality(
            textDirection: TextDirection.rtl,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'طلباتي',
                   style: AppTheme.font18SemiBold.copyWith(
                   color: AppTheme.primaryColor
                  ),
                ),
              ),
          
              Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
          
                return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ProductCardWidget(

            productId: item.productId,
            imageUrl: item.imageUrl ?? '',
            name: item.name,
            shortDescription: item.shortDescription ?? '', 
            price: item.price,
          ),
                );
              },
            ),
          ),

              // ✅ ملخص الطلب
              SectionRowWidge(
               type: SectionRowType.headerText,
               title: ' ملخص الطلب ',
               showDivider: true, 
             ),
              
              SectionRowWidge(
               type: SectionRowType.titleWithPriceAndIcon,
               title: 'مجموع الطلب',
               price: itemTotal,
               icon: Icons.money,
               showDivider: true, 
              ),
          
              SectionRowWidge(
               type: SectionRowType.titleWithPriceAndIcon,
               title: 'المجموع',
               price: itemTotal,
               icon: Icons.money,
               showDivider: true, 
              ),
          
              
          
               CustomBottomSection(
                child: CustomButton(
                  title: 'اذهب للدفع',
                 pressed: ()  {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentView(),
                    ),
                 );
                 }
                 ),
              ),
            ],
          ),
        ), 
    );
  }
}