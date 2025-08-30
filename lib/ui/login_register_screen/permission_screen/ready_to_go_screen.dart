import 'package:video_conforance/utilitis/common_import.dart';

class ReadyToGoScreen extends StatelessWidget {
  const ReadyToGoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 130.h),
          CommonTextWidget(title: "You’re_ready".tr, color: sHeaderColor, fontSize: 24.sp, fontFamily: "RB"),
          SizedBox(height: 5.h),
          CommonTextWidget(
            textAlign: TextAlign.center,
            maxLines: 3,
            title: "Welcome_to_Weboxcam_for_Team_chat".tr,
            color: sHeaderColor,
            fontSize: 16.sp,
            fontFamily: "RR",
          ),
          SizedBox(height: 116.h),
          Image.asset("assets/animation/business_meeting_ready_to_go.gif"),
          Spacer(),
          CommonButton(
            titleColor: ConstColor.white,
            title: "Go_To_Home".tr,
            onTap: () {
              Preferences.isLogin = true;
              Preferences.isTackPermission = true;
              Get.offAll(() => BottomScreen());
            },
            textSize: 17.sp,
            buttonColor: ConstColor.lightBlue,
          ),
          SizedBox(height: 40.h),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}
