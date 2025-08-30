import 'package:video_conforance/utilitis/common_import.dart';

class DisplayNameScreen extends StatelessWidget {
  DisplayNameScreen({super.key});
  final pc = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Display_Name'.tr,
        titleColor: sHeaderColor,
        bgColor: cardColor,
        isLeadingWidgetIcon: true,
        leadingWidget: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: sHeaderColor),
        ),
        action: [],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CommonTextWidget(title: 'First_Name'.tr, fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor),
          ),
          SizedBox(height: 10.h),
          CommonTextFiled(
            controller: pc.displayFirstNameController.value,
            isFiled: true,
            filedColor: cardColor,
            isHideBorder: true,
            hintText: "Enter first name",
            hintStyle: TextStyle(fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor.withValues(alpha: 0.5)),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: CommonTextWidget(title: 'Last_Name'.tr, fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor),
          ),
          SizedBox(height: 10.h),
          CommonTextFiled(
            controller: pc.displayLastNameController.value,
            isFiled: true,
            filedColor: cardColor,
            isHideBorder: true,
            hintText: "Enter last name",
            hintStyle: TextStyle(fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor.withValues(alpha: 0.5)),
          ),
          SizedBox(height: 30.h),
          CommonContainer(
            onTap: () {
              // CommonVariable.userName.value = '${pc.displayFirstNameController.value.text} ${pc.displayLastNameController.value.text}';
              pc.fullName.value = '${pc.displayFirstNameController.value.text} ${pc.displayLastNameController.value.text}';
              Get.back();
            },
            height: 55.h,
            radius: 10.r,
            child: CommonTextWidget(title: 'Done'.tr, fontFamily: "RSB", fontSize: 18.sp, color: ConstColor.white),
          ),
        ],
      ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }
}
