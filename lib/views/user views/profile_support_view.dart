

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                icon: Icon(Icons.call, color: AppTheme.yellowColor, size: 21),
              ),
              _divider(),

              _buildContactItem(
                title: "البريد الإلكتروني",
                value: "PetGoCare@gmail.com",
                icon: Icon(Icons.email_outlined, color: AppTheme.yellowColor, size: 21),
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
                icon: FaIcon(FontAwesomeIcons.twitter, color: AppTheme.yellowColor, size: 21),
              ),
              _divider(),

              _buildContactItem(
                title: "إنستقرام",
                value: "@PetG01",
                icon: FaIcon(FontAwesomeIcons.instagram, color: AppTheme.yellowColor, size: 21),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// تعديل: صار يقبل أي Widget بدلاً من IconData
  Widget _buildContactItem({
    required String title,
    required String value,
    required Widget icon,
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
          icon, // الأيقونة في اليسار (صار يقبل أي Widget)
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, thickness: 1, height: 10);
  }
}