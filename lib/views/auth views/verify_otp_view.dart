// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:petgo_clone/views/auth%20views/login_success_view.dart';
import 'package:petgo_clone/widgets/custom_auth_widget.dart';
import 'package:petgo_clone/widgets/custom_bottom.dart';

class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({
    Key? key,
    required this.phone,
    required this.isLogin,
    this.name,
    this.email,
    this.password,
  }) : super(key: key);

  final String phone;
  final bool isLogin;
  final String? name;
  final String? email;
  final String? password;

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  String token = '';
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

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
                onChanged: (value) {
                  setState(() {
                    token = value;
                  });
                  print('token: $token');
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                title: 'تأكيد',
                pressed: () async {
                  try {
                    print('----------------------');
                    print('Email: ${widget.email}');
                    print('Token: ${token}');
                    print('----------------------');

                    await supabase.auth.verifyOTP(
                      type:
                          OtpType
                              .signup, // أو OtpType.email حسب اللي استخدمتيه لإرسال الكود
                      token: token,
                      email: widget.email!,
                    );

                    if (!widget.isLogin) {
                      final user = supabase.auth.currentUser;
                      await supabase.from('users').insert({
                        'user_id': user?.id,
                        'username': widget.name,
                        'email': widget.email,
                        'number': widget.phone,
                      });
                    }

                    // تنقل مباشر من السياق الخارجي
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginSuccessView(),
                      ),
                    );
                    print('login success');
                  } catch (e) {
                    print('فشل التحقق: $e');
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
                                  email: widget.email!,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم إعادة الإرسال'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('خطأ في الإرسال: $e')),
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
