import 'package:video_conforance/utilitis/common_import.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  final sc = Get.put(ScheduleController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                SizedBox(height: _calendarFormat == CalendarFormat.week ? 10.h : 0),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        sc.getScheduleMeetingData(selectedDate: selectedDay);
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    headerVisible: _calendarFormat == CalendarFormat.month,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
                      titleTextStyle: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: "RM",
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: TextStyle(fontFamily: "RB", fontSize: 15.sp, color: Theme.of(context).secondaryHeaderColor),
                      defaultTextStyle: TextStyle(fontFamily: "RB", fontSize: 15.sp, color: Theme.of(context).secondaryHeaderColor),
                      todayTextStyle: TextStyle(fontFamily: "RB", fontSize: 15.sp, color: Theme.of(context).secondaryHeaderColor),
                      todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3)),
                      ),
                      selectedDecoration: BoxDecoration(color: ConstColor.lightBlue, shape: BoxShape.circle),
                      selectedTextStyle: TextStyle(fontFamily: "RB", fontSize: 15.sp, color: Colors.white),
                      outsideDaysVisible: false,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontFamily: "RM",
                        fontSize: 15.sp,
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                      ),
                      weekendStyle: TextStyle(
                        fontFamily: "RM",
                        fontSize: 15.sp,
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _calendarFormat == CalendarFormat.week ? 0 : 0.5,
                  duration: const Duration(milliseconds: 500),
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down, size: 28.sp, color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3)),
                    onPressed: () {
                      setState(() {
                        _calendarFormat = _calendarFormat == CalendarFormat.week ? CalendarFormat.month : CalendarFormat.week;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (sc.todayList.isNotEmpty &&
                  _selectedDay!.year == sc.now.year &&
                  _selectedDay!.month == sc.now.month &&
                  _selectedDay!.day == sc.now.day) {
                print('ENTER THE IF PART');
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
                  itemBuilder: (context, index) {
                    MeetingModel meetingData = sc.todayList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => DetailsScreen(meetingData: meetingData));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Theme.of(context).cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (meetingData.isOngoing!)
                                  Container(
                                    padding: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Theme.of(context).primaryColorDark),
                                    child: CommonTextWidget(title: 'On_Going'.tr, color: ConstColor.white, fontFamily: 'RM', fontSize: 12.sp),
                                  ),
                                if (meetingData.isOngoing!) SizedBox(width: 10.w),
                                Container(
                                  padding: EdgeInsets.all(10.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_outlined,
                                        size: 15.sp,
                                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                      ),
                                      SizedBox(width: 10.w),
                                      CommonTextWidget(
                                        title: sc.formatDate(index, 0),
                                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.more_vert_outlined, color: Theme.of(context).secondaryHeaderColor, size: 26.sp),
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
                                  color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                ),
                                CommonTextWidget(
                                  title: " ${meetingData.meetingId}",
                                  fontSize: 14.sp,
                                  fontFamily: 'RM',
                                  color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100.w,
                                  height: 36.w,
                                  child: AvatarListWidget(avatarList: meetingData.members!),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50.h,
                                    decoration: BoxDecoration(color: ConstColor.lightBlue, borderRadius: BorderRadius.circular(28.r)),
                                    child: CommonTextWidget(title: 'Join_Now'.tr, fontFamily: "RM", fontSize: 16.sp, color: ConstColor.white),
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
                  itemCount: sc.todayList.length,
                );
              } else if (sc.meetingList.isNotEmpty && _selectedDay!.day != sc.now.day) {
                print('ENTER THE ELSE IF PART');
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
                  itemBuilder: (context, index) {
                    MeetingModel meetingData = sc.meetingList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => DetailsScreen(meetingData: meetingData));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Theme.of(context).cardColor),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.sp),
                                child: Container(
                                  width: 6.w,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: sc.getRandomColor()),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonTextWidget(
                                      title: meetingData.meetingTitle.toString(),
                                      maxLines: 1,
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
                                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                        ),
                                        CommonTextWidget(
                                          title: " ${meetingData.meetingId}",
                                          fontSize: 14.sp,
                                          fontFamily: 'RM',
                                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    CommonTextWidget(
                                      title: "Time: ${sc.formatDate(index, 1)}",
                                      fontSize: 14.sp,
                                      maxLines: 1,
                                      fontFamily: 'RM',
                                      color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
                                    ),
                                    SizedBox(height: 15.h),
                                    SizedBox(
                                      width: 100.w,
                                      height: 36.w,
                                      child: AvatarListWidget(avatarList: meetingData.members!),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                height: 50.w,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://images.unsplash.com/photo-1750874595729-7db42d91f15d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMnx8fGVufDB8fHx8fA%3D%3D',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemCount: sc.meetingList.length,
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonSvgView(iconPath: 'assets/images/no_schedule_events.svg', height: 150.w, width: 150.w, fit: BoxFit.cover),
                  SizedBox(height: 10.h),
                  CommonTextWidget(title: 'No_Any_Schedule'.tr, fontSize: 16.sp, fontFamily: 'RM', color: Theme.of(context).secondaryHeaderColor),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
