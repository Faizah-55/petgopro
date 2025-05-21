import 'package:flutter/material.dart';

class CustomTextfeildWidget extends StatelessWidget {
  const CustomTextfeildWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.secureText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
    required this.textAlign,
    this.prefixWidget,
    this.suffixWidget,
    this.isPasswordVisible,
    this.toggleVisibility,
  });

  final String title;
  final TextEditingController controller;
  final bool secureText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? hintText;
  final TextAlign textAlign;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool? isPasswordVisible;
  final VoidCallback? toggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF0A4543),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: textAlign,
          textDirection: TextDirection.rtl,
          obscureText: secureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText ?? '',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isPasswordVisible == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.amber,
                      ),
                      onPressed: toggleVisibility,
                    )
                    : prefixWidget,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }
}
