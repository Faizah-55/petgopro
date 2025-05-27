import 'package:flutter/material.dart';
import 'package:petgo_clone/theme/app_theme.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';
import 'package:petgo_clone/widgets/custom_buttom.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => OnboardingViewState();
}

class OnboardingViewState extends State<OnboardingView> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPage = 0;

  void _onIntroEnd(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  Widget _buildImage(String assetName, [double width = 379]) {
    return Image.asset('assets/app_img/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final pageDecoration = PageDecoration(
      titleTextStyle: textTheme.bodyLarge!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
      ),
      bodyTextStyle: textTheme.bodyMedium!.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 26 / 18,
      ),
      bodyPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      imagePadding: const EdgeInsets.only(top: 80),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: AppTheme.backgroundColor,

      // ✅ الزر السفلي
      globalFooter: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              title: currentPage == 2 ? 'ابدأ' : 'التالي',
              pressed: () {
                if (currentPage == 2) {
                  _onIntroEnd(context);
                } else {
                  introKey.currentState?.next();
                }
              },
            ),
            const SizedBox(height: 12),
            if (currentPage > 0)
              CustomButton(
                title: 'السابق',
                textColor: AppTheme.primaryColor,
                backgroundColor: const Color(0xFFD9EEED),
                pressed: () => introKey.currentState?.previous(),
              ),
          ],
        ),
      ),

      // ✅ زر التخطي العلوي
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 44, right: 20),
          child: currentPage < 2
              ? TextButton(
                  onPressed: () => _onIntroEnd(context),
                  child: Text(
                    'تخطي',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),

      showSkipButton: false,
      showBackButton: false,
      showNextButton: false,
      done: const SizedBox.shrink(),
      next: const SizedBox.shrink(),

      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      onChange: (index) => setState(() => currentPage = index),

      pages: [
        PageViewModel(
          title: '!كل احتياجاتهم... في مكان واحد',
          body: 'من أكل لألعاب، لمستلزمات طبية\nكل اللي يحتاجه حيوانك متوفر',
          image: _buildImage('onboarding1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: '!كل مستلزماتهم توصل لين عندك',
          body: 'خدمة توصيل سريعة وموثوقة\nبدون تعب أو مشاوير',
          image: _buildImage('onboarding2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'جاهز تبدأ؟',
          body: 'ابدأ معنا بخطوة بسيطة\nوحيواناتك بتشكرك لاحقًا',
          image: _buildImage('onboarding3.png'),
          decoration: pageDecoration,
        ),
      ],

      // ✅ نقاط المؤشر
      dotsDecorator: const DotsDecorator(
        size: Size(10, 10),
        color: Color(0xFFE0E0E0),
        activeColor: AppTheme.primaryColor,
        activeSize: Size(24, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
