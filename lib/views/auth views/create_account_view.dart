import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/views/auth%20views/verify_otp_view.dart';
import 'package:petgo_clone/widgets/custom_auth_widget.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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

                  Center(
                    child: Text(
                      'سجّل حساب جديد',
                      style: AppTheme.font24Bold.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
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
                      color: AppTheme.yellowColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomTextfeildWidget(
                    title: 'رقم الجوال',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    secureText: false,
                    textAlign: TextAlign.right,
                    prefixWidget: CountryCodePicker(
                      onChanged:
                          (code) => print('رمز الدولة: ${code.dialCode}'),
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
                      style: AppTheme.font12Regular.copyWith(
                        color: AppTheme.grayColor,
                      ),
                      text: 'أدخل ٩ أرقام تبدأ بـ ٥ - ',
                      children: [
                        TextSpan(
                          text: 'مثال:  ٥XXXXXXXX',
                          style: AppTheme.font12Regular,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  CustomTextfeildWidget(
                    title: 'تأكيد كلمة المرور',
                    controller: confirmPasswordController,
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

                  const SizedBox(height: 20),

                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: Checkbox(
                          value: agreed,
                          onChanged: (value) {
                            setState(() {
                              agreed = value!;
                            });
                          },
                          activeColor: AppTheme.grayColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(
                              color: AppTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            style: AppTheme.font12Regular,
                            children: [
                              TextSpan(
                                text: 'بالمتابعة، أنت توافق على ',
                                style: AppTheme.font12Regular.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: 'الشروط وسياسة الخصوصية',
                                style: AppTheme.font12Regular.copyWith(
                                  color: AppTheme.yellowColor,
                                ),
                              ),
                            ],
                          ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('سيتم تفعيل الدعم لاحقًا'),
                        ),
                      );
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
                        final res = await supabase.auth.signUp(
                          email: email,
                          password: password,
                        );

                        if (res.user != null) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder:
                                (context) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
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
                        }
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
