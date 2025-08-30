import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utilitis/common_widget.dart';
import '../../utilitis/constant.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.darkGray,
      body: Column(
        children: [
          CommonAppBar(
            leadingWidth: 70.w,
            title: "Forgot_Password".tr,
            appBarColor: ConstColor.darkGray,
            leading: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 24.sp, color: ConstColor.white),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(title: "Enter_your_email".tr, color: ConstColor.lightGray.withValues(alpha: .5), fontFamily: "RR", fontSize: 16.sp),
              SizedBox(height: 10.h),
              Container(
                width: commonWidth,
                height: 60.h,
                decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(title: "Email".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB"),
                    SizedBox(
                      width: 237.w,
                      child: CommonTextFiled(
                        hintText: "user@example.com",
                        controller: TextEditingController(),
                        isHideBorder: true,
                        textColor: ConstColor.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              CommonTextWidget(title: "Reset_password_text".tr, color: ConstColor.lightGray.withValues(alpha: .5), fontFamily: "RR", fontSize: 12.sp),
              SizedBox(height: 69.h),
              CommonButton(
                textSize: 18.sp,
                title: "Send".tr,
                titleColor: ConstColor.lightGray /*ConstColor.white*/,
                buttonColor: ConstColor.blue.withValues(alpha: 0.5) /*ConstColor.lightBlue*/,
                onTap: () async {
                  await showEmailSentDialog(context);
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ],
      ),
    );
  }

  Future showEmailSentDialog(BuildContext context) async {
    return Get.dialog(
      barrierDismissible: false,
      Center(
        child: Container(
          decoration: BoxDecoration(color: ConstColor.eerieBlack, borderRadius: BorderRadius.circular(14.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonTextWidget(
                maxLines: 4,
                textAlign: TextAlign.center,
                title: "Forgot_Password_Dialog_Text".tr,
                color: ConstColor.white,
                fontSize: 13.sp,
              ).paddingSymmetric(horizontal: 16.w, vertical: 16.w),
              CommonDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: CommonTextWidget(title: "OK".tr, color: ConstColor.lightBlue, textAlign: TextAlign.center),
                  ),
                ],
              ),
            ],
          ),
        ).paddingSymmetric(horizontal: 55.w),
      ),
    );
  }
}
