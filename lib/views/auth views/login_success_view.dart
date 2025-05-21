import 'package:flutter/material.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/views/nav_user.dart';
import 'package:petgo_clone/widgets/custom_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSuccessView extends StatelessWidget {
  const LoginSuccessView({super.key});

  // ✅ دالة لحفظ حالة تسجيل الدخول في SharedPreferences
  Future<void> storeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

  // ✅ دالة لتسجيل الخروج (تمسح البيانات)
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'تم التحقق بنجاح',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF0A4543),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Image.asset('assets/onboarding4.png', height: 200),
                  const SizedBox(height: 32),
                  RichText(
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    text: const TextSpan(
                      text: 'اهلا بك في ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xFF0A4543),
                      ),
                      children: [
                        TextSpan(
                          text: 'PetGo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0A4543),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'نرحب بك ونتمنى لك تجربة ممتعة\nومريحة معنا',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF0A4543)),
                  ),
                  const SizedBox(height: 64),
                  CustomButton(
                    title: 'انتقل لتسجيل الدخول',
                    pressed: () async {
                      await storeUserData(); // ✅ تخزين حالة الدخول

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
