import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';

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
          style: AppTheme.font14Regular.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: textAlign,
          textDirection: TextDirection.rtl,
          obscureText: secureText,
          keyboardType: keyboardType,
          style: AppTheme.font14Regular.copyWith(
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryColor,
          ),
          decoration: InputDecoration(
            hintText: hintText ?? '',
            hintStyle: AppTheme.font14LightHint,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible == true
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppTheme.yellowColor,
                    ),
                    onPressed: toggleVisibility,
                  )
                : prefixWidget,
            filled: true,
            fillColor: AppTheme.whiteColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.borderColor.withOpacity(0.9)),
            ),
          ),
        ),
      ],
    );
  }
}
