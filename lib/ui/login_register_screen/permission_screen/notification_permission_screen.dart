import 'package:video_conforance/utilitis/common_import.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 130.h),
          CommonTextWidget(title: "Get_Notified".tr, color: sHeaderColor, fontSize: 24.sp, fontFamily: "RB"),
          SizedBox(height: 5.h),
          CommonTextWidget(
            textAlign: TextAlign.center,
            maxLines: 3,
            title: "Enable_notifications_text".tr,
            color: sHeaderColor,
            fontSize: 16.sp,
            fontFamily: "RR",
          ),
          SizedBox(height: 36.h),
          CommonSvgView(iconPath: "assets/images/notification_permission.svg"),
          Spacer(),
          CommonButton(
            titleColor: ConstColor.white,
            title: "Enable_notifications".tr,
            onTap: () {
              Get.to(() => NeverMissMeetingScreen());
            },
            textSize: 17.sp,
            buttonColor: ConstColor.lightBlue,
          ),
          SizedBox(height: 10.h),
          CommonButton(
            titleColor: Colors.black,
            title: "Not_Now".tr,
            onTap: () {
              Get.to(() => BottomScreen());
              // Get.to(() => SignInScreen());
            },
            textSize: 17.sp,
            buttonColor: Colors.white,
          ),
          SizedBox(height: 40.h),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}
