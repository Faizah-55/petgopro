import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/widgets/custom_appbarr.dart';
import 'package:petgo_clone/widgets/custom_bottom_section%20.dart';
import 'package:petgo_clone/widgets/square_icon_button.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  bool _notificationsEnabled = true;
  bool _offersByEmailEnabled = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // الواجهة من اليمين لليسار
      child: Scaffold(
        appBar: CustomAppBar(
          showShadow: true,
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, color: AppTheme.yellowColor),
              SizedBox(width: 6),
              Text("الإعدادات", style: AppTheme.font20SemiBold),
            ],
          ),
          rightButton: SquareIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "تلقي إشعارات فورية",
                    style: AppTheme.font16SemiBold.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: AppTheme.greenLocationColor,
                  ),
                ],
              ),
            ),
            _divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "تلقي عروضنا على البريد الإلكتروني",
                    style: AppTheme.font16SemiBold.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Switch(
                    value: _offersByEmailEnabled,
                    onChanged: (value) {
                      setState(() {
                        _offersByEmailEnabled = value;
                      });
                    },
                    activeColor: AppTheme.greenLocationColor,
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomBottomSection(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: CustomButton(
                  title: "تسجيل الخروج",
                  pressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  backgroundColor:
                      _isHovering ? AppTheme.redColor : AppTheme.whiteColor,
                  textColor:
                      _isHovering ? AppTheme.whiteColor : AppTheme.redColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, thickness: 1, height: 4);
  }
}
