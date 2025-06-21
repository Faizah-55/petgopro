import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

/// ✅ ويدجت CustomBottomSection

/// يستخدم لإنشاء قسم سفلي ثابت (غالبًا يحتوي على زر أو عناصر تحكم)


class CustomBottomSection extends StatelessWidget {
  final Widget child;

  const CustomBottomSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 415, 
      height: 89, 
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), 
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor, 
        border: Border.all(
          color: AppTheme.borderColor, 
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140A0D12), 
            offset: Offset(0, -2),    
            blurRadius: 8,
          ),
        ],
      ),
      child: child, 
    );
  }
}