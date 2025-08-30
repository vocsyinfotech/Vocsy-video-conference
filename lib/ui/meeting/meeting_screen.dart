import 'package:video_conforance/utilitis/common_import.dart';

class MeetingScreen extends StatelessWidget {
  MeetingScreen({super.key});

  final mc = Get.put(MeetingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 15.sp),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    var channelName = generatePasscode(length: 10);
                    Get.to(() => StartMeetingScreen(channelName: channelName));
                  },
                  child: Container(
                    height: 110.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.sp,
                      vertical: 10.sp,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/new_meeting.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonSvgView(
                              iconPath: 'assets/icons/video_camera.svg',
                              height: 50.w,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: commonWidth * 0.65,
                              child: CommonTextWidget(
                                title: "Start_New_Meeting".tr,
                                fontFamily: 'RSB',
                                color: ConstColor.white,
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 90.w,
                          width: 70.w,
                          child: Image.asset(
                            'assets/animation/employees.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => JoinMeetingScreen());
                        },
                        child: Container(
                          height: 110.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/join_meeting.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonSvgView(
                                iconPath: 'assets/icons/add_meeting.svg',
                                height: 45.w,
                                width: 45.w,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 5.h),
                              CommonTextWidget(
                                title: 'Join_Meeting'.tr,
                                fontFamily: 'RM',
                                fontSize: 16.sp,
                                color: ConstColor.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ScheduleMeetingScreen());

                          // Get.to(() => VideoCallScreen(channelName: "ABC"));
                        },
                        child: Container(
                          height: 110.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/schedule_meeting.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonSvgView(
                                iconPath: 'assets/icons/schedule_meeting.svg',
                                height: 45.w,
                                width: 45.w,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 5.h),
                              CommonTextWidget(
                                title: 'Schedule_Meeting'.tr,
                                fontFamily: 'RM',
                                fontSize: 16.sp,
                                color: ConstColor.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (mc.meetingList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_chats.png',
                      height: 150.w,
                      width: 150.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10.h),
                    CommonTextWidget(
                      title: 'No_Any_Meeting'.tr,
                      fontSize: 16.sp,
                      fontFamily: 'RM',
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ],
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.sp,
                  vertical: 15.sp,
                ),
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemBuilder: (context, index) {
                  final item = mc.groupedMeetingList[index];
                  if (item['isHeader'] == true) {
                    return Padding(
                      padding: EdgeInsets.zero,
                      child: CommonTextWidget(
                        title: item['title'], // Today / Tomorrow / Upcoming
                        fontSize: 14.sp,
                        fontFamily: 'RM',
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    );
                  }
                  final meetingData = item['data'] as MeetingModel;
                  return GestureDetector(
                    onTap: () async {
                      Get.to(() => DetailsScreen(meetingData: meetingData));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.sp,
                        horizontal: 15.sp,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (meetingData.isOngoing!)
                                Container(
                                  padding: EdgeInsets.all(10.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  child: CommonTextWidget(
                                    title: 'On_Going'.tr,
                                    color: ConstColor.white,
                                    fontFamily: 'RM',
                                    fontSize: 12.sp,
                                  ),
                                ),
                              if (meetingData.isOngoing!) SizedBox(width: 10.w),
                              Container(
                                padding: EdgeInsets.all(10.sp),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      size: 15.sp,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor
                                          .withValues(alpha: 0.5),
                                    ),
                                    SizedBox(width: 10.w),
                                    CommonTextWidget(
                                      title: mc.formatDate(index),
                                      color: Theme.of(context)
                                          .secondaryHeaderColor
                                          .withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.more_vert_outlined,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 26.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          CommonTextWidget(
                            title: meetingData.meetingTitle.toString(),
                            fontSize: 18.sp,
                            fontFamily: 'RB',
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              CommonTextWidget(
                                title: "Meeting_ID".tr,
                                fontSize: 14.sp,
                                fontFamily: 'RM',
                                color: Theme.of(
                                  context,
                                ).secondaryHeaderColor.withValues(alpha: 0.5),
                              ),
                              CommonTextWidget(
                                title: " ${meetingData.meetingId}",
                                fontSize: 14.sp,
                                fontFamily: 'RM',
                                color: Theme.of(
                                  context,
                                ).secondaryHeaderColor.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120.w,
                                height: 36.w,
                                child: AvatarListWidget(
                                  avatarList: meetingData.members!,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                      'CLICK JOINED WHEN CHANNEL NAME IS ${meetingData.channelName} && IS ONGOING IS ${meetingData.isOngoing}',
                                    );
                                    if (meetingData.channelName != null &&
                                        meetingData.channelName!.isNotEmpty) {
                                      Get.to(
                                        () => StartMeetingScreen(
                                          channelName:
                                              meetingData.channelName ?? '',
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: ConstColor.lightBlue,
                                      borderRadius: BorderRadius.circular(28.r),
                                    ),
                                    child: CommonTextWidget(
                                      title: 'Join_Now'.tr,
                                      fontFamily: "RM",
                                      fontSize: 16.sp,
                                      color: ConstColor.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemCount: mc.groupedMeetingList.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}
