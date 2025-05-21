import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A4543),
          ),
          children: [
            TextSpan(text: '$question '),
            TextSpan(
              text: title,
              style: const TextStyle(
                color: Colors.amber,
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
