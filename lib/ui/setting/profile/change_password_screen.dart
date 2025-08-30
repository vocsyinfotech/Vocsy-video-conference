import 'package:video_conforance/utilitis/common_import.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final pc = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(
        title: 'Update_Password'.tr,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextWidget(title: 'Current_Password'.tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor.withValues(alpha: 0.5)),
          SizedBox(height: 10.sp),
          CommonTextFiled(
            controller: pc.currentPasswordController.value,
            filedColor: cardColor,
            isFiled: true,
            isHideBorder: true,
            hintText: "Enter_Old_Password".tr,
            hintStyle: TextStyle(fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor.withValues(alpha: 0.3)),
          ),
          SizedBox(height: 30.sp),
          CommonTextWidget(title: 'New_Password'.tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor.withValues(alpha: 0.5)),
          SizedBox(height: 10.sp),
          CommonTextFiled(
            controller: pc.newPasswordController.value,
            filedColor: cardColor,
            isFiled: true,
            isHideBorder: true,
            hintText: "Enter_New_Password".tr,
            hintStyle: TextStyle(fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor.withValues(alpha: 0.3)),
          ),
          SizedBox(height: 10.h),
          CommonTextWidget(title: 'Confirm_Password'.tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor.withValues(alpha: 0.5)),
          SizedBox(height: 10.sp),
          CommonTextFiled(
            controller: pc.confirmPasswordController.value,
            filedColor: cardColor,
            isFiled: true,
            isHideBorder: true,
            hintText: "Confirm_New_Password".tr,
            hintStyle: TextStyle(fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor.withValues(alpha: 0.3)),
          ),
          SizedBox(height: 50.h),
          CommonContainer(
            onTap: () {
              pc.changePassword();
            },
            height: 55.h,
            containerColor: ConstColor.lightBlue,
            child: CommonTextWidget(title: "Update".tr, fontFamily: "RSB", fontSize: 18.sp, color: ConstColor.white),
          ),
        ],
      ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }
}
