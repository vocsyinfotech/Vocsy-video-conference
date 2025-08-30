import 'dart:math';

import 'package:intl/intl.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class ScheduleController extends GetxController {
  @override
  void onInit() {
    getScheduleMeetingData();
    super.onInit();
  }

  RxList<MeetingModel> todayList = <MeetingModel>[].obs;
  RxList<MeetingModel> meetingList = <MeetingModel>[].obs;
  DateTime now = DateTime.now();
  DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void getScheduleMeetingData({DateTime? selectedDate}) {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(selectedDate?.year ?? now.year, selectedDate?.month ?? now.month, selectedDate?.day ?? now.day, 0, 0, 0);
    final DateTime endOfDay = DateTime(selectedDate?.year ?? now.year, selectedDate?.month ?? now.month, selectedDate?.day ?? now.day, 23, 59, 59);

    print('📅 Fetching data from $startOfDay to $endOfDay');

    FirebaseFirestore.instance
        .collection('meetings')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('startTime') // Optional: to sort by time
        .snapshots()
        .listen((snapshot) {
          final dataList = snapshot.docs.map((doc) {
            return MeetingModel.fromJson(doc.data(), doc.id);
          }).toList();

          if (selectedDate == null) {
            todayList.value = dataList;
            print('📌 Today\'s Meetings: ${todayList.length}');
          } else {
            meetingList.value = dataList;
            print('📆 Selected Date Meetings: ${meetingList.length}');
          }
        });
  }

  String formatDate(int index, int i) {
    // return '${DateFormat('hh:mm a').format(meetingList[index].meetingStartTime!)} To ${DateFormat('hh:mm a').format(meetingList[index].meetingEndTime!)}';
    final item = i == 0 ? todayList[index] : meetingList[index];
    return '${DateFormat('hh:mm a').format(item.meetingStartTime!)} To ${DateFormat('hh:mm a').format(item.meetingEndTime!)}';
  }

  Color getRandomColor() {
    final Random random = Random();
    Color color;
    double brightness;

    do {
      int value = random.nextInt(0xFFFFFF);
      color = Color(0xFF000000 | value);

      // Calculate brightness using HSP model
      brightness = sqrt(0.299 * pow(color.red.toDouble(), 2) + 0.587 * pow(color.green.toDouble(), 2) + 0.114 * pow(color.blue.toDouble(), 2));
    } while (brightness < 40 || brightness > 220); // avoid black & white

    return color;
  }
}
