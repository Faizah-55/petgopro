import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';

class ProfileSupportView extends StatelessWidget {
  const ProfileSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم العربية
      child: Scaffold(
        appBar: CustomAppBar(
          showShadow: true,
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.headset_mic_rounded, color: AppTheme.yellowColor),
              SizedBox(width: 6),
              Text("خدمة العملاء", style: AppTheme.font20SemiBold),
            ],
          ),
          rightButton: SquareIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ListView(
            children: [
              // العنوان الرئيسي "طرق التواصل"
              Text(
                "طرق التواصل",
                style: AppTheme.font16SemiBold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Divider(color: Colors.grey.shade300, thickness: 1),

              _buildContactItem(
                title: "الرقم",
                value: "920000987",
                icon: Icons.call,
              ),
              _divider(),

              _buildContactItem(
                title: "البريد الإلكتروني",
                value: "PetGoCare@gmail.com",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 30),

              Text(
                "حسابات التواصل الإجتماعي",
                style: AppTheme.font16SemiBold.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Divider(color: Colors.grey.shade300, thickness: 1),

              _buildContactItem(
                title: "تويتر",
                value: "@PetG01",
                icon: Icons.numbers, // تقدر تغيرها لأيقونة تويتر SVG إذا حبيت
              ),
              _divider(),

              _buildContactItem(
                title: "إنستقرام",
                value: "@PetG01",
                icon: Icons.camera_alt_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // النص يمين
              children: [
                Text(
                  title,
                  style: AppTheme.font14Regular.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 0),
                Text(
                  value,
                  style: AppTheme.font14Regular.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            color: AppTheme.yellowColor,
            size: 21,
          ), // الأيقونة في اليسار
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, thickness: 1, height: 10);
  }
}
