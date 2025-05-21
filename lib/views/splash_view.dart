import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.5,
              child: Image.asset('assets/logo_petgo.png', fit: BoxFit.contain),
            ),
            SizedBox(height: 26, width: 243),

            Text(
              '!مستلزماتهم توصلكم لحد الباب',
              style: GoogleFonts.changa(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: const Color(0xFF0A4543),
                height: 1.44, // line-height: 26px / font-size: 18px
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            CircularProgressIndicator(
              color: const Color(0xFF0A4543), // لون المؤشر
              strokeWidth: screenWidth * 0.015, // 1.5% من العرض
            ),

            SizedBox(height: screenHeight * 0.2), // مسافة 20% من ارتفاع الشاشة
          ],
        ),
      ),
    );
  }
}
