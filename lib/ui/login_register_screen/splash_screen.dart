import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_conforance/utilitis/common_widget.dart';

import '../../controller/login_register/splash_controller.dart';
import '../../utilitis/constant.dart';
import 'onBoarding_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/splash_image.png", height: commonHeight, width: commonWidth, fit: BoxFit.cover),
          Container(alignment: Alignment.center, height: commonHeight, width: commonWidth, color: ConstColor.blue.withValues(alpha: 0.5)),

          Obx(() {
            splashController.startAnimation.value;
            return AnimatedPositioned(
              top: splashController.startAnimation.isTrue ? 100.h : 330.h,
              duration: Duration(seconds: 1),
              child: Center(
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: splashController.animation,
                      child: CommonTextWidget(
                        title: "LOGO",
                        fontSize: splashController.startAnimation.isTrue ? 24.h : 50.sp,
                        fontFamily: "RSB",
                        color: ConstColor.white,
                      ),
                    ),
                    FadeTransition(
                      opacity: splashController.fadeInFadeOut,
                      child: CommonTextWidget(
                        title: "APP Name",
                        fontSize: splashController.startAnimation.isTrue ? 24.h : 50.sp,
                        color: ConstColor.white,
                        fontFamily: "RSB",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          Obx(() {
            splashController.startAnimation.isTrue;
            return AnimatedPositioned(
              duration: Duration(seconds: 1),
              bottom: splashController.startAnimation.isTrue ? 50.h : 0.0.h,
              left: 25.w,
              right: 25.w,
              child: splashController.startAnimation.isTrue
                  ? CommonButton(
                      radius: 50.r,
                      title: "Start_Calling".tr,
                      buttonColor: ConstColor.white,
                      titleColor: ConstColor.blue,
                      onTap: () {
                        // Get.to(() => OnboardingScreen());
                        splashController.navigationMethode();
                      },
                    )
                  : SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }
}
