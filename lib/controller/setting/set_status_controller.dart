import 'package:video_conforance/utilitis/common_import.dart';

class SetStatusController extends GetxController {
  @override
  void onInit() {
    getStatus();
    super.onInit();
  }

  RxInt selectedStatus = RxInt(0);
  RxInt selectedTheme = RxInt(0);
  RxBool notification = RxBool(false);
  RxInt selectedLanguage = RxInt(0);
  RxList<StatusModel> statusList = RxList([
    StatusModel(title: "Available".tr, iconPath: ""),
    StatusModel(title: "Away".tr, iconPath: "assets/icons/status_clock.svg"),
    StatusModel(title: "Busy".tr, iconPath: "assets/icons/status_close.svg"),
    StatusModel(title: "Out_of_Office".tr, iconPath: "assets/icons/status_out_of_office.svg"),
  ]);

  // GET USER STATUS
  Future<void> getStatus() async {
    var user = await AuthService().getCurrentUserData();
    selectedStatus.value = user!['status'] ?? 0;
    notification.value = user['isShowNotification'] ?? false;
    Preferences.isShowNotification = user['isShowNotification'] ?? false;
    print('STATUS OF USER :: ${selectedStatus.value} &&& ${notification.value}');
  }

  // UPDATE STATUS
  void updateStatus() {
    AuthService().setStatus(status: selectedStatus.value);
  }

  void updateNotificationStatus() {
    AuthService().setKeyValue(key: 'isShowNotification', value: notification.value);
    Preferences.isShowNotification = notification.value;
    print('NOTIFICATION STATUS IS FOLLOWING  -  ${Preferences.isShowNotification}');
  }
}

class StatusModel {
  String? title;
  String? iconPath;
  StatusModel({this.title, this.iconPath});
}
