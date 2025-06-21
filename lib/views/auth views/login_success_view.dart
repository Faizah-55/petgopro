import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSuccessView extends StatelessWidget {
  const LoginSuccessView({super.key});

  Future<void> storeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

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
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // تم التحقق
                  SizedBox(
                    width: 380,
                    height: 32,
                    child: Text(
                      'تم التحقق بنجاح',
                      style: AppTheme.font24Bold.copyWith(
                        color: AppTheme.primaryColor,
                        height: 32 / 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // الصورة
                  Image.asset(
                    'assets/app_img/onboarding4.png',
                    width: 379,
                    height: 288,
                  ),

                  const SizedBox(height: 32),

                  // أهلاً بك في PetGo
                  SizedBox(
                    width: 380,
                    height: 32,
                    child: Text.rich(
                      TextSpan(
                        text: 'أهلاً بك في ',
                        style: AppTheme.font24Bold.copyWith(
                          color: AppTheme.primaryColor,
                          height: 32 / 24,
                        ),
                        children: [
                          TextSpan(
                            text: 'PetGo',
                            style: AppTheme.font24Bold.copyWith(
                              color: AppTheme.primaryColor,
                              height: 32 / 24,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // النص الترحيبي
                  SizedBox(
                    width: 234,
                    child: Text(
                      'نرحب بك ونتمنى لك تجربة ممتعة\nومريحة معنا.',
                      style: AppTheme.font14Regular.copyWith(
                        fontSize: 16,
                        height: 24 / 16,
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  const SizedBox(height: 64),

                  CustomButton(
                    title: 'انتقل لتسجيل الدخول',
                    pressed: () async {
                      await storeUserData();
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