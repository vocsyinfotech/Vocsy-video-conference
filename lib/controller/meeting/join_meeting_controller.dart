import 'package:video_conforance/utilitis/common_import.dart';

class JoinMeetingController extends GetxController {
  var meetingIdController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  RxBool connectToAudio = RxBool(false);
  RxBool turnOffMyVideo = RxBool(false);
  RxString hintText = RxString("Meeting_Id".tr);
  var meetingId = ''.obs;
  var name = ''.obs;


  @override
  void onInit() {
    super.onInit();
    meetingIdController.value.addListener(() {
      meetingId.value = meetingIdController.value.text;
    });
    nameController.value.addListener(() {
      name.value = nameController.value.text;
    });
  }

  String setString() {
    if (hintText.value == "Meeting_Id".tr) {
      return "Join_with_personal_link".tr;
    }
    return "Join_with_meeting_ID".tr;
  }
}
