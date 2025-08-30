import 'package:video_conforance/utilitis/common_import.dart';

class DetailsScreen extends StatelessWidget {
  final MeetingModel meetingData;
  DetailsScreen({super.key, required this.meetingData});

  final dc = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dc.listenToMeeting(meetingData.meetingId.toString());
    });
    var isPast = dc.checkDateIsPast(meetingData.meetingEndTime!);
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    print('Data is :: ${meetingData.createdBy}');
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close_rounded, color: sHeaderColor, size: 28.sp),
                  ),
                  if (MessageService().currentUserId == meetingData.createdBy)
                    GestureDetector(
                      onTapDown: (details) {
                        final tapPosition = details.globalPosition;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(tapPosition.dx, 100.h, 15.w, tapPosition.dy),
                          items: [
                            PopupMenuItem(
                              onTap: () {
                                if (!isPast) {
                                  var ctr = Get.put(ScheduleMeetingController());
                                  ctr.meetingNameController.value.text = meetingData.meetingTitle.toString();
                                  ctr.selectedTime.value = TimeOfDay(
                                    hour: meetingData.meetingStartTime!.hour,
                                    minute: meetingData.meetingStartTime!.minute,
                                  );
                                  ctr.selectedDate.value = DateTime(
                                    meetingData.meetingStartTime!.year,
                                    meetingData.meetingStartTime!.month,
                                    meetingData.meetingStartTime!.day,
                                  );
                                  ctr.selectedDuration.value = meetingData.duration.toString();
                                  ctr.passcode.value = meetingData.passcode.toString();
                                  Get.back();
                                  Get.to(() => ScheduleMeetingScreen(docId: meetingData.documentId.toString(), isUpdate: true));
                                }
                              },
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20.sp, color: sHeaderColor),
                                  SizedBox(width: 10.w),
                                  CommonTextWidget(title: "Edit".tr, fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.r), // Change radius as needed
                                      ),
                                      backgroundColor: cardColor,
                                      contentPadding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CommonTextWidget(
                                            title: 'Remove_Scheduled_Meeting'.tr,
                                            fontSize: 16.sp,
                                            fontFamily: "RB",
                                            color: sHeaderColor,
                                          ),
                                          SizedBox(height: 3.h),
                                          CommonTextWidget(
                                            textAlign: TextAlign.center,
                                            title: 'Delete_scheduled_meeting_dialog_text'.tr,
                                            fontSize: 14.sp,
                                            maxLines: 2,
                                            fontFamily: "RR",
                                            color: sHeaderColor.withValues(alpha: 0.5),
                                          ),
                                          SizedBox(height: 25.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => Get.back(),
                                                  child: Container(
                                                    height: 45.h,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                      color: Colors.transparent,
                                                      border: Border.all(color: sHeaderColor.withValues(alpha: 0.5)),
                                                    ),
                                                    child: CommonTextWidget(
                                                      title: 'Cancel'.tr,
                                                      color: sHeaderColor,
                                                      fontFamily: "RSB",
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15.w),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    AuthService().deleteMeeting(meetingData.documentId.toString());
                                                    var docId = 'group_${MessageService().currentUserId}';
                                                    MessageService().removeMember(docId);
                                                    Get.back(); //close dialog
                                                    Get.back(); // back to meeting screen
                                                    customSnackBar('Success', 'Remove meeting successfully');
                                                  },
                                                  child: Container(
                                                    height: 45.h,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                      color: ConstColor.red,
                                                      border: Border.all(color: ConstColor.red),
                                                    ),
                                                    child: CommonTextWidget(
                                                      title: 'Remove'.tr,
                                                      color: ConstColor.white,
                                                      fontFamily: "RSB",
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20.sp, color: sHeaderColor),
                                  SizedBox(width: 10.w),
                                  CommonTextWidget(title: "Delete".tr, fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      child: Icon(Icons.more_vert, color: sHeaderColor, size: 28.sp),
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: CommonTextWidget(
                      title: meetingData.meetingTitle.toString(),
                      maxLines: 2,
                      fontFamily: "RB",
                      fontSize: 28.sp,
                      color: sHeaderColor,
                    ),
                  ),
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2024/03/16/20/35/ai-generated-8637800_640.jpg'),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              CommonTextWidget(
                title: dc.formatTime(meetingData.meetingStartTime!, 0),
                fontFamily: "RM",
                fontSize: 15.sp,
                color: sHeaderColor.withValues(alpha: 0.5),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: customStack(context, 'assets/images/start.svg', 'Start'.tr, dc.formatTime(meetingData.meetingStartTime!, 1))),
                  SizedBox(width: 12.w),
                  Expanded(child: customStack(context, 'assets/images/duration.svg', 'Duration'.tr, dc.formatDurationString(meetingData.duration.toString()))),
                  SizedBox(width: 12.w),
                  Expanded(child: customStack(context, 'assets/images/owner.svg', 'Owner'.tr, '${meetingData.owner}')),
                ],
              ),
              SizedBox(height: 10.h),
              Divider(thickness: 1, color: sHeaderColor.withValues(alpha: 0.1)),
              SizedBox(height: 10.h),
              CommonContainer(
                onTap: () {},
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                containerColor: cardColor,
                radius: 10,
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CommonTextWidget(title: 'Meeting_ID'.tr, fontSize: 16.sp, fontFamily: "RSB", color: sHeaderColor),
                        SizedBox(width: 5.w),
                        CommonTextWidget(title: meetingData.meetingId.toString(), fontSize: 16.sp, fontFamily: "RSB", color: sHeaderColor),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        copyText(meetingData.meetingId.toString());
                      },
                      icon: Icon(Icons.copy_rounded, size: 30.sp, color: sHeaderColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13.h),
              CommonContainer(
                onTap: () {},
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                containerColor: cardColor,
                radius: 10,
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CommonTextWidget(title: 'Passcode:'.tr, fontSize: 16.sp, fontFamily: "RSB", color: sHeaderColor),
                        SizedBox(width: 5.w),
                        CommonTextWidget(title: meetingData.passcode.toString(), fontSize: 16.sp, fontFamily: "RSB", color: sHeaderColor),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        copyText(meetingData.passcode.toString());
                      },
                      icon: Icon(Icons.copy_rounded, size: 30.sp, color: sHeaderColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 15.sp),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: cardColor),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTextWidget(title: 'Link:'.tr, fontSize: 16.sp, fontFamily: "RSB", color: sHeaderColor),
                        IconButton(
                          onPressed: () {
                            copyText(dc.link.value);
                          },
                          icon: Icon(Icons.copy_rounded, size: 30.sp, color: sHeaderColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    CommonTextWidget(title: dc.link.value, fontSize: 16.sp, fontFamily: "RR", maxLines: 100, color: ConstColor.lightBlue),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  CommonTextWidget(title: "Members".tr, fontSize: 16.sp, fontFamily: "RB", color: sHeaderColor),
                  CommonTextWidget(title: " (${dc.participateList.length})", fontSize: 16.sp, fontFamily: "RB", color: sHeaderColor),
                ],
              ),
              if (dc.participateList.isEmpty) ConstShimmer.fetchMember(height: 30.h, width: commonWidth, radius: 0),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Uint8List? bytes = dc.participateList[index].image == null ? null : base64Decode(dc.participateList[index].image.toString());
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: Colors.blueAccent,
                            backgroundImage: (bytes != null && bytes.isNotEmpty) ? MemoryImage(bytes) : null,
                            child: (bytes == null || bytes.isEmpty)
                                ? CommonTextWidget(
                                    title: dc.participateList[index].username.toString().substring(0, 2).toUpperCase(),
                                    fontFamily: "RSB",
                                    fontSize: 16.sp,
                                    color: ConstColor.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: 15.w),
                          CommonTextWidget(
                            title: dc.getLabeledUsername(dc.participateList[index], meetingData.createdBy.toString()),
                            fontFamily: "RSB",
                            fontSize: 16.sp,
                            color: sHeaderColor,
                          ),
                        ],
                      ),
                      dc.participateList[index].username != CommonVariable.userName.value
                          ? GestureDetector(
                              onTap: () => Get.to(() => MessageDetailsScreen(userData: dc.participateList[index])),
                              child: CommonSvgView(
                                iconPath: 'assets/icons/chat_message.svg',
                                fit: BoxFit.cover,
                                height: 28.h,
                                color: sHeaderColor.withValues(alpha: 0.45),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.05)),
                itemCount: dc.isShowMore.value
                    ? dc.participateList.length
                    : dc.participateList.length >= 2
                    ? 2
                    : dc.participateList.length,
              ),
              // SizedBox(height: 10.h),
              Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.05)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonTextWidget(title: 'Show_More'.tr, fontSize: 14.sp, fontFamily: "RSB", color: sHeaderColor),
                  SizedBox(width: 5.w),
                  AnimatedRotation(
                    turns: dc.isShowMore.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28.sp, color: sHeaderColor),
                      onPressed: () {
                        dc.isShowMore.value = !dc.isShowMore.value;
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
              if (FirebaseAuth.instance.currentUser!.uid == meetingData.createdBy)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(title: "Invite_To_mail".tr, fontFamily: "RSB", fontSize: 16.sp, color: sHeaderColor),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60.h,
                            // padding: EdgeInsets.symmetric(vertical: 10.sp),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
                              color: Colors.transparent,
                              border: Border.all(color: sHeaderColor.withValues(alpha: 0.2)),
                            ),
                            child: CommonTextFiled(
                              controller: dc.mailController.value,
                              isHideBorder: true,
                              hintText: 'eg. alex@gmail.com',
                              hintStyle: TextStyle(fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor.withValues(alpha: 0.2)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            dc.invitation(isPast, meetingData.meetingId.toString());
                          },
                          child: Container(
                            height: 60.h,
                            width: 110.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                              color: isPast ? sHeaderColor.withValues(alpha: 0.5) : sHeaderColor,
                              border: Border.all(color: isPast ? sHeaderColor.withValues(alpha: 0.3) : sHeaderColor),
                            ),
                            child: CommonTextWidget(
                              title: 'Invite'.tr,
                              fontFamily: "RSB",
                              fontSize: 18.sp,
                              color: isPast ? cardColor.withValues(alpha: 0.5) : cardColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(() => MessageDetailsScreen(userData: userData));
                      },
                      child: Container(
                        height: 55.h,
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: isPast ? sHeaderColor.withValues(alpha: 0.5) : sHeaderColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              child: CommonSvgView(
                                iconPath: 'assets/icons/chat_message.svg',
                                fit: BoxFit.cover,
                                height: 28.h,
                                color: isPast ? cardColor.withValues(alpha: 0.25) : cardColor.withValues(alpha: 0.45),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            CommonTextWidget(
                              title: 'Chat'.tr,
                              fontSize: 18.sp,
                              fontFamily: "RSB",
                              color: isPast ? cardColor.withValues(alpha: 0.5) : cardColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      child: Container(
                        height: 55.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: isPast ? ConstColor.lightBlue.withValues(alpha: 0.5) : ConstColor.lightBlue,
                        ),
                        child: CommonTextWidget(
                          title: FirebaseAuth.instance.currentUser!.uid == meetingData.createdBy ? 'Start_meeting'.tr : 'Join Meeting'.tr,
                          fontFamily: "RSB",
                          fontSize: 18.sp,
                          color: isPast ? ConstColor.white.withValues(alpha: 0.5) : ConstColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }).paddingSymmetric(horizontal: 15.sp, vertical: 15.sp),
      ),
    );
  }

  Widget customStack(BuildContext context, String path, String title, String time) {
    return Stack(
      children: [
        CommonSvgView(iconPath: path, height: 65.h, fit: BoxFit.cover),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextWidget(title: title, fontFamily: "RM", fontSize: 12.sp, color: Colors.black),
            CommonTextWidget(title: time, fontFamily: "RB", fontSize: 14.sp, color: Colors.black,),
          ],
        ).paddingSymmetric(vertical: 15.sp, horizontal: 13.sp),
      ],
    );
  }
}
