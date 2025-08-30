import 'dart:convert';

import 'package:video_conforance/utilitis/common_import.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final pc = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'My_Profile'.tr,
        titleColor: Theme.of(context).secondaryHeaderColor,
        bgColor: Theme.of(context).cardColor,
        isLeadingWidgetIcon: true,
        leadingWidget: GestureDetector(
          onTap: () {
            pc.back();
          },
          child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: sHeaderColor),
        ),
        action: [
          GestureDetector(
            onTap: () async {
              await pc.setOtherData().then((v) {
                // print('CCCCC $v');
                if (v == 1) {
                  customSnackBar('Success', 'Profile updated successfully');
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              child: Icon(Icons.check_rounded, color: sHeaderColor, size: 28.sp),
            ).paddingOnly(right: 15.sp),
          ),
        ],
      ),
      body: Obx(() {
        Uint8List bytes = base64Decode(pc.imageBase64.value);
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 65.r,
                    backgroundColor: ConstColor.lightBlue,
                    backgroundImage: (bytes != null && bytes.isNotEmpty) ? MemoryImage(bytes) : null,
                    child: (pc.imageBase64 == null || bytes.isEmpty)
                        ? CommonTextWidget(
                            title: getUserInitials(CommonVariable.userName.value),
                            fontFamily: "RSB",
                            fontSize: 16.sp,
                            color: ConstColor.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: CommonSvgView(
                      iconPath: 'assets/icons/profile_camera.svg',
                      height: 30.w,
                      width: 30.w,
                      fit: BoxFit.cover,
                      onTap: () {
                        pc.addImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            CommonTextWidget(title: CommonVariable.userEmail.value, fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor.withValues(alpha: 0.3)),
            SizedBox(height: 15.h),
            Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), height: 0),
            SizedBox(height: 30.h),
            Obx(() {
              return _buildContain(
                context,
                'Display_Name'.tr,
                CommonVariable.userName.value == pc.fullName.value ? CommonVariable.userName.value : pc.fullName.value,
                true,
                () {
                  Get.to(() => DisplayNameScreen());
                },
              );
            }),
            Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), height: 30.h),
            _buildContain(
              context,
              'Phone_Number'.tr,
              CommonVariable.userMobile.value == pc.mobile.value ? CommonVariable.userMobile.value : pc.mobile.value,
              CommonVariable.userMobile.value.isEmpty && pc.mobile.value.isEmpty ? false : true,
              () {
                Get.to(() => PhoneNumberScreen());
              },
            ),
            // Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), height: 30.h),
            // _buildContain(context, 'Location'.tr, '', false, () {
            //   Get.to(() => LocationScreen());
            // }),
            Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), height: 30.h),
            _buildContain(
              context,
              'Job_Title'.tr,
              CommonVariable.userJobTile.value == pc.jobTitle.value ? CommonVariable.userJobTile.value : pc.jobTitle.value,
              CommonVariable.userJobTile.value.isEmpty && pc.jobTitle.value.isEmpty ? false : true,
              () {
                Get.to(() => JobTitleScreen());
              },
            ),
            Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), height: 30.h),
            _buildContain(context, 'Update_Password'.tr, '', true, () {
              Get.to(() => ChangePasswordScreen());
            }),
          ],
        );
      }).paddingSymmetric(vertical: 15.sp, horizontal: 20.sp),
    );
  }

  Widget _buildContain(BuildContext context, String title, String value, bool isSet, VoidCallback onTap) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: commonWidth * 0.5,
            child: CommonTextWidget(title: title, fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor),
          ),
          SizedBox(
            width: isSet ? 120.w : 85.w,
            child: Row(
              children: [
                Expanded(
                  child: CommonTextWidget(
                    fontFamily: "RM",
                    title: isSet ? value : "Not_Set".tr,
                    textAlign: TextAlign.right,
                    fontSize: 15.sp,
                    color: sHeaderColor.withValues(alpha: 0.5),
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(Icons.arrow_forward_ios_rounded, size: 15.sp, color: sHeaderColor.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
