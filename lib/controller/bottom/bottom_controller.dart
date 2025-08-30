import 'package:video_conforance/utilitis/common_import.dart';

class BottomController extends GetxController {
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        getUserData();
    });
    super.onInit();
  }

  final RxInt currentIndex = RxInt(0);
  RxBool isLoading = RxBool(false);

  final List<Widget> pageList = [
    MeetingScreen(),
    ScheduleScreen(),
    MessageScreen(),
    SettingsScreen(),
  ];

  // SET APPBAR TITLE TEXT
  String showAppBarTitleText() {
    if (currentIndex.value == 3) {
      return "Settings".tr;
    } else if (currentIndex.value == 1) {
      return "Calendar".tr;
    } else if (currentIndex.value == 2) {
      return "Message".tr;
    }
    return "Weboxcam".tr;
  }

  // GET CURRENT USER DATA

  Future<void> getUserData() async {
    isLoading.value = true;
    showLoadingDialog(Get.context!);

    var user = await AuthService().getCurrentUserData();
    if (user != null) {
      print('${user['username']}');
      Preferences.userName = user['username'] ?? '';
      CommonVariable.userName.value = user['username'] ?? '';
      CommonVariable.userEmail.value = user['email'] ?? '';
      CommonVariable.userMobile.value = user['mobile'] ?? '';
      CommonVariable.userLocation.value = user['location'] ?? '';
      CommonVariable.userJobTile.value = user['jobTitle'] ?? '';
      CommonVariable.personalMeetingId.value = user['personalMeetingID'] ?? '';
      CommonVariable.userImage.value = user['image'] ?? '';
      print('USER NAME :::-- ${Preferences.userName}');
      print('OOOOOOOOO00000000000000000');
      AuthService().updateActiveStatus(true);
    }
    isLoading.value = false;
    Get.back();
  }
}
