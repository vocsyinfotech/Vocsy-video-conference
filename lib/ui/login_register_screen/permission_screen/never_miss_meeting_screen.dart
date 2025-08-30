import 'package:video_conforance/utilitis/common_import.dart';

class NeverMissMeetingScreen extends StatelessWidget {
  NeverMissMeetingScreen({super.key});
  final signUpController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 130.h),
          CommonTextWidget(title: "Never_Miss_a_meetings".tr, color: sHeaderColor, fontSize: 24.sp, fontFamily: "RB"),
          SizedBox(height: 5.h),
          CommonTextWidget(
            textAlign: TextAlign.center,
            maxLines: 3,
            title: "Allow_Weboxcam_to_access_your".tr,
            color: sHeaderColor,
            fontSize: 16.sp,
            fontFamily: "RR",
          ),
          SizedBox(height: 41.h),
          CommonSvgView(iconPath: "assets/images/event_reminder.svg"),
          Spacer(),
          CommonButton(
            titleColor: ConstColor.white,
            title: "Continue".tr,
            onTap: () async {
              await signUpController.requestNotificationPermission();
              Get.off(() => ReadyToGoScreen());
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
