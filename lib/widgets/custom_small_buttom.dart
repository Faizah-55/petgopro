import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

// تصميم زر بمواصفات تتطلبها صفحة الدفع 


class CustomSmallButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomSmallButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 114.3,
      height: 28.41,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.greenLocationColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.whiteColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: AppTheme.font10SemiBold.copyWith(
                color: AppTheme.whiteColor,
              )
            ),
          ],
        ),
      ),
    );
  }
}