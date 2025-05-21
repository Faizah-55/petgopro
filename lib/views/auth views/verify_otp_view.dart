import 'package:flutter/material.dart';
import 'package:petgo_clone/views/auth%20views/login_success_view.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/widgets/custom_auth_widget.dart';
import 'package:petgo_clone/widgets/custom_bottom.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/gestures.dart';

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({
    super.key,
    required this.phone,
    required this.isLogin,
    this.name,
    this.email,
    this.password,
  });

  final String phone;
  final bool isLogin;
  final String? name;
  final String? email;
  final String? password;

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    TextEditingController otpController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ادخل رمز التحقق',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF0A4543),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'أرسلنا لك رمز من ٦ أرقام على بريدك الإلكتروني',

                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const SizedBox(height: 32),
              PinCodeTextField(
                appContext: context,
                controller: otpController,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                autoFocus: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Colors.amber,
                  activeColor: const Color(0xFF0A4543),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 32),
              CustomButton(
                title: 'تأكيد',
                pressed: () async {
                  try {
                    await supabase.auth.verifyOTP(
                      type: OtpType.email,
                      token: otpController.text,
                      email: email!,
                    );

                    if (!isLogin) {
                      // إذا تسجيل جديد → نحفظ البيانات
                      final user = supabase.auth.currentUser;
                      await supabase.from('users').insert({
                        'user_id': user?.id,
                        'username': name,
                        'email': email,
                        'number': phone.toString(),
                      });

                      // ثم ننتقل إلى صفحة تسجيل الدخول
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                        (route) => false,
                      );
                    } else {
                      // إذا تسجيل دخول → ننتقل إلى الصفحة الرئيسية أو نجاح
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginSuccessView(),
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل التحقق: ${e.toString()}')),
                    );
                  }
                },
              ),

              const SizedBox(height: 24),
              RichText(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  children: [
                    const TextSpan(text: 'لم يصلك الرمز؟ '),
                    TextSpan(
                      text: 'أعد الإرسال',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () async {
                              try {
                                await supabase.auth.resend(
                                  type: OtpType.email,
                                  email: email!,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم إعادة الإرسال'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'خطأ في الإرسال: ${e.toString()}',
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              CustomAuthWidget(
                question: 'واجهت مشكلة؟',
                title: 'تواصل معنا نساعدك',
                pressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
