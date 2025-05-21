import 'package:flutter/material.dart';
import 'package:petgo_clone/main.dart';
import 'package:petgo_clone/views/auth%20views/create_account_view.dart';
import 'package:petgo_clone/views/auth%20views/login_success_view.dart';
import 'package:petgo_clone/widgets/custom_bottom.dart';
import 'package:petgo_clone/widgets/custom_textfelid_widget.dart';
import 'package:petgo_clone/widgets/custom_auth_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 80),
            const Center(
              child: Text(
                'اهلا بعودتك',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF0A4543),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// حقل الإيميل
            CustomTextfeildWidget(
              title: 'البريد الإلكتروني',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.right,
              hintText: 'example@email.com',
              secureText: false,
              prefixWidget: const Icon(
                Icons.email_outlined,
                color: Colors.amber,
              ),
            ),

            /// حقل كلمة المرور
            CustomTextfeildWidget(
              title: 'كلمة المرور',
              controller: passwordController,
              hintText: 'أدخل كلمة المرور',
              secureText: true,
              textAlign: TextAlign.right,
              prefixWidget: const Icon(Icons.lock_outline, color: Colors.amber),
            ),

            const SizedBox(height: 24),

            CustomAuthWidget(
              question: ' أول مرة تستخدم PetGo ؟',
              title: ' أنشئ حسابك',
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateAccountView()),
                );
              },
            ),

            const SizedBox(height: 8),

            CustomAuthWidget(
              question: 'واجهت مشكلة؟',
              title: 'تواصل معنا نساعدك',
              pressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم تفعيل الدعم لاحقًا')),
                );
              },
            ),

            const SizedBox(height: 24),

            CustomButton(
              title: 'التالي',
              pressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (!email.contains('@') || !email.contains('.')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى إدخال بريد إلكتروني صحيح'),
                    ),
                  );
                  return;
                }

                if (password.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('كلمة المرور غير صالحة')),
                  );
                  return;
                }

                try {
                  // ✅ الخطوة 1: تسجيل الدخول بالبريد وكلمة المرور
                  final AuthResponse loginResponse = await supabase.auth
                      .signInWithPassword(email: email, password: password);

                  final user = loginResponse.user;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('فشل تسجيل الدخول')),
                    );
                    return;
                  }

                  // ✅ الخطوة 2: التحقق من وجود المستخدم في جدول users
                  final response =
                      await supabase
                          .from('users')
                          .select()
                          .eq('user_id', user.id)
                          .maybeSingle();

                  if (response == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لا يوجد حساب مرتبط بهذا المستخدم'),
                      ),
                    );
                    return;
                  }

                  // ✅ الخطوة 3: تسجيل الدخول ناجح → الانتقال للصفحة التالية
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginSuccessView()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: ${e.toString()}')),
                  );
                }
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
