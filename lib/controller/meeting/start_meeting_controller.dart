import 'package:video_conforance/utilitis/common_import.dart';

class StartMeetingController extends GetxController {
  RxBool videoConnect = RxBool(true);
  RxBool audioConnect = RxBool(true);
  RxBool usePersonalMeetingID = RxBool(false);
}
