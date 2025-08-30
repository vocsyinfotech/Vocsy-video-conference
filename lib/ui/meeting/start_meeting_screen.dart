import 'package:flutter/cupertino.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class StartMeetingScreen extends StatelessWidget {
  final String channelName;
  StartMeetingScreen({super.key,required this.channelName});

  final smc = Get.put(StartMeetingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: commonAppBar(
          title: 'Start_meeting'.tr,
          titleColor: Theme.of(context).secondaryHeaderColor,
          bgColor: Theme.of(context).cardColor,
          leadingWidget: Container(
            alignment: Alignment.center,
            child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 16.sp, fontFamily: "RSB", color: ConstColor.lightBlue, onTap: () => Get.back()),
          ),
          action: [],
        ),
        body: Column(
          children: [
            SizedBox(height: 10.h),
            CommonSwitchRow(
              text: 'Video_Connect'.tr,
              switchValue: smc.videoConnect.value,
              onChanged: (value) {
                smc.videoConnect.value = value;
              },
            ),
            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(title: 'Audio Connect'.tr, fontSize: 16.sp, fontFamily: "RM", color: Theme.of(context).secondaryHeaderColor),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: smc.audioConnect.value,
                  onChanged: (value) {
                    smc.audioConnect.value = value;
                  },
                ),
              ],
            ),
           /* Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(title: 'Use_Personal_ID'.tr, fontSize: 16.sp, fontFamily: "RM", color: Theme.of(context).secondaryHeaderColor),
                      CommonTextWidget(
                        title: '240 587 6365 ',
                        fontSize: 16.sp,
                        fontFamily: "RM",
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: smc.usePersonalMeetingID.value,
                  onChanged: (value) {
                    smc.usePersonalMeetingID.value = value;
                  },
                ),
              ],
            ),*/
            SizedBox(height: 30.h),
            CommonButton(title: 'Start_meeting'.tr, textSize: 18.sp, titleColor: ConstColor.white, buttonColor: ConstColor.lightBlue, onTap: () async {
              Get.to(() => VideoCallScreen(channelName: channelName,videoOff: smc.videoConnect.value,audioOff: smc.audioConnect.value,));
            }),
          ],
        ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
      );
    });
  }
}
