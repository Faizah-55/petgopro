import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

class CurrentOrderCard extends StatelessWidget {
  final String storeName;
  final String status;
  final double totalPrice;
  final String imageUrl;
  final VoidCallback onTrackPressed;
  final String buttonText; // ✅ زر ديناميكي

  const CurrentOrderCard({
    super.key,
    required this.storeName,
    required this.status,
    required this.totalPrice,
    required this.imageUrl,
    required this.onTrackPressed,
    required this.buttonText, // ✅ جديد
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 374,
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ صورة المتجر
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                width: 111,
                height: 111,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // ✅ النصوص + الزر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 الاسم + السعر
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          storeName,
                          style: AppTheme.font15SemiBold.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ريال',
                        style: AppTheme.font13SemiBold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 🔹 حالة الطلب
                  Text(
                    status,
                    style: AppTheme.font13Regular.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 🔹 زر تتبع أو تفاصيل الطلب
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 105,
                      height: 34,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.greenLocationColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.91),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.91, horizontal: 12.09),
                          elevation: 0,
                          shadowColor: const Color(0x0D0A0D12),
                        ),
                        onPressed: onTrackPressed,
                        child: Text(
                          buttonText, // ✅ هنا نعرض النص المرسل
                          style: AppTheme.font12SemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 12.09,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}