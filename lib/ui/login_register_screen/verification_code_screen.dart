import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_conforance/ui/login_register_screen/fill_data_screen.dart';
import 'package:video_conforance/utilitis/common_widget.dart';

import '../../utilitis/constant.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.darkGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommonAppBar(
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
            SizedBox(height: 54.h),
            Column(
              children: [
                CommonTextWidget(title: "Check_your_email".tr, fontSize: 20.sp, fontFamily: "RB", color: ConstColor.lightGray),
                SizedBox(height: 10.h),
                CommonTextWidget(
                  textAlign: TextAlign.center,
                  title: "Verification_code_text".tr,
                  fontSize: 16.sp,
                  fontFamily: "RR",
                  maxLines: 2,
                  color: ConstColor.lightGray.withValues(alpha: 0.5),
                ).paddingSymmetric(horizontal: 70.w),
                SizedBox(height: 40.h),
                Container(
                  width: commonWidth,
                  height: 60.h,
                  decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget(title: "Code".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB"),
                      SizedBox(
                        width: 237.w,
                        child: CommonTextFiled(
                          hintText: "Verification_Code".tr,
                          controller: TextEditingController(),
                          isHideBorder: true,
                          textColor: ConstColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                CommonButton(
                  textSize: 18.sp,
                  title: "Next".tr,
                  titleColor: ConstColor.lightGray /*ConstColor.white*/,
                  buttonColor: ConstColor.blue.withValues(alpha: 0.5) /*ConstColor.lightBlue*/,
                  onTap: () {
                    Get.to(() => FillDataScreen());
                  },
                ),
                SizedBox(height: 30.h),
                CommonTextWidget(
                  textAlign: TextAlign.center,
                  title: "Didn’t_receive_verification_code".tr,
                  fontSize: 16.sp,
                  fontFamily: "RR",
                  maxLines: 1,
                  color: ConstColor.lightGray.withValues(alpha: 0.5),
                ),
                TextButton(
                  onPressed: () {},
                  child: CommonTextWidget(title: "Resend".tr, fontFamily: "RM", fontSize: 14.sp, color: ConstColor.blue),
                ),
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ],
        ),
      ),
    );
  }
}
