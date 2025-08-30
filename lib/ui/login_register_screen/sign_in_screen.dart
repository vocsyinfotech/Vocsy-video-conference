import 'package:video_conforance/utilitis/common_import.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final loginController = Get.put(LoginController());

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
                title: "Sign_in".tr,
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
                    decoration: BoxDecoration(color: ConstColor.midGray, borderRadius: BorderRadius.all(Radius.circular(10.r))),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(title: "Email".tr, color: ConstColor.white, fontSize: 16.sp, fontFamily: "RSB").paddingOnly(left: 8.sp),
                            SizedBox(
                              width: 245.w,
                              child: CommonTextFiled(
                                hintText: "user@example.com",
                                controller: loginController.emailController.value,
                                isHideBorder: true,
                                textColor: ConstColor.white,
                                onChanged: (p0) {
                                  loginController.checkFillData();
                                },
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: CommonSvgView(
                                    onTap: () {
                                      loginController.emailController.value.clear();
                                    },
                                    iconPath: "assets/icons/cancel.svg",
                                    height: 14.88.h,
                                    width: 14.88.w,
                                    color: ConstColor.lightGray.withValues(alpha: .5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 10.h),
                        CommonDivider(),
                        // SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(
                              title: "Password".tr,
                              color: ConstColor.white,
                              fontSize: 16.sp,
                              fontFamily: "RSB",
                            ).paddingOnly(left: 8.sp),
                            SizedBox(
                              width: 245.w,
                              child: Obx(() {
                                return CommonTextFiled(
                                  hintText: "Required".tr,
                                  controller: loginController.passController.value,
                                  isHideBorder: true,
                                  obscuringCharacter: "*",
                                  onChanged: (p0) {
                                    loginController.errorText.value = p0;
                                    loginController.checkFillData();
                                  },
                                  obscureText: loginController.isHidePass.value,
                                  textColor: loginController.isValidPass.value ? ConstColor.white : ConstColor.red,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(10.0.sp),
                                    child: CommonSvgView(
                                      onTap: () {
                                        loginController.isHidePass.value = !loginController.isHidePass.value;
                                      },
                                      iconPath: loginController.isHidePass.value ? "assets/icons/hide_eye.svg" : "assets/icons/show_eye.svg",
                                      height: 14.88.h,
                                      width: 14.88.w,
                                      color: ConstColor.lightGray.withValues(alpha: .5),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Obx(() {
                  //   if (loginController.errorText.isNotEmpty && !loginController.isValidPass.value) {
                  //     return Row(
                  //       children: [
                  //         CommonSvgView(iconPath: "assets/icons/cancel.svg", height: 20.w, width: 20.w, color: ConstColor.red),
                  //         SizedBox(width: 10.w),
                  //         CommonTextWidget(title: loginController.errorText.value, fontFamily: "RSB", fontSize: 14.sp, color: ConstColor.red),
                  //       ],
                  //     );
                  //   } else {
                  //     return SizedBox.shrink();
                  //   }
                  // }),
                  SizedBox(height: 20.h),
                  CommonButton(
                    textSize: 18.sp,
                    title: "Sign_in".tr,
                    titleColor: ConstColor.lightGray,
                    buttonColor: loginController.isFillData.value ? ConstColor.lightBlue : ConstColor.lightBlue.withValues(alpha: 0.5),
                    onTap: () {
                      loginController.login();
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => ForgotPasswordScreen()),
                        child: CommonTextWidget(title: "Forgot_password".tr, color: ConstColor.blue, fontSize: 14.sp, fontFamily: "RR"),
                      ),
                    ],
                  ),
                  SizedBox(height: 74.h),
                  CommonTextWidget(title: "Other_Method".tr, color: ConstColor.lightGray.withValues(alpha: .5), fontFamily: "RR", fontSize: 16.sp),
                  SizedBox(height: 15.sp),
                  CommonButton(
                    icon: CommonSvgView(iconPath: "assets/icons/apple.svg"),
                    title: "Sign_in_Apple".tr,
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
                    onTap: () {
                      loginController.googleLogin();
                    },
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
