import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'admin_order_control_view.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        rightLogo: Image(
          image: AssetImage('assets/logo/logo_petgo.png'), // 🟡 غيّر المسار حسب مكان اللوقو
          height: 32,
        ),
        showShadow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ عبارة الترحيب
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'مرحباً بك في لوحة التحكم',
                style: AppTheme.font20SemiBold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ✅ عنوان القسم
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الخدمات',
                style: AppTheme.font16Medium.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ زر إدارة الطلبات
            CustomButton(
              title: 'إدارة الطلبات',
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrderControlView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}