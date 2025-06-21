import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/bottom_nav_user.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';

class OrderSuccessView extends StatefulWidget {
  const OrderSuccessView({super.key});

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView> {
  @override
  void initState() {
    super.initState();
    // نفتح البوتوم شيت بعد أول فريم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppTheme.backgroundColor,
        builder: (context) => _buildSuccessSheet(context),
      );
    });
  }

  Widget _buildSuccessSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'تم استلام طلبك بنجاح',
            style: AppTheme.font24Bold.copyWith(color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            'نجهز طلبك الآن، وتقدر تتابع حالته من صفحة الطلبات',
            style: AppTheme.font16Medium.copyWith(color: AppTheme.primaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          CustomButton(
            title: 'اذهب لصفحة الطلبات',
            pressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BottomNavUser(initialIndex: 2)),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الخلفية تكون شفافة بس تجهز عشان السياق
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: const SizedBox(),
    );
  }
}