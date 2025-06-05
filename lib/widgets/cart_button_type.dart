import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

// زر مخصص لاضافة المنتجات و السلة
// يدعم نوعين من الازرار باستخدام (enum)

// large : يعرض نص "عرض السلة" مع عدد السلع و يعرض السعر و ينقل الى صفحة السلة
// small : يعرض نص "اضافة و يعرض السعر و يضيف المنتج للسلة"

enum CartButtonType { large, small }

class CartSummaryButtonWidget extends StatelessWidget {
  final CartButtonType type;
  final int itemCount;
  final double totalPrice;
  final VoidCallback onPressed;

  const CartSummaryButtonWidget({
    super.key,
    required this.type,
    required this.itemCount,
    required this.totalPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLarge = type == CartButtonType.large;

    return SizedBox(
      width: isLarge ? 379 : 165,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppTheme.borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        

        child: Row(
  textDirection: TextDirection.rtl,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      isLarge
          ? 'عرض السلة ($itemCount)' // الزر large فيه عدد المنتجات
          : 'اضافة', // الزر small بدون عدد
      style: AppTheme.font15SemiBold.copyWith(color: AppTheme.whiteColor),
    ),

    Row(
        textDirection: TextDirection.rtl,
      children: [
        Icon(
          Icons.money,
          size: 20,
          color: AppTheme.yellowColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${totalPrice.toStringAsFixed(2)} ريال',
          style: AppTheme.font12SemiBold.copyWith(color: AppTheme.whiteColor),
        ),
      ],
    ),
  ],
),


      ),
    );
  }
}