import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/custom_textfelid_widget.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfileDetailsView extends StatefulWidget {
  const MyProfileDetailsView({super.key});

  @override
  State<MyProfileDetailsView> createState() => _MyProfileDetailsViewState();
}

class _MyProfileDetailsViewState extends State<MyProfileDetailsView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController(text: "");

  final supabase = Supabase.instance.client;

  bool isLoading = true;
  bool isEditing = false; // 🟡 يتحكم بإظهار زر التحديث

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    final response =
        await supabase.from('users').select().eq('user_id', userId).single();

    nameController.text = response['username'] ?? '';
    phoneController.text = response['number'].toString();
    emailController.text = response['email'] ?? '';

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateName() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    try {
      await supabase
          .from('users')
          .update({'username': nameController.text.trim()})
          .eq('user_id', userId);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم تحديث الاسم بنجاح')));

      setState(() {
        isEditing = false; // بعد الحفظ نخفي الزر
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التحديث: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showShadow: true,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, color: AppTheme.yellowColor),
            SizedBox(width: 6),
            Text("ملفي الشخصي", style: AppTheme.font20SemiBold),
          ],
        ),
        rightButton: SquareIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        leftButton: SquareIconButton(
          icon: Icons.edit, // ✏ زر التعديل
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // الاسم (قابل للتعديل فقط إذا كان isEditing true)
                    CustomTextfeildWidget(
                      title: "الاسم",
                      controller: nameController,
                      secureText: false,
                      textAlign: TextAlign.right,
                      enabled: isEditing,
                      prefixWidget: const Icon(
                        Icons.person,
                        color: AppTheme.yellowColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // رقم الجوال
                    CustomTextfeildWidget(
                      title: "رقم الجوال",
                      controller: phoneController,
                      secureText: false,
                      textAlign: TextAlign.right,
                      enabled: false,
                      prefixWidget: const Icon(
                        Icons.phone,
                        color: AppTheme.yellowColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // البريد الإلكتروني
                    CustomTextfeildWidget(
                      title: "البريد الإلكتروني",
                      controller: emailController,
                      secureText: false,
                      textAlign: TextAlign.right,
                      enabled: false,
                      prefixWidget: const Icon(
                        Icons.mail_outline,
                        color: AppTheme.yellowColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 100), // علشان ما يغطيه السكشن
                  ],
                ),
              ),

      // ✅ السكشن السفلي يظهر فقط إذا isEditing = true
      bottomNavigationBar:
          isEditing
              ? CustomBottomSection(
                child: CustomButton(title: "تحديث", pressed: updateName),
              )
              : null,
    );
  }
}
