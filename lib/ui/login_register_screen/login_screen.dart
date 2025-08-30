import 'package:flutter/gestures.dart';
import 'package:video_conforance/ui/login_register_screen/sign_up_screen.dart';

import '../../utilitis/common_import.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.lightBlue,
      body: Column(
        children: [
          SizedBox(
            height: 470.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/login.png"),
                Image.asset("assets/animation/login.gif", height: 321.h),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 360.h,
            width: commonWidth,
            decoration: BoxDecoration(
              color: ConstColor.white,
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CommonTextWidget(
                  title: "Secure".tr,
                  color: ConstColor.darkGray,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontFamily: "RM",
                  fontSize: 15.sp,
                ).paddingSymmetric(horizontal: 52.w),
                SizedBox(height: 20.h),
                CommonButton(
                  titleColor: ConstColor.white,
                  title: "Join_Meeting".tr,
                  onTap: () async {
                    // customSnackBar('Alert', 'Please sign in first then after you can join meeting');

                    Get.dialog(
                        barrierDismissible: true,
                        Dialog(
                          backgroundColor: Colors.white,
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r),borderSide: BorderSide.none),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CommonTextWidget(title: 'Please sign in first then after you can join meeting',textAlign: TextAlign.center,maxLines: 3,fontSize: 16.sp,fontFamily: 'RM',color: Colors.black,),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 50.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: ConstColor.lightBlue,
                                          borderRadius: BorderRadius.circular(10.r)
                                        ),
                                        child: CommonTextWidget(title: 'Close',fontSize: 16.sp,fontFamily: 'RM',color:ConstColor.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        Get.to(() => SignInScreen());
                                      },
                                      child: Container(
                                        height: 50.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: ConstColor.lightBlue,
                                            borderRadius: BorderRadius.circular(10.r)
                                        ),
                                        child: CommonTextWidget(title: 'Sign_in'.tr,fontSize: 16.sp,fontFamily: 'RM',color: ConstColor.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ).paddingSymmetric(vertical: 20.sp, horizontal: 15.sp),
                        )
                    );
                    // Get.to(() => SignInScreen());
                   /* var isTrue = await AuthService().doesCollectionExist(
                      'newMeetings',
                    );
                    if (isTrue) {
                      Get.to(() => JoinMeetingScreen());
                    } else {
                      customSnackBar('Alert', 'No meeting available');
                    }*/
                    // Get.to(() => BottomScreen());
                  },
                  textSize: 17.sp,
                  buttonColor: ConstColor.lightBlue,
                ).paddingSymmetric(horizontal: 20.w),
                SizedBox(height: 10.h),
                CommonButton(
                  titleColor: ConstColor.darkGray,
                  title: "Sign_In".tr,
                  onTap: () {
                    Get.to(() => SignInScreen());
                  },
                  textSize: 17.sp,
                  buttonColor: ConstColor.lightGray,
                ).paddingSymmetric(horizontal: 20.w),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "RR",
                      color: ConstColor.darkGray,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(text: "Don’t_account".tr),
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ConstColor.lightBlue,
                          decoration: TextDecoration.underline,
                          fontFamily: "RM",
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => SignUpScreen());
                          },
                        text: "Sign_Up".tr,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                CommonTextWidget(
                  title: "Weboxcam",
                  fontSize: 18.sp,
                  fontFamily: "RB",
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
