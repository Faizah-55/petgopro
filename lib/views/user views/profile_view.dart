import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';

import 'package:petgo_clone/views/user%20views/my_profile_details_view.dart';
import 'package:petgo_clone/views/user%20views/profile_favorites_view.dart';
import 'package:petgo_clone/views/user%20views/profile_payment_methods_view.dart';
import 'package:petgo_clone/views/user%20views/profile_addresses_view.dart';
import 'package:petgo_clone/views/user%20views/profile_support_view.dart';
import 'package:petgo_clone/views/user%20views/profile_settings_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // لدعم الاتجاه من اليمين لليسار
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Column(
          children: [
            // الشعار العلوي
            CustomAppBar(
              titleWidget: Image.asset(
                'assets/logo/logo_petgo.png',
                width: 111,
                height: 31,
              ),
              showShadow: true,
            ),

            // القائمة بدون مستطيل أبيض
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildItem(
                    context,
                    icon: Icons.person,
                    title: "ملفي الشخصي",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyProfileDetailsView(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.favorite_border,
                    title: "المفضلة",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyProfileFavoritesView(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.credit_card,
                    title: "طرق الدفع",
                    onTap: () {},
                    //() => Navigator.push(
                    //context,
                    //MaterialPageRoute(
                    //builder: (_) => const MyProfilePaymentMethodsView(),
                    //),
                    //),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: "العناوين",
                    onTap: () {},
                    //() => Navigator.push(
                    //context,
                    //MaterialPageRoute(
                    //builder: (_) => const ProfileAddressesView(),
                    ////),
                    //),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.headset_mic_outlined,
                    title: "خدمة العملاء",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileSupportView(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: "الإعدادات",
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileSettingsView(),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // الأيقونة (يمين)
                Icon(icon, color: AppTheme.yellowColor, size: 21),

                const SizedBox(width: 16),

                // النص
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.font16SemiBold.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),

                // السهم (يسار)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 6),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12, // الحجم المصغر المطلوب
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // خط ظل خفيف بين العناصر
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 1,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
