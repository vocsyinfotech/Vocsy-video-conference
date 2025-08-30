import 'package:flutter/gestures.dart';

import 'package:video_conforance/utilitis/common_import.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.darkGray,
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              CommonAppBar(
                leadingWidth: 90.w,
                title: "Sign_up".tr,
                appBarColor: ConstColor.darkGray,
                leading: Align(
                  alignment: Alignment.center,
                  child: CommonTextWidget(title: "Cancel".tr, fontFamily: "RSB", fontSize: 16.sp, color: ConstColor.white, onTap: Get.back),
                ),
              ),
              SizedBox(height: 30.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    title: "Enter_your_email".tr,
                    color: ConstColor.lightGray.withValues(alpha: .5),
                    fontFamily: "RR",
                    fontSize: 16.sp,
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: commonWidth,
                    height: 60.h,
                    decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 8.w),
                        CommonTextWidget(title: "Email".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB"),
                        Expanded(
                          child: CommonTextFiled(
                            hintText: "user@example.com",
                            controller: signUpController.emailController.value,
                            onChanged: (p0) {
                              if (signUpController.emailController.value.text.isNotEmpty) {
                                signUpController.isEmailIsNotEmpty.value = true;
                              } else {
                                signUpController.isEmailIsNotEmpty.value = false;
                              }
                            },
                            isHideBorder: true,
                            textColor: ConstColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CommonButton(
                    textSize: 18.sp,
                    title: "Next".tr,
                    titleColor: ConstColor.lightGray,
                    buttonColor: signUpController.isEmailIsNotEmpty.value ? ConstColor.lightBlue : ConstColor.lightBlue.withValues(alpha: 0.5),
                    onTap: () {
                      signUpController.checkEmail();
                    },
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontFamily: "RR", color: ConstColor.lightGray.withValues(alpha: 0.5), fontSize: 14.sp),
                          children: [
                            TextSpan(text: "Already_have_account".tr),
                            TextSpan(
                              style: TextStyle(fontSize: 14.sp, color: ConstColor.lightBlue, decoration: TextDecoration.underline, fontFamily: "RM"),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => SignInScreen());
                                },
                              text: "Sign_in".tr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 147.h),
                  CommonTextWidget(
                    title: "Other_sign_up_Method".tr,
                    color: ConstColor.lightGray.withValues(alpha: .5),
                    fontFamily: "RR",
                    fontSize: 16.sp,
                  ),
                  SizedBox(height: 15.sp),
                  CommonButton(
                    icon: CommonSvgView(iconPath: "assets/icons/apple.svg"),
                    title: "Sign_in_Google".tr,
                    textSize: 16.sp,
                    titleColor: ConstColor.lightGray,
                    onTap: () {},
                    buttonColor: ConstColor.neroGray,
                  ),
                  SizedBox(height: 10.sp),
                  CommonButton(
                    icon: CommonSvgView(iconPath: "assets/icons/google.svg", height: 20, width: 20),
                    title: "Sign_in_Google".tr,
                    textSize: 16.sp,
                    titleColor: ConstColor.lightGray,
                    onTap: () {},
                    buttonColor: ConstColor.neroGray,
                  ),
                ],
              ).paddingSymmetric(horizontal: 20.w),
            ],
          );
        }),
      ),
    );
  }
}
