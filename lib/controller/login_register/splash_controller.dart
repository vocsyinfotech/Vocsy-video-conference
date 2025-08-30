import 'package:video_conforance/utilitis/common_import.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> fadeInFadeOut;
  final RxBool startAnimation = RxBool(false);
  final pageController = PageController();
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);
  final List<Map<String, dynamic>> onBoardingList = [
    {"title": "OnBoardingText1", "back_image": "assets/images/onboarding_1.png", "front_image": "assets/animation/on_boarding_1.gif"},
    {"title": "OnBoardingText2", "back_image": "assets/images/onboarding_2.png", "front_image": "assets/animation/on_boarding_2.gif"},
    {"title": "OnBoardingText3", "back_image": "assets/images/onboarding_1.png", "front_image": "assets/animation/on_boarding_3.gif"},
  ];

  @override
  void onInit() {
    super.onInit();
    animation = AnimationController(vsync: this, duration: Duration(seconds: 1));
    fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
    animation.animateTo(1.0, duration: Duration(seconds: 1));
    animation.addListener(() {
      animation.forward();
      if (animation.isCompleted) {
        startAnimation.value = true;
      }
    });
    if (Preferences.isShowBoarding) {
      Future.delayed(Duration(seconds: 3), () {
        navigationMethode();
      });
    }
  }

  void navigationMethode() {
    if (Preferences.isShowBoarding && !Preferences.isLogin) {
      // print('hghghghghghghghghghghhvnbnnnnb');
      Get.offAll(() => LoginScreen());
    } else if (Preferences.isLogin) {
      Get.offAll(() => BottomScreen());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }
}
