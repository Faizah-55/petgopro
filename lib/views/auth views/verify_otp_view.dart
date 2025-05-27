import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/login_success_view.dart';
import 'package:petgo_clone/widgets/custom_auth_widget.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyOtpView extends StatefulWidget {
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
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  TextEditingController otpController = TextEditingController();

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
              Text(
                'ادخل رمز التحقق',
                style: AppTheme.font24Bold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أرسلنا لك رمز من ٦ أرقام على بريدك الإلكتروني',
                style: AppTheme.font14LightHint,
                textAlign: TextAlign.center,
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
                  selectedColor: AppTheme.yellowColor,
                  activeColor: AppTheme.primaryColor,
                ),
                onChanged: (value) {
                  otpController.text = value;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                title: 'تأكيد',
                pressed: () async {
                  try {
                    await supabase.auth.verifyOTP(
                      type: OtpType.email,
                      token: otpController.text,
                      email: widget.email!,
                    );

                    await supabase.auth.signInWithPassword(
                      email: widget.email!,
                      password: widget.password!,
                    );

                    if (!widget.isLogin) {
                      final user = supabase.auth.currentUser;
                      await supabase.from('users').insert({
                        'user_id': user?.id,
                        'username': widget.name,
                        'email': widget.email,
                        'number': widget.phone,
                      });

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginSuccessView(),
                        ),
                        (route) => false,
                      );
                    } else {
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
              CustomAuthWidget(
                question: 'لم يصلك الرمز؟',
                title: 'أعد الإرسال',
                pressed: () async {
                  try {
                    await supabase.auth.resend(
                      type: OtpType.email,
                      email: widget.email!,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إعادة الإرسال')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('خطأ في الإرسال: ${e.toString()}'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 4),
              CustomAuthWidget(
                question: 'واجهت مشكلة؟',
                title: 'تواصل معنا نساعدك',
                pressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سيتم تفعيل الدعم لاحقًا')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
