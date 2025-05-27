import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

/// ✅ زر أيقونة مربع الشكل - يُستخدم للعودة، الحذف، أو أي إجراء آخر.
/// - له حجم ثابت 46x40
/// - يحتوي على أيقونة في الوسط
class SquareIconButton extends StatelessWidget {
  final IconData icon;        // الأيقونة التي ستظهر داخل الزر
  final VoidCallback onPressed; // الدالة التي تُنفذ عند الضغط

  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // تنفيذ الدالة عند الضغط
      borderRadius: BorderRadius.circular(10), 
      child: Container(
        width: 46,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,             
          borderRadius: BorderRadius.circular(10), 
          border: Border.all(
            color: AppTheme.borderColor,           
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor, 
          ),
        ),
      ),
    );
  }
}