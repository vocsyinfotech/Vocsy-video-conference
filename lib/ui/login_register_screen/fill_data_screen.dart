import 'package:video_conforance/utilitis/common_import.dart';

class FillDataScreen extends StatelessWidget {
  FillDataScreen({super.key});

  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstColor.darkGray,
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTextWidget(title: "Welcome_to_Weboxcam".tr, fontFamily: "RB", fontSize: 20.sp, color: ConstColor.lightGray),
                      CommonTextWidget(
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        title: "Set_up_display_name_text".tr,
                        fontFamily: "RR",
                        fontSize: 16.sp,
                        color: ConstColor.lightGray.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 40.w),
            SizedBox(height: 44.h),
            Container(
              width: commonWidth,
              height: 60.h,
              decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget(title: "First_Name".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB"),
                  SizedBox(
                    width: 237.w,
                    child: CommonTextFiled(
                      hintText: "Enter_First_Name".tr,
                      controller: signUpController.firstNameController.value,
                      isHideBorder: true,
                      textColor: ConstColor.white,
                      onChanged: (p0) {
                        signUpController.checkFillData();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: commonWidth,
              height: 60.h,
              decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget(title: "Last_Name".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB"),
                  SizedBox(
                    width: 237.w,
                    child: CommonTextFiled(
                      hintText: "Enter_Last_Name".tr,
                      controller: signUpController.lastNameController.value,
                      isHideBorder: true,
                      textColor: ConstColor.white,
                      onChanged: (p0) {
                        signUpController.checkFillData();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: commonWidth,
              height: 60.h,
              decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget(title: "Password".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB"),
                  SizedBox(
                    width: 237.w,
                    child: CommonTextFiled(
                      hintText: "Required".tr,
                      controller: signUpController.fillDataPasswordController.value,
                      isHideBorder: true,
                      obscuringCharacter: "*",
                      onChanged: (p0) {
                        // signUpController.errorText.value = p0;
                        signUpController.checkPasswordIsValid();
                      },
                      obscureText: signUpController.isHidePass.value,
                      textColor: signUpController.isValidPass.value ? ConstColor.white : ConstColor.red,
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(10.0.sp),
                        child: CommonSvgView(
                          onTap: () {
                            signUpController.isHidePass.value = !signUpController.isHidePass.value;
                          },
                          iconPath: signUpController.isHidePass.value ? "assets/icons/hide_eye.svg" : "assets/icons/show_eye.svg",
                          height: 14.88.w,
                          width: 14.88.w,
                          color: ConstColor.lightGray.withValues(alpha: .5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            CommonTextWidget(
              title: "Password_Requirements".tr,
              fontSize: 14.sp,
              fontFamily: "RSB",
              color: ConstColor.lightGray.withValues(alpha: .5),
            ),
            SizedBox(height: 38.h),
            CommonTextWidget(title: "Must_Contain".tr, fontSize: 14.sp, fontFamily: "RSB", color: ConstColor.lightGray),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      title: "At_least_number".tr,
                      fontSize: 14.sp,
                      fontFamily: "RSB",
                      color: ConstColor.lightGray.withValues(alpha: 0.5),
                    ).paddingSymmetric(vertical: 5.w),
                    CommonTextWidget(
                      title: "At_least_Uppercase".tr,
                      fontSize: 14.sp,
                      fontFamily: "RSB",
                      color: ConstColor.lightGray.withValues(alpha: 0.5),
                    ).paddingSymmetric(vertical: 5.w),
                    CommonTextWidget(
                      title: "At_least_lowercase".tr,
                      fontSize: 14.sp,
                      fontFamily: "RSB",
                      color: ConstColor.lightGray.withValues(alpha: 0.5),
                    ).paddingSymmetric(vertical: 5.w),
                    CommonTextWidget(
                      title: "At_least_8".tr,
                      fontSize: 14.sp,
                      fontFamily: "RSB",
                      color: ConstColor.lightGray.withValues(alpha: 0.5),
                    ).paddingSymmetric(vertical: 5.w),
                  ],
                ),
              ],
            ).paddingOnly(left: 40.w),
            Spacer(),
            CommonButton(
              textSize: 18.sp,
              title: "Confirm_sign_up".tr,
              titleColor: ConstColor.white,
              buttonColor: signUpController.isFillAllData.value ? ConstColor.lightBlue : ConstColor.lightBlue.withValues(alpha: 0.5),
              onTap: () {
                signUpController.confirmValidation();
              },
            ),
            SizedBox(height: 50.h),
          ],
        );
      }).paddingSymmetric(horizontal: 20.w),
    );
  }
}
