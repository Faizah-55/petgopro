import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ لوجو التطبيق
            SizedBox(
              width: screenWidth * 0.5,
              child: Image.asset('assets/logo/logo_petgo.png', fit: BoxFit.contain),
            ),

            const SizedBox(height: 26),

            // ✅ النص الأوسط
            Text(
              '!مستلزماتهم توصلكم لحد الباب',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 26 / 18,
                    color: AppTheme.primaryColor,
                  ),
            ),

            const SizedBox(height: 24),

            // ✅ المؤشر الدائري
            CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: screenWidth * 0.015,
            ),

            const SizedBox(height: 48), // مسافة نهائية بسيطة
          ],
        ),
      ),
    );
  }
}
