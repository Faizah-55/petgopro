import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

/// ✅ ويدجت شريط البحث المخصص للتطبيق
/// 
/// - يُستخدم لإظهار شريط بحث يحتوي على أيقونة وإما نص ثابت أو حقل إدخال.
/// - قابل لإعادة الاستخدام في أكثر من شاشة (مثلاً: في الصفحة الرئيسية أو صفحة البحث).
/// 
/// المزايا:
/// - يمكن جعله قابل للنقر فقط بدون إدخال (onTap)
/// - يمكن ربطه بـ TextField حقيقي مع تحكم كامل (controller + onChanged)
/// - يدعم اتجاه RTL تلقائي
/// 

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onTap,
    this.onChanged,
    this.hintText = 'ابحث عن منتج',
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: GestureDetector(
        onTap: onTap, // ✅ تنفيذ الإجراء عند الضغط (مثلاً فتح صفحة بحث جديدة)
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderColor, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),

              // ✅ محتوى الشريط (إما TextField أو نص ثابت)
              Expanded(
                child: controller != null
                    ? TextField(
                        controller: controller, // ربط حقل الإدخال بالتحكم الخارجي
                        onChanged: onChanged,   // تنفيذ البحث عند تغيير النص
                        textAlign: TextAlign.right,
                        style: textTheme.bodySmall,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: textTheme.bodySmall?.copyWith(
                            color: AppTheme.grayColor,
                          ),
                        ),
                      )
                    : Text(
                        hintText, // ✅ إذا ما فيه TextField، يظهر كنص فقط
                        textAlign: TextAlign.right,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.grayColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}