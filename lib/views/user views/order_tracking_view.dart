// OrderTrackingView.dart

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:petgo_clone/models/order_item_model.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/map_preview_widget.dart';
import 'package:petgo_clone/widgets/order_summary_widget.dart';
import 'package:petgo_clone/widgets/section_row_widget.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderTrackingView extends StatefulWidget {
  final String orderId;
  final LatLng? location;
  final String status;
  final List<OrderItemModel> items;
  final double deliveryFee;
  final double totalPrice;

  const OrderTrackingView({
    super.key,
    required this.orderId,
    required this.location,
    required this.status,
    required this.items,
    required this.deliveryFee,
    required this.totalPrice,
  });

  @override
  State<OrderTrackingView> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState extends State<OrderTrackingView> {
  late RealtimeChannel _channel;
  String currentStatus = '';

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
    listenToStatusChanges();
  }


void listenToStatusChanges() {
  final supabase = Supabase.instance.client;

  _channel = supabase.channel('order-updates');

  _channel.onPostgresChanges(
    event: PostgresChangeEvent.update,
    schema: 'public',
    table: 'orders',
    callback: (payload) {
      final updatedOrderId = payload.newRecord['order_id'] as String?;
      final newStatus = payload.newRecord['status'] as String?;

      // فقط إذا هذا الطلب هو الطلب الحالي
      if (updatedOrderId == widget.orderId && newStatus != null && newStatus != currentStatus) {
        setState(() {
          currentStatus = newStatus;
        });
        print('✅ الحالة المحدثة: $newStatus');
      }
    },
  );

  _channel.subscribe();
}

  @override
  void dispose() {
    _channel.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'رقم الطلب #${widget.orderId.substring(0, 6)}',
          rightButton: SquareIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
          leftButton: SquareIconButton(
            icon: Icons.help_outline,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الدعم غير متاح حالياً')),
              );
            },
          ),
          showShadow: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              if (widget.location != null &&
                  !widget.location!.latitude.isNaN &&
                  !widget.location!.longitude.isNaN &&
                  widget.location!.latitude != 0.0 &&
                  widget.location!.longitude != 0.0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MapPreviewWidget(
                    location: widget.location!,
                    width: double.infinity,
                    height: 204,
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'لا يوجد موقع محدد لهذا الطلب',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.redColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: buildHorizontalTimeline(currentStatus),
              ),
              const SizedBox(height: 4),
              Text(
                currentStatus,
                style: AppTheme.font20SemiBold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                getStatusDescription(currentStatus),
                style: AppTheme.font16Medium.copyWith(
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SectionRowWidge(
                type: SectionRowType.titleWithButton,
                title: 'تواصل مع المندوب',
                customButton: const Icon(
                  Icons.call,
                  color: AppTheme.yellowColor,
                  size: 24,
                ),
                showTopDivider: true,
              ),
              SectionRowWidge(
                type: SectionRowType.titleWithTextAndIcon,
                title: 'طريقة الدفع',
                trailingText: 'بطاقة ائتمانية',
                icon: Icons.credit_card,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OrderSummaryWidget(
                  items: widget.items,
                  deliveryFee: widget.deliveryFee,
                  totalPrice: widget.totalPrice,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHorizontalTimeline(String currentStatus) {
    final steps = [
      'جاري التجهيز',
      'جاهز للتوصيل',
      'الطلب بالطريق',
      'طلبك قريب',
      'تم التوصيل',
    ];
    final currentStep = steps.indexOf(currentStatus);

    return SizedBox(
      height: 70,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final isCompleted = i ~/ 2 < currentStep;
            return Expanded(
              child: Container(
                height: 3,
                color:
                    isCompleted ? AppTheme.yellowColor : AppTheme.primaryColor,
              ),
            );
          } else {
            final index = i ~/ 2;
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            final color =
                (isCompleted || isCurrent)
                    ? AppTheme.yellowColor
                    : AppTheme.primaryColor;
            return Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            );
          }
        }),
      ),
    );
  }

  String getStatusDescription(String status) {
    switch (status) {
      case 'جاري التجهيز':
        return 'المتجر قاعد يجهز طلبك';
      case 'جاهز للتوصيل':
        return 'كل شي جاهز ! بس ننتظر المندوب يستلمه';
      case 'الطلب بالطريق':
        return 'المندوب طالع لك، بيوصلك خلال وقت قصير';
      case 'طلبك قريب':
        return 'المندوب وصل عنوانك، تقدر تطلع تستلم طلبك الان';
      case 'تم التوصيل':
        return 'طلبك وصل نتمنى انه نال اعجابك';
      default:
        return 'جاري اختيار المندوب لتوصيل طلبك';
    }
  }
}
