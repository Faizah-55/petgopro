import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

class CustomAuthWidget extends StatelessWidget {
  final String question;
  final String title;
  final VoidCallback pressed;

  const CustomAuthWidget({
    super.key,
    required this.question,
    required this.title,
    required this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTheme.font14Medium.copyWith(
            color: AppTheme.primaryColor,
          ),
          children: [
            TextSpan(text: '$question '),
            TextSpan(
              text: title,
              style: AppTheme.font14Medium.copyWith(
                color: AppTheme.yellowColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = pressed,
            ),
          ],
        ),
      ),
    );
  }
}