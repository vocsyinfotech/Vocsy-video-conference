import 'package:video_conforance/utilitis/common_import.dart';

class JoinMeetingScreen extends StatelessWidget {
  JoinMeetingScreen({super.key});

  final jmc = Get.put(JoinMeetingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: commonAppBar(
          title: 'Join_meeting'.tr,
          titleColor: Theme.of(context).secondaryHeaderColor,
          bgColor: Theme.of(context).cardColor,
          leadingWidget: Container(
            alignment: Alignment.center,
            child: CommonTextWidget(
              title: 'Cancel'.tr,
              fontSize: 16.sp,
              fontFamily: "RSB",
              color: ConstColor.lightBlue,
              onTap: () => Get.back(),
            ),
          ),
          action: [],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              TextField(
                controller: jmc.meetingIdController.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "RSB",
                  fontSize: 16.sp,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  hintText: jmc.hintText.value,
                  hintStyle: TextStyle(
                    fontFamily: "RSB",
                    fontSize: 16.sp,
                    color: Theme.of(
                      context,
                    ).secondaryHeaderColor.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              CommonTextWidget(
                title: jmc.setString(),
                fontSize: 16.sp,
                fontFamily: "RR",
                color: ConstColor.lightBlue,
                onTap: () {
                  if (jmc.hintText.value == "Meeting_Id".tr) {
                    jmc.hintText.value = "Personal_Link".tr;
                  } else {
                    jmc.hintText.value = "Meeting_Id".tr;
                  }
                },
              ),
              SizedBox(height: 15.h),
              CommonTextWidget(
                title: 'Enter_the_URL'.tr,
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                maxLines: 2,
                fontFamily: "RR",
                color: Theme.of(
                  context,
                ).secondaryHeaderColor.withValues(alpha: 0.5),
              ).paddingOnly(left: 15.sp, right: 15.sp),
              SizedBox(height: 50.h),
              TextField(
                controller: jmc.nameController.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "RSB",
                  fontSize: 16.sp,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  hintText: "Add_Name".tr,
                  hintStyle: TextStyle(
                    fontFamily: "RSB",
                    fontSize: 16.sp,
                    color: Theme.of(
                      context,
                    ).secondaryHeaderColor.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() {
                final isEnabled =
                    jmc.meetingId.isNotEmpty && jmc.name.isNotEmpty;
                return GestureDetector(
                  child: CommonContainer(
                    height: 60.h,
                    containerColor: isEnabled
                        ? ConstColor.lightBlue
                        : ConstColor.lightBlue.withValues(alpha: 0.5),
                    child: CommonTextWidget(
                      title: 'Join'.tr,
                      fontFamily: "RSB",
                      fontSize: 18.sp,
                      color: isEnabled
                          ? ConstColor.white
                          : ConstColor.white.withValues(alpha: 0.5),
                    ),
                    onTap: () {
                      if (isEnabled) {
                        Get.to(
                          () => VideoCallScreen(
                            channelName: jmc.meetingIdController.value.text,
                            videoOff: jmc.turnOffMyVideo.value,
                            audioOff: jmc.connectToAudio.value,
                          ),
                        );
                      }
                    },
                  ),
                );
              }),
              SizedBox(height: 10.h),
              CommonTextWidget(
                title: 'Invitation_link'.tr,
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                fontFamily: "RR",
                maxLines: 2,
                color: Theme.of(
                  context,
                ).secondaryHeaderColor.withValues(alpha: 0.5),
              ),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CommonTextWidget(
                  title: 'Join_Option'.tr,
                  fontSize: 14.sp,
                  fontFamily: "RSB",
                  color: Theme.of(
                    context,
                  ).secondaryHeaderColor.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: 10.h),
              CommonSwitchRow(
                text: jmc.connectToAudio.value
                    ? 'Connect_to_audio'.tr
                    : 'Don’t_Connect_to_audio'.tr,
                fontSize: 15.sp,
                fontFamily: "RM",
                switchValue: jmc.connectToAudio.value,
                onChanged: (value) {
                  jmc.connectToAudio.value = value;
                },
              ),
              SizedBox(height: 8.h),
              CommonSwitchRow(
                text: jmc.turnOffMyVideo.value
                    ? 'Turn_on_my_video'.tr
                    : 'Turn_off_my_video'.tr,
                fontSize: 15.sp,
                fontFamily: "RM",
                switchValue: jmc.turnOffMyVideo.value,
                onChanged: (value) {
                  jmc.turnOffMyVideo.value = value;
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 20.sp, vertical: 20.sp),
        ),
      );
    });
  }
}
