import 'package:intl/intl.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class MeetingController extends GetxController {
  @override
  void onInit() {
    fetchMeetings();
    super.onInit();
  }

  RxList<MeetingModel> meetingList = <MeetingModel>[].obs;
  RxList<Map<String, dynamic>> groupedMeetingList = <Map<String, dynamic>>[].obs;
  RxList participateList = RxList([]);

  /*void fetchMeetings() {
    FirebaseFirestore.instance.collection('meetings').ord   erBy('startTime').snapshots().listen((snapshot) {
      meetingList.value = snapshot.docs.map((doc) {
        print('${doc.data()}  to ${doc.id}  🦽🦽🦽🦽🦽🦽🦽🦽🦽🦽🦽 ');
        return MeetingModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }*/

  void fetchMeetings() {
    final now = Timestamp.fromDate(DateTime.now());

    FirebaseFirestore.instance.collection('meetings').where('endTime', isGreaterThanOrEqualTo: now).orderBy('startTime').snapshots().listen((
      snapshot,
    ) {
      final allMeetings = snapshot.docs.map((doc) {
        return MeetingModel.fromJson(doc.data(), doc.id);
      }).toList();

      meetingList.value = allMeetings;

      // Group meetings into Today, Tomorrow, Upcoming
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final Map<String, List<MeetingModel>> groupedMeetings = {"Today": [], "Tomorrow": [], "Upcoming": []};

      for (var meeting in allMeetings) {
        final start = meeting.meetingStartTime!;
        final meetingDate = DateTime(start.year, start.month, start.day);
        participateList.clear();
        for (var doc in meeting.members!) {
          fetchMeeting(doc);
        }
        if (meetingDate == today) {
          groupedMeetings["Today"]!.add(meeting);
        } else if (meetingDate == tomorrow) {
          groupedMeetings["Tomorrow"]!.add(meeting);
        } else if (meetingDate.isAfter(tomorrow)) {
          groupedMeetings["Upcoming"]!.add(meeting);
        }
      }

      // Combine into a flat list with headers
      final List<Map<String, dynamic>> sectionedList = [];

      groupedMeetings.forEach((label, meetings) {
        if (meetings.isNotEmpty) {
          sectionedList.add({"isHeader": true, "title": label});
          for (var meeting in meetings) {
            sectionedList.add({"isHeader": false, "data": meeting});
          }
        }
      });
      groupedMeetingList.value = sectionedList;
    });
  }

  String formatDate(int index) {
    // return '${DateFormat('hh:mm a').format(meetingList[index].meetingStartTime!)} To ${DateFormat('hh:mm a').format(meetingList[index].meetingEndTime!)}';
    final item = groupedMeetingList[index]['data'];
    return '${DateFormat('hh:mm a').format(item.meetingStartTime!)} To ${DateFormat('hh:mm a').format(item.meetingEndTime!)}';
  }

  Future<void> fetchMeeting(String docId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(docId).get();
    participateList.add(doc.data());
  }
}
