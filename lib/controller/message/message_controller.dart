import 'package:video_conforance/utilitis/common_import.dart';

class MessageController extends GetxController {
  RxList<UserModel> userList = RxList([]);
  RxList<ChatGroupRoom> groupChatUser = RxList([]);
  RxList<ChatRoom> lastMessageList = RxList([]);
  RxBool isUnread = RxBool(false);
  RxString msg = RxString("");
  RxString time = RxString("");
  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  // GTE USER DATA
  void getUserData() async {
    print('ENTER 001');
    MessageService().getUsersWhoMessagedMeStream().listen((user) {
      userList.value = user;
    });
    MessageService().getChatGroupList().listen((user) {
      groupChatUser.value = user;
    });
  }
}

class MessageListModel {
  String? name;
  String? imageUrl;
  String? time;
  String? lastMessage;
  bool? isOnline;

  MessageListModel({this.name, this.imageUrl, this.lastMessage, this.time, this.isOnline});
}
