import 'package:flutter/material.dart';
import 'package:petgo_clone/admin%20view/admin_home_view.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/create_account_view.dart';
import 'package:petgo_clone/views/user%20views/address_view.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
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
    final supabase = Supabase.instance.client;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 80),
            Center(
              child: Text(
                'اهلا بعودتك',
                style: AppTheme.font24Bold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // البريد الإلكتروني
            CustomTextfeildWidget(
              title: 'البريد الإلكتروني',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.right,
              hintText: 'example@email.com',
              secureText: false,
              prefixWidget: const Icon(
                Icons.email_outlined,
                color: AppTheme.yellowColor,
              ),
            ),
            const SizedBox(height: 20),

            // كلمة المرور
            CustomTextfeildWidget(
              title: 'كلمة المرور',
              controller: passwordController,
              hintText: 'أدخل كلمة المرور',
              secureText: true,
              textAlign: TextAlign.right,
              prefixWidget: const Icon(
                Icons.lock_outline,
                color: AppTheme.yellowColor,
              ),
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

            // زر تسجيل الدخول
            // زر تسجيل الدخول
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
                  await supabase.auth.signInWithPassword(
                    email: email,
                    password: password,
                  );

                  // ✅ تسجيل دخول ناجح
                  print("✅ تسجيل دخول ناجح");

                  final user = Supabase.instance.client.auth.currentUser;

                  // 🔒 تحقق من إذا هو الأدمن
                  if (user != null && user.email == 'admin@petgo.com') {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminHomeView()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AddressView()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  print('❌ خطأ في تسجيل الدخول: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'البريد الإلكتروني أو كلمة المرور غير صحيحة',
                      ),
                    ),
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
