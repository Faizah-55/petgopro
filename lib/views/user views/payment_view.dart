import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:petgo_clone/provider/cart_provider.dart';
import 'package:petgo_clone/views/user%20views/address_view.dart';
import 'package:petgo_clone/views/user%20views/moyasar_payment_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:petgo_clone/widgets/custom_small_buttom.dart';
import 'package:petgo_clone/widgets/map_preview_widget.dart';
import 'package:petgo_clone/widgets/section_row_widget.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// صفحة الدفع


class PaymentView extends StatefulWidget {
  const PaymentView({super.key, });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {

LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
  }

  Future<void> fetchUserLocation() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final response = await Supabase.instance.client
        .from('users')
        .select('latitude, longitude')
        .eq('user_id', userId)
        .single();

    if (response['latitude'] != null &&
        response['longitude'] != null) {
      setState(() {
        userLocation = LatLng(
          response['latitude'],
          response['longitude'],
        );
      });
    } else {
      setState(() {
        userLocation = LatLng(24.7136, 46.6753);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final itemTotal = cartProvider.itemTotal;
    final deliveryFee = cartProvider.deliveryPrice;
    final totalPrice = cartProvider.totalPrice;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          showShadow: true,
          title: 'الدفع',
          rightButton: SquareIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionRowWidge(
                      type: SectionRowType.headerText,
                      title: ' تفاصيل التوصيل ',
                      showDivider: true,
                    ),
                    const SizedBox(height: 12),

                    SectionRowWidge(
                      type: SectionRowType.titleWithIconAndTime,
                      title: 'المدة',
                      icon: Icons.access_time,
                      timeText: '30 - 40',
                      showDivider: true,
                    ),
                    const SizedBox(height: 12),


                    userLocation == null
  ? const Center(child: CircularProgressIndicator()) 
  : SectionRowWidge(
      type: SectionRowType.mapWithTitleAndButton,
      title: 'موقعي ',
      mapWidget: MapPreviewWidget(
        location: cartProvider.selectedLocation ?? userLocation!,
      ),
      customButton: CustomSmallButton(
        icon: Icons.my_location,
        text: 'تعديل الموقع',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressView(fromPayment: true),
            ),
          );
        },
      ),
    ),


                    const SizedBox(height: 12),

                    SectionRowWidge(
                      type: SectionRowType.headerText,
                      title: ' تفاصيل الدفع ',
                      showDivider: true,
                    ),
                    const SizedBox(height: 12),

                    SectionRowWidge(
                      type: SectionRowType.titleWithButton,
                      title: 'طريقة الدفع',
                      customButton: CustomSmallButton(
                        icon: Icons.credit_card,
                        text: 'بطاقة ائتمانية',
                        onPressed: () {
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Column(
              children: [
                SectionRowWidge(
                  type: SectionRowType.headerText,
                  title: ' ملخص الطلب ',
                  showDivider: true,
                ),
                const SizedBox(height: 8),

                SectionRowWidge(
                  type: SectionRowType.titleWithPriceAndIcon,
                  title: ' مجموع الطلب ',
                  price: itemTotal,
                  icon: Icons.money,
                  showPrice: true,
                  showIcon: true,
                  showDivider: true,
                ),
                const SizedBox(height: 8),

                SectionRowWidge(
                  type: SectionRowType.titleWithPriceAndIcon,
                  title: ' سعر التوصيل ',
                  price: deliveryFee,
                  icon: Icons.money,
                  showPrice: true,showIcon: true,
                  showDivider: true,
                ),
                const SizedBox(height: 8),

                SectionRowWidge(
                  type: SectionRowType.titleWithPriceAndIcon,
                  title: ' المجموع ',
                  price: totalPrice,
                  icon: Icons.money,
                  showPrice: true,
                  showIcon: true,
                  showDivider: true,
                ),
                const SizedBox(height: 16),

                CustomBottomSection(
                  child: CustomButton(
                    title: ' ادفع ',
                    pressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  MoyasarPaymentView(
                            amount: totalPrice,
                             supabase: Supabase.instance.client,),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}