import 'dart:convert';

import 'package:video_conforance/utilitis/common_import.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return SingleChildScrollView(
      child: Obx(() {
        Uint8List bytes = base64Decode(CommonVariable.userImage.value);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileScreen());
              },
              child: Row(
                children: [
                  CommonVariable.userImage.isEmpty
                      ? Container(
                          height: 70.w,
                          width: 70.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: ConstColor.lightBlue),
                          child: CommonTextWidget(
                            title: getUserInitials(CommonVariable.userName.value),
                            fontFamily: "RSB",
                            fontSize: 16.sp,
                            color: ConstColor.white,
                          ),
                        )
                      : Container(
                          height: 70.w,
                          width: 70.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            image: DecorationImage(
                              image: CommonVariable.userImage.value.isEmpty
                                  ? NetworkImage('https://cdn.pixabay.com/photo/2024/09/20/03/30/ai-generated-9060228_640.png')
                                  : MemoryImage(bytes),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget(title: CommonVariable.userName.value, fontFamily: "RB", fontSize: 18.sp, color: sHeaderColor),
                        CommonTextWidget(
                          title: CommonVariable.userEmail.value,
                          fontFamily: "RM",
                          fontSize: 14.sp,
                          color: sHeaderColor.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(width: 110.w),
                  Icon(Icons.arrow_forward_ios_rounded, color: sHeaderColor.withValues(alpha: 0.9), size: 20.sp).paddingOnly(right: 15.sp),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Divider(thickness: 1, color: sHeaderColor.withValues(alpha: 0.1)),
            SizedBox(height: 10.h),
            ListTile(
              onTap: () {
                Get.to(() => SetStatusScreen());
              },
              leading: Container(
                height: 42.w,
                width: 42.w,
                padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: ConstColor.lightBlue),
                child: CommonSvgView(iconPath: 'assets/icons/profile.svg', height: 25.w, width: 25.w, fit: BoxFit.cover),
              ),
              title: CommonTextWidget(title: 'Set_Status'.tr, fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonTextWidget(title: 'Online'.tr, fontSize: 14.sp, fontFamily: "RM", color: sHeaderColor),
                  SizedBox(width: 10.w),
                  Icon(Icons.circle, size: 10.sp, color: Colors.green),
                  SizedBox(width: 15.w),
                  Icon(Icons.arrow_forward_ios_rounded, size: 20.sp, color: sHeaderColor.withValues(alpha: 0.9)),
                  SizedBox(width: 10.w),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
            ),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(
              iconPath: 'assets/icons/notification.svg',
              title: "Notification_Preference".tr,
              context: context,
              onTap: () {
                Get.to(() => NotificationPreferenceScreen());
              },
            ),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(
              iconPath: 'assets/icons/languages.svg',
              title: "Languages".tr,
              context: context,
              onTap: () {
                Get.to(() => LanguageScreen());
              },
            ),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(
              iconPath: 'assets/icons/theme.svg',
              title: "Theme".tr,
              context: context,
              onTap: () {
                Get.to(() => ChangeThemeScreen());
              },
            ),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(iconPath: 'assets/icons/about.svg', title: "About_Us".tr, context: context, onTap: () {}),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(iconPath: 'assets/icons/tp.svg', title: "Terms_Policy".tr, context: context, onTap: () {}),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(iconPath: 'assets/icons/rate.svg', title: "Rate_App".tr, context: context, onTap: () {}),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(iconPath: 'assets/icons/share.svg', title: "Share_App".tr, context: context, onTap: () {}),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(iconPath: 'assets/icons/help.svg', title: "Help_Support".tr, context: context, onTap: () {}),
            _divider(context),
            SizedBox(height: 10.h),
            _buildSettingsItem(
              iconPath: 'assets/icons/logout.svg',
              title: "Logout".tr,
              context: context,
              onTap: () {
                logoutBottomSheet(context);
              },
              i: 1,
            ),
          ],
        );
      }).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }

  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    required BuildContext context,
    required VoidCallback onTap,
    int i = 0,
  }) {
    return ListTile(
      leading: Container(
        height: 42.w,
        width: 42.w,
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: i == 1 ? ConstColor.red : ConstColor.lightBlue),
        child: CommonSvgView(iconPath: iconPath, height: 25.w, width: 25.w, fit: BoxFit.cover),
      ),
      title: CommonTextWidget(title: title, fontFamily: "RM", fontSize: 16.sp, color: Theme.of(context).secondaryHeaderColor),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20.sp,
        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.9),
      ).paddingOnly(right: 10.sp),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(height: 1, thickness: 1.5, indent: 70, color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.05));
  }
}

void logoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).cardColor,
    isScrollControlled: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
    builder: (context) {
      return Container(
        height: 220.h,
        padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
        child: Column(
          children: [
            Container(
              height: 5.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.horizontal(right: Radius.circular(20.r), left: Radius.circular(20.r)),
              ),
            ),
            SizedBox(height: 35.h),
            CommonTextWidget(title: 'Log_Out'.tr, fontFamily: "RSB", fontSize: 18.sp, color: Theme.of(context).secondaryHeaderColor),
            SizedBox(height: 10.h),
            CommonTextWidget(
              title: 'Log_out_dialog_text'.tr,
              fontFamily: "RR",
              fontSize: 14.sp,
              color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2),
            ),
            SizedBox(height: 25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 45.h,
                    width: 140.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colors.transparent,
                      border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                    ),
                    child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 14.sp, fontFamily: "RM", color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    Preferences.isLogin = false;
                    AuthService().signOut();
                    Preferences.userEmail = '';

                    Get.offAll(() => LoginScreen());
                  },
                  child: Container(
                    height: 45.h,
                    width: 140.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: ConstColor.lightBlue,
                      border: Border.all(color: ConstColor.lightBlue),
                    ),
                    child: CommonTextWidget(title: 'Log_Out'.tr, fontSize: 14.sp, fontFamily: "RM", color: ConstColor.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
