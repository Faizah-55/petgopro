import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/user%20views/home_view.dart';
import 'package:petgo_clone/views/user%20views/orders_view.dart';
import 'package:petgo_clone/views/user%20views/profile_view.dart';

class BottomNavUser extends StatefulWidget {
  final int initialIndex;

  const BottomNavUser({super.key, this.initialIndex = 1}); // 1 = Home tab

  @override
  State<BottomNavUser> createState() => _BottomNavUserState();
}

class _BottomNavUserState extends State<BottomNavUser> {
  late int index;

  final List<Widget> views = const [
    ProfileView(),
    HomeView(),
    OrdersView(),
  ];

  final List<String> icons = [
    'assets/icons/profile.svg',
    'assets/icons/home.svg',
    'assets/icons/orders.svg',
  ];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[index],
      bottomNavigationBar: Container(
        height: 89,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          border: const Border(
            top: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return GestureDetector(
              onTap: () => setState(() => index = i),
              child: SizedBox(
                width: 30,
                height: 30,
                child: SvgPicture.asset(
                  icons[i],
                  width: 27,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    index == i ? AppTheme.yellowColor : AppTheme.grayColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}