import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/views/auth%20views/verify_otp_view.dart';
import 'package:petgo_clone/widgets/custom_auth_widget.dart';
import 'package:petgo_clone/widgets/custom_bottom.dart';
import 'package:petgo_clone/widgets/custom_textfelid_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool agreed = false;

  bool arePasswordsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 379),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 80),
                  const Center(
                    child: Text(
                      'سجّل حساب جديد',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF0A4543),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextfeildWidget(
                    title: 'رقم الجوال',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    secureText: false,
                    textAlign: TextAlign.right,
                    prefixWidget: CountryCodePicker(
                      onChanged: (code) {
                        print('رمز الدولة: ${code.dialCode}');
                      },
                      initialSelection: 'SA',
                      favorite: ['+966', 'SA'],
                      showFlag: true,
                      showDropDownButton: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      text: 'أدخل ٩ أرقام تبدأ بـ ٥ - ',

                      children: [
                        TextSpan(
                          text: 'مثال:  ٥XXXXXXXX ',

                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextfeildWidget(
                    title: 'الاسم',
                    controller: nameController,
                    hintText: 'اكتب اسمك كامل',
                    secureText: false,
                    textAlign: TextAlign.right,
                    prefixWidget: const Icon(
                      Icons.person_outline,
                      color: Colors.amber,
                    ),
                  ),
                  CustomTextfeildWidget(
                    title: 'البريد الإلكتروني',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'example@email.com',
                    textAlign: TextAlign.left,
                    secureText: false,
                    prefixWidget: const Icon(
                      Icons.email_outlined,
                      color: Colors.amber,
                    ),
                  ),
                  CustomTextfeildWidget(
                    title: 'كلمة المرور',
                    controller: passwordController,
                    hintText: '٨ أحرف أو أكثر - حروف وأرقام',

                    textAlign: TextAlign.right,
                    secureText: !arePasswordsVisible,
                    isPassword: true,
                    isPasswordVisible: arePasswordsVisible,
                    toggleVisibility: () {
                      setState(() {
                        arePasswordsVisible = !arePasswordsVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextfeildWidget(
                    title: 'تأكيد كلمة المرور',
                    controller: confirmPasswordController,
                    hintText: '٨ أحرف أو أكثر - حروف وأرقام',
                    textAlign: TextAlign.right,
                    secureText: !arePasswordsVisible,
                    isPassword: true, // عشان العين تظهر
                    isPasswordVisible: arePasswordsVisible,
                    toggleVisibility: () {
                      setState(() {
                        arePasswordsVisible = !arePasswordsVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Checkbox(
                        value: agreed,
                        activeColor: const Color(0xFF0A4543),
                        onChanged: (value) {
                          setState(() {
                            agreed = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'بالمتابعة، أنت توافق على الشروط وسياسة الخصوصية',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.amber, fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomAuthWidget(
                    question: 'عندك حساب؟',
                    title: 'سجل دخولك',
                    pressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomAuthWidget(
                    question: 'واجهت مشكلة؟',
                    title: 'تواصل معنا نساعدك',
                    pressed: () {
                      // يمكنك إضافة صفحة دعم لاحقًا هنا
                    },
                  ),

                  const SizedBox(height: 24),
                  CustomButton(
                    title: 'التالي',
                    pressed: () async {
                      final phone = phoneController.text.trim();
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final confirmPassword =
                          confirmPasswordController.text.trim();

                      if (!agreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('يجب الموافقة على الشروط أولاً'),
                          ),
                        );
                        return;
                      }

                      if (!email.contains('@') || !email.contains('.')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('يرجى إدخال بريد إلكتروني صحيح'),
                          ),
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('كلمة المرور وتأكيدها غير متطابقتين'),
                          ),
                        );
                        return;
                      }

                      try {
                        await supabase.auth.signInWithOtp(
                          email: email,
                        ); // ✅ يرسل كود إلى البريد

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (context) => Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: VerifyOtpView(
                                  phone: phone,
                                  isLogin: false,
                                  name: name,
                                  email: email,
                                  password: password,
                                ),
                              ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'فشل في إرسال كود التحقق: ${e.toString()}',
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 44),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
