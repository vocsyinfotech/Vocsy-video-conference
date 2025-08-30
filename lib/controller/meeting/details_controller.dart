import 'package:intl/intl.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class DetailsController extends GetxController {
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  RxBool isShowMore = RxBool(false);
  var mailController = TextEditingController().obs;
  RxList<UserModel> participateList = RxList([]);
  RxString link = RxString('');
  RxString meetingId = RxString('');
  Rx<MeetingModel> data = MeetingModel().obs;

  // GET PARTICIPATE DATA
  // Future<void> fetchMeeting(String docId) async {
  //   participateList.clear();
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(docId).get();
  //   participateList.add(doc.data());
  // }

  // GET PARTICIPATE DATA
  void listenToMeeting(String meetingId) {
    // showLoadingDialog(Get.context!);
    createDynamicLinks(meetingId);
    FirebaseFirestore.instance.collection('meetings').where('meetingID', isEqualTo: meetingId).limit(1).snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        final meeting = MeetingModel.fromJson(data, doc.id);

        fetchMeetingData(meeting);
      }

      // Get.back();
    });
  }

  Future<void> fetchMeetingData(MeetingModel data) async {
    participateList.clear();
    if (data.members == null || data.members!.isEmpty) {
      print('❌ No members found');
      return;
    }
    // try {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    UserModel? hostUser;
    UserModel? currentUser;
    List<UserModel> otherUsers = [];
    for (String uid in data.members!) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = UserModel.fromJson(doc.data()!, doc.id);

      if (uid == data.documentId) {
        hostUser = userData;
      } else if (uid == currentUserId) {
        currentUser = userData;
      } else {
        otherUsers.add(userData);
      }
    }

    if (hostUser != null) {
      participateList.add(hostUser); // Add host first
    }

    if (currentUser != null && currentUser.documentId != data.documentId) {
      participateList.add(currentUser); // Add current user second if not host
    }

    participateList.addAll(otherUsers); // Add remaining users
    // } catch (e) {
    //   print('❌ Error fetching user data: $e');
    // }
  }

  String formatTime(DateTime startTime, int i) {
    if (i == 0) {
      return DateFormat('EEEE, MMMM d, yyyy').format(startTime);
    } else {
      return DateFormat('hh:mm a').format(startTime);
    }
  }

  String formatDurationString(String input) {
    input = input.trim().toLowerCase();

    if (input.contains('minute')) {
      final number = RegExp(r'\d+').stringMatch(input);
      return '${number ?? ''} Min';
    } else if (input.contains('hour')) {
      final number = RegExp(r'\d+').stringMatch(input);
      return '${number ?? ''} Hr';
    } else {
      return input; // fallback if unrecognized format
    }
  }

  bool checkDateIsPast(DateTime date) {
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime selectedDate = DateTime(date.year, date.month, date.day);

    print('🕓 TODAY: $today, SELECTED: $selectedDate');

    // Return true if the selected date is before today
    return selectedDate.isBefore(today);
  }

  // TAP OF INVITATION
  void invitation(bool isPast, String meetingId) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (mailController.value.text.isEmpty) {
      customSnackBar('Error', 'Please enter email address');
    } else if (!regex.hasMatch(mailController.value.text)) {
      customSnackBar('Error', 'Enter a valid email address');
    } else {
      if (!isPast) {
        sendInviteEmail(recipientEmail: mailController.value.text, meetingId: meetingId);
        customSnackBar('Success', 'Send invitation successfully to ${mailController.value.text} && $meetingId');
        mailController.value.clear();
      }
    }
  }

  Future<void> createDynamicLinks(String meetingId) async {
    print('CREATED IS THE ${FirebaseAuth.instance.currentUser!.uid}');

    link.value = await createDynamicLink(meetingId: meetingId, action: 'accept', docId: FirebaseAuth.instance.currentUser!.uid);
    print('Link is following ::: ${link.value}');
  }

  // SET PROPER TEXT
  String getLabeledUsername(UserModel participant, String hostId) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    /*if (participant.documentId == currentUserId && participant.documentId == hostId) {
      return '${participant.username} (Host, You)';
    } else*/
    if (participant.documentId == currentUserId) {
      return '${participant.username} (You)';
    } else if (participant.documentId == hostId) {
      return '${participant.username} (Host)';
    } else {
      return participant.username ?? '';
    }
  }
}

/*for (String uid in data.members!) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        final userData = doc.data() as Map<String, dynamic>?;
        if (userData != null) {
          participateList.add(userData);
        }
      }*/
