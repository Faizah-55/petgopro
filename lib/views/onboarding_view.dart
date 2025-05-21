import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:petgo_clone/views/auth%20views/create_account_view.dart';
import 'package:petgo_clone/views/auth%20views/login_view.dart';

import 'package:petgo_clone/widgets/custom_bottom.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  OnBoardingViewState createState() => OnBoardingViewState();
}

class OnBoardingViewState extends State<OnboardingView> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPage = 0;

  void _onIntroEnd(context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginView()));
  }

  Widget _buildImage(String assetName, [double width = 379]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0);

    final pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 24,
        height: 32 / 24,
        letterSpacing: 0,
        fontWeight: FontWeight.w700,
      ),
      bodyTextStyle: GoogleFonts.changa(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: const EdgeInsets.only(top: 80.0),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
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
                textColor: Color(0xFF0A4543),
                pressed: () {
                  introKey.currentState?.previous();
                },
                backgroundColor: const Color(0xFFD9EEED),
              ),
          ],
        ),
      ),

      globalHeader: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 44, right: 20),
          child:
              currentPage < 3
                  ? TextButton(
                    onPressed: () => _onIntroEnd(context),
                    child: const Text(
                      'تخطي',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A4543),
                        fontSize: 16,
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

      onChange: (index) {
        setState(() {
          currentPage = index;
        });
      },

      pages: [
        PageViewModel(
          title: " !كل احتياجاتهم... في مكان واحد",
          body: "من أكل لألعاب، لمستلزمات طبية\n كل اللي يحتاجه حيوانك متوفر",
          image: _buildImage('onboarding1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "!كل مستلزماتهم توصل لين عندك",
          body: "خدمة توصيل سريعة وموثوقة\n بدون تعب أو مشاوير",
          image: _buildImage('onboarding2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "جاهز تبدأ؟",
          body: "...ابدأ معنا بخطوة بسيطة\nوحيواناتك بتشكرك لاحقًا",
          image: _buildImage('onboarding3.png'),
          decoration: pageDecoration,
        ),
      ],

      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFE0E0E0),
        activeColor: Color(0xFF0A4543),
        activeSize: Size(24.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
