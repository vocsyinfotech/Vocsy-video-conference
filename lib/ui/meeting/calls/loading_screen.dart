import 'package:video_conforance/utilitis/common_import.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.lightBlue,
      body: Column(
        children: [
          SizedBox(height: 50.h),
          Align(
            alignment: Alignment.centerLeft,
            child: CommonTextWidget(title: 'Cancel'.tr, color: ConstColor.white, fontFamily: "RSB", fontSize: 16.sp, onTap: () => Get.back()),
          ),
          SizedBox(height: 10.h),
          CommonTextWidget(textAlign: TextAlign.center, title: 'Weboxcam', color: ConstColor.white, fontSize: 30.sp, fontFamily: "RB"),
          Divider(color: ConstColor.white.withValues(alpha: 0.3)),
          Spacer(),
          CommonTextWidget(title: 'Vocsy Desiner', fontSize: 40.sp, fontFamily: "RB", color: ConstColor.white),
          SizedBox(height: 10.h),
          CommonTextWidget(title: 'Personal Room Meeting', fontSize: 30.sp, fontFamily: "RSB", color: ConstColor.white),
          SizedBox(height: 10.h),
          CommonTextWidget(title: 'Waiting for the host to start the meeting', fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
          SizedBox(height: 10.h),
          Image.asset('assets/animation/loader.gif', height: 170.w),
          Spacer(),
        ],
      ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }
}
