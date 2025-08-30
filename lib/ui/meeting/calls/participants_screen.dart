import 'package:video_conforance/utilitis/common_import.dart';

class ParticipantsScreen extends StatelessWidget {
  const ParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50.h),
          Align(
            alignment: Alignment.centerLeft,
            child: CommonTextWidget(title: 'Cancel'.tr, color: ConstColor.lightBlue, fontFamily: "RSB", fontSize: 16.sp, onTap: () => Get.back()),
          ),
          SizedBox(height: 10.h),
          CommonTextWidget(textAlign: TextAlign.center, title: 'Weboxcam', color: ConstColor.lightBlue, fontSize: 30.sp, fontFamily: "RB"),
          Spacer(),
          Container(
            height: 200.w,
            width: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: NetworkImage('https://cdn.pixabay.com/photo/2025/07/03/07/27/peacock-butterfly-9693820_640.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CommonTextWidget(title: 'Vocsy Desiner', fontSize: 30.sp, fontFamily: "RB", color: Theme.of(context).secondaryHeaderColor),
          SizedBox(height: 5.h),
          CommonTextWidget(title: 'Personal Room Meeting  ', fontSize: 18.sp, fontFamily: "RM", color: Theme.of(context).secondaryHeaderColor),
          SizedBox(height: 10.h),
          Spacer(),
          CommonContainer(
            onTap: () {
              Get.to(() => LoadingScreen());
            },
            height: 55.h,
            containerColor: ConstColor.lightBlue,
            radius: 10.r,
            child: CommonTextWidget(title: 'Join'.tr, fontSize: 18.sp, fontFamily: "RSB", color: ConstColor.white),
          ),
        ],
      ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }
}
