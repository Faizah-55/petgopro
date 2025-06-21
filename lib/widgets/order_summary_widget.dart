import 'package:flutter/material.dart';
import 'package:petgo_clone/models/order_item_model.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/section_row_widget.dart';

class OrderSummaryWidget extends StatefulWidget {
  final List<OrderItemModel> items;
  final double deliveryFee;
  final double totalPrice;

  const OrderSummaryWidget({
    super.key,
    required this.items,
    required this.deliveryFee,
    required this.totalPrice,
  });

  @override
  State<OrderSummaryWidget> createState() => _OrderSummaryWidgetState();
}

class _OrderSummaryWidgetState extends State<OrderSummaryWidget> {
  bool isExpanded = false;

  double get productsTotal {
    return widget.items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {

    print('🔍 عدد المنتجات داخل ملخص الطلب: ${widget.items.length}');


    return Column(
      children: [
        // 🔽 عنوان القسم مع زر التوسيع
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: SectionRowWidge(
            type: SectionRowType.titleWithButton,
            title: 'ملخص الطلب',
            customButton: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppTheme.primaryColor,
            ),
            showDivider: false,
          ),
        ),

        if (isExpanded)
          Column(
            children: [
              const SizedBox(height: 8),

              // 🛒 قائمة المنتجات
              ...widget.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName,
                          style: AppTheme.font14Medium,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '× ${item.quantity}',
                        style: AppTheme.font13Regular.copyWith(
                          color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.price.toStringAsFixed(2)} ريال',
                        style: AppTheme.font13SemiBold.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 🧾 مجموع المنتجات
              SectionRowWidge(
                type: SectionRowType.titleWithPriceAndIcon,
                title: 'مجموع المنتجات',
                price: productsTotal,
                icon: Icons.money,
                showDivider: false,
              ),

              // 🚚 سعر التوصيل
              SectionRowWidge(
                type: SectionRowType.titleWithPriceAndIcon,
                title: 'سعر التوصيل',
                price: widget.deliveryFee,
                icon: Icons.money,
                showDivider: false,
              ),

              // 💰 المجموع الكلي
              SectionRowWidge(
                type: SectionRowType.titleWithPriceAndIcon,
                title: 'الإجمالي',
                price: widget.totalPrice,
                icon: Icons.money,
                showTopDivider: true,
                showDivider: false,
              ),
            ],
          ),
      ],
    );
  }
}