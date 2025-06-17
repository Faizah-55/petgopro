import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

/// ✅ ويدجت CustomAppBar
///
/// هذا AppBar مخصص لتطبيق PetGo.
/// يدعم إضافة:
/// - زر أو أيقونة في اليمن 
/// - شعار التطبيق بجانب الأيقونة اليمنى
/// - عنوان في الوسط (اختياري)
/// - زر في اليسار
/// - اسم الموقع في اليسار مع أيقونة الموقع وسهم
///
/// مرن وقابل لإعادة الاستخدام في جميع صفحات التطبيق.
///جججووورريييي
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;              // ✅ عنوان الصفحة في المنتصف
  final Widget? rightButton;       // ✅ أيقونة على أقصى يمين 
  final Widget? rightLogo;         // ✅ شعار التطبيق
  final Widget? leftButton;        // ✅ زر في اليسار 
  final String? locationName;      // ✅ اسم الموقع الظاهر في الزاوية اليسرى
  final VoidCallback? onLocationTap; // ✅ ينفذ عند الضغط على اسم الموقع
  final bool showShadow;
  final Widget? titleWidget; // ✅ ويدجت مخصص للعنوان (مثل نص + أيقونة)
           // ✅ يتحكم بإظهار الظل أسفل الـ AppBar

  const CustomAppBar({
    super.key,
    this.title,
    this.rightButton,
    this.rightLogo,
    this.leftButton,
    this.locationName,
    this.onLocationTap,
    this.showShadow = false,
    this.titleWidget,
    
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          boxShadow: showShadow
              ? const [
                  BoxShadow(
                    color: Color(0x4D000000), 
                    offset: Offset(-1, 0),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
          border: const Border(
            top: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
        ),

        // ✅ اتجاه RTL لأن التطبيق باللغة العربية
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ القسم الأيمن: أيقونة + لوقو
              Row(
                children: [
                  if (rightButton != null) rightButton!,
                  const SizedBox(width: 8),
                  if (rightLogo != null) rightLogo!,
                ],
              ),

              // ✅ القسم الأوسط: عنوان مركزي إذا موجود
              Expanded(
  child: Center(
    child: titleWidget != null
        ? titleWidget! // ✅ إذا تم تمرير ويدجت مخصص
        : title != null
            ? Text(
                title!,
                style: AppTheme.font20SemiBold,
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
  ),
),


              // ✅ القسم الأيسر: زر + موقع
              Row(
                children: [
                  if (leftButton != null) leftButton!,
                  const SizedBox(width: 6),
                  if (locationName != null)
                    GestureDetector(
                      onTap: onLocationTap,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            locationName!,
                            style: AppTheme.font14Medium.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ يحدد ارتفاع الـ AppBar
  @override
  Size get preferredSize => const Size.fromHeight(89);
}