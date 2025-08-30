import 'package:video_conforance/utilitis/common_import.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70.h),
          ValueListenableBuilder(
            valueListenable: splashController.currentPage,
            builder: (context, value, child) {
              return Align(
                alignment: Alignment.topRight,
                child: CommonTextWidget(
                  title: value != 2 ? "Skip".tr : '',
                  color: sHeaderColor.withValues(alpha: 0.5),
                  fontFamily: "RSB",
                  fontSize: 17.sp,
                  onTap: () {
                    Preferences.isShowBoarding = true;
                    Get.offAll(() => LoginScreen());
                  },
                ),
              ).paddingOnly(right: 30.w);
            },
          ),
          SizedBox(height: 34.h),
          SizedBox(
            height: 450.h,
            child: PageView.builder(
              controller: splashController.pageController,
              itemCount: splashController.onBoardingList.length,
              onPageChanged: (value) => splashController.currentPage.value = value,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 310.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 310.h,
                            width: commonWidth,
                            child: Image.asset(splashController.onBoardingList[index]['back_image'], fit: BoxFit.cover),
                          ),
                          Image.asset(splashController.onBoardingList[index]['front_image'], fit: BoxFit.cover).paddingSymmetric(horizontal: 30.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 80.h),
                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      title: '${splashController.onBoardingList[index]['title']}'.tr,
                      color: sHeaderColor,
                      fontFamily: "RB",
                      fontSize: 18.sp,
                    ).paddingSymmetric(horizontal: 20.w),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          SmoothPageIndicator(
            controller: splashController.pageController,
            count: 3,
            axisDirection: Axis.horizontal,
            effect: JumpingDotEffect(
              offset: 25,
              dotHeight: 10.w,
              dotWidth: 10.w,
              activeDotColor: ConstColor.lightBlue,
              dotColor: sHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          Spacer(),
          ValueListenableBuilder(
            valueListenable: splashController.currentPage,
            builder: (context, value, child) {
              return CommonButton(
                titleColor: ConstColor.white,
                title: value != 2 ? "Next".tr : "Done".tr,
                onTap: () {
                  if (value != 2) {
                    splashController.pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.ease);
                  } else {
                    Preferences.isShowBoarding = true;
                    Get.to(() => LoginScreen());
                  }
                },
                buttonColor: ConstColor.lightBlue,
              ).paddingSymmetric(horizontal: 25.w);
            },
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
