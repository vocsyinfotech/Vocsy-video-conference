import 'package:flutter/cupertino.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class ScheduleMeetingScreen extends StatelessWidget {
  final bool isUpdate;
  final String docId;
  ScheduleMeetingScreen({super.key, this.isUpdate = false, this.docId = ''});

  final smc = Get.put(ScheduleMeetingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(
        title: 'Schedule_Meeting'.tr,
        titleColor: Theme.of(context).secondaryHeaderColor,
        bgColor: Theme.of(context).cardColor,
        leadingWidget: Container(
          alignment: Alignment.center,
          child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 16.sp, fontFamily: "RSB", color: ConstColor.lightBlue, onTap: () => Get.back()),
        ),
        action: [
          Align(
            alignment: Alignment.center,
            child: CommonTextWidget(
              title: 'Done'.tr,
              fontSize: 16.sp,
              fontFamily: "RSB",
              color: ConstColor.lightBlue,
              onTap: () {
                smc.setMeeting(isUpdate: isUpdate, docId: docId);
              },
            ),
          ).paddingOnly(right: 15.sp),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      title: 'Meeting_Name'.tr,
                      fontFamily: "RSB",
                      fontSize: 15.sp,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CommonTextFiled(
                    controller: smc.meetingNameController.value,
                    isFiled: true,
                    isHideBorder: true,
                    filedColor: Theme.of(context).cardColor,
                    hintText: "Vocsy Designer Meetings",
                    hintStyle: TextStyle(fontSize: 15.sp, fontFamily: "RR", color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.52)),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(title: 'Date'.tr, fontFamily: 'RSB', fontSize: 15.sp, color: Theme.of(context).secondaryHeaderColor),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                smc.isShowTimePiker.value = false;
                                smc.isShowDatePiker.value = !smc.isShowDatePiker.value;
                                // showDialog(
                                //   context: context,
                                //   builder: (context) => AlertDialog(
                                //     contentPadding: EdgeInsets.zero,
                                //     content: CalendarDialog(smc: smc),
                                //   ),
                                // );
                              },
                              child: Container(
                                height: 55.w,
                                padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget(
                                      title: smc.setDateFormat(),
                                      fontFamily: "RR",
                                      fontSize: 15.sp,
                                      color: smc.selectedDate.value != null
                                          ? Theme.of(context).secondaryHeaderColor
                                          : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.52),
                                    ),
              
                                    CommonSvgView(
                                      iconPath: 'assets/icons/calender.svg',
                                      height: 20.w,
                                      width: 20.w,
                                      color: Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(title: 'Time'.tr, fontFamily: 'RSB', fontSize: 15.sp, color: Theme.of(context).secondaryHeaderColor),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                smc.isShowDatePiker.value = false;
                                smc.isShowTimePiker.value = !smc.isShowTimePiker.value;
                              },
                              child: Container(
                                height: 55.w,
                                padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                                child: Row(
                                  children: [
                                    CommonTextWidget(
                                      title: smc.setTimeFormat(),
                                      fontFamily: "RR",
                                      fontSize: 15.sp,
                                      color: smc.selectedTime.value != null
                                          ? Theme.of(context).secondaryHeaderColor
                                          : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.52),
                                    ),
                                    SizedBox(width: 8.w),
                                    CommonTextWidget(
                                      title: smc.amPm.value,
                                      fontFamily: "RM",
                                      fontSize: 15.sp,
                                      color: Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(title: 'Time_Zone'.tr, fontFamily: 'RSB', fontSize: 15.sp, color: smc.setColor(context)),
                            SizedBox(height: 10.h),
                            Container(
                              height: 55.w,
                              padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget(title: 'India', fontFamily: "RM", fontSize: 15.sp, color: smc.setColor(context)),
                                  Icon(Icons.keyboard_arrow_down_rounded, size: 28.sp, color: smc.setColor(context)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(title: 'Duration'.tr, fontFamily: 'RSB', fontSize: 15.sp, color: smc.setColor(context)),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                smc.isShowDuration.value = !smc.isShowDuration.value;
                              },
                              child: Container(
                                height: 55.w,
                                padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget(
                                      title: smc.selectedDuration.value,
                                      fontFamily: "RM",
                                      fontSize: 15.sp,
                                      color: smc.setColor(context),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_rounded, size: 28.sp, color: smc.setColor(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(title: 'Security'.tr, fontFamily: "RSB", fontSize: 15.sp, color: smc.setColor(context)),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 20.sp),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget(title: 'Use_Personal_ID'.tr, fontSize: 16.sp, fontFamily: "RM", color: smc.setColor(context)),
                                  CommonTextWidget(
                                    title: CommonVariable.personalMeetingId.value,
                                    fontSize: 16.sp,
                                    fontFamily: "RM",
                                    color: smc.setColor(context, i: 1),
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
                        ),
                        SizedBox(height: 10.h),
                        Divider(thickness: 1, color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1)),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(title: 'Passcode'.tr, fontSize: 15.sp, fontFamily: "RM", color: smc.setColor(context, i: 1)),
                            CommonTextWidget(title: smc.passcode.value, fontSize: 15.sp, fontFamily: "RM", color: smc.setColor(context, i: 1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(title: 'Meeting_Options'.tr, fontFamily: "RSB", fontSize: 15.sp, color: smc.setColor(context)),
                  ),
                  SizedBox(height: 10.h),
                  CommonContainer(
                    height: 55.h,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    containerColor: Theme.of(context).cardColor,
                    radius: 10.r,
                    onTap: () {},
                    child: CommonSwitchRow(
                      color: smc.setColor(context),
                      text: 'Host_video'.tr,
                      switchValue: smc.hostVideo.value,
                      onChanged: (value) {
                        smc.hostVideo.value = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CommonContainer(
                    height: 55.h,
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    containerColor: Theme.of(context).cardColor,
                    radius: 10.r,
                    onTap: () {},
                    child: CommonSwitchRow(
                      color: smc.setColor(context),
                      text: 'Host_Audio'.tr,
                      switchValue: smc.hostAudio.value,
                      onChanged: (value) {
                        smc.hostAudio.value = value;
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (!smc.isValidTime.value)
                    CommonTextWidget(title: 'Please select current time after 30 min', fontSize: 12.sp, color: ConstColor.red, fontFamily: "RM"),
                ],
              ),
            ),
            if (smc.isShowDatePiker.value)
              Positioned(
                top: 205.w,
                child: Container(
                  width: 330.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                  child: CalendarDialog(controller: smc),
                ),
              ),
            if (smc.isShowTimePiker.value)
              Positioned(
                top: 205.w,
                left: 190.w,
                child: Container(
                  height: 200.w,
                  width: 170.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                  child: TimeDialog(controller: smc),
                ),
              ),
            if (smc.isShowDuration.value)
              Positioned(
                top: 305.w,
                left: 210.w,
                child: Container(
                  width: 130.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 15.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(smc.durationList.length, (index) {
                        return CommonTextWidget(
                          onTap: () {
                            smc.selectedDuration.value = smc.durationList[index];
                            smc.isShowDuration.value = false;
                          },
                          title: smc.durationList[index],
                          fontSize: 15.sp,
                          fontFamily: "RM",
                          color: Theme.of(context).secondaryHeaderColor,
                        ).paddingOnly(top: index == 0 ? 0 : 15.sp);
                      }),
                    ),
                  ),
                ),
              ),
          ],
        );
      }).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }
}
