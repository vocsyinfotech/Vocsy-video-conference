import 'package:intl/intl.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class ScheduleMeetingController extends GetxController {
  @override
  void onInit() {
    addCurrentTime();
    super.onInit();
  }

  var meetingNameController = TextEditingController().obs;
  RxBool usePersonalMeetingID = RxBool(false);
  RxBool hostVideo = RxBool(false);
  RxBool hostAudio = RxBool(false);
  RxBool isShowDatePiker = RxBool(false);
  RxBool isShowTimePiker = RxBool(false);
  RxBool isShowDuration = RxBool(false);
  Rxn<DateTime> selectedDate = Rxn<DateTime>(DateTime.now());
  RxString selectedDateString = RxString("DD/MM/YYYY");
  RxString amPm = RxString("PM");
  RxString passcode = RxString("");
  Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();
  RxString selectedTimeString = RxString("HH/MM");
  RxList durationList = RxList(['30 Minutes', '45 Minutes', '1 Hours', '2 Hours', '3 Hours', '4 Hours']);
  RxString selectedDuration = RxString('30 Minutes');
  RxBool isValidTime = RxBool(false);

  String setDateFormat() {
    if (selectedDate.value != null) {
      selectedDateString.value = DateFormat('dd/MM/yyyy').format(selectedDate.value!);
      return selectedDateString.value;
    }
    return selectedDateString.value;
  }

  String setTimeFormat() {
    if (selectedTime.value != null) {
      final time = selectedTime.value!;
      final hour = time.hourOfPeriod.toString().padLeft(2, '0'); // 1-12
      final minute = time.minute.toString().padLeft(2, '0');
      amPm.value = time.period == DayPeriod.am ? "AM" : "PM";

      selectedTimeString.value = "$hour/$minute";
      return selectedTimeString.value;
    }
    return selectedTimeString.value;
  }

  Color setColor(BuildContext context, {int i = 0}) {
    if (isShowDatePiker.value || isShowTimePiker.value) {
      return Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2);
    }
    return i == 1 ? Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.4) : Theme.of(context).secondaryHeaderColor;
  }

  // SCHEDULE MEETING
  void setMeeting({bool isUpdate = false, String docId = ''}) {
    var mName = meetingNameController.value.text;
    var startTime;
    var endTime;
    if (selectedDate.value != null && selectedTime.value != null) {
      startTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );
      endTime = getDuration(startTime);
    }
    if (mName.isEmpty) {
      customSnackBar('Alert', 'Enter meeting name');
    } else if (selectedDate.value == null && selectedTime.value == null) {
      customSnackBar('Alert', 'Please select date & time');
    } else {
      if (isUpdate && docId.isNotEmpty) {
        AuthService().updateMeeting(documentId: docId, name: mName, startDate: startTime, endDate: endTime, duration: selectedDuration.value).then((
          v,
        ) {
          customSnackBar('Success', 'Schedule Meeting successfully');
        });
        Get.back();
      } else {
        AuthService()
            .scheduleMeeting(
              ownerName: CommonVariable.userName.value,
              duration: selectedDuration.value,
              name: mName,
              meetingID: generateMeetingId(),
              startDate: startTime,
              endDate: endTime,
              passcode: passcode.value,
            )
            .then((v) {
              customSnackBar('Success', 'Schedule Meeting successfully');
            });
        Get.back();
      }
    }
  }

  DateTime getDuration(DateTime startTime) {
    if (selectedDuration.value.contains('Minutes')) {
      int duration = int.parse(selectedDuration.value.split(' ').first.toString());
      print('🌙🌙🌙🌙🌙 $duration');
      return startTime.add(Duration(minutes: duration));
    } else {
      int duration = int.parse(selectedDuration.value.split(' ').first.toString());
      return startTime.add(Duration(hours: duration));
    }
  }

  // ADD 30 MIN CURRENT TIME
  void addCurrentTime() {
    // GENERATE PASS CODE
    passcode.value = generatePasscode();
    // ADD 30 MIN IN CURRENT TIME
    TimeOfDay now = TimeOfDay.now();
    DateTime nowDateTime = DateTime(0, 1, 1, now.hour, now.minute);
    DateTime newDateTime = nowDateTime.add(Duration(minutes: 30));
    selectedTime.value = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
  }
}
