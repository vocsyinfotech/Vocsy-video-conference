import 'package:intl/intl.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class MeetingChatSheetController extends GetxController {
  RxBool isGroupSelectionMode = RxBool(false);
  RxBool isSelectionMode = RxBool(false);
  var chatBotController = TextEditingController().obs;
  var groupChatBotController = TextEditingController().obs;
  RxList<String> pikeImageList = RxList([]);
  RxList<String> pikeImageGroupList = RxList([]);
  RxList<String> selectedGroupMessageIds = RxList([]);
  RxList<String> deleteGroupMessageIds = RxList([]);
  RxList<String> deleteMessageIds = RxList([]);
  List<String> selectedMessageIds = RxList([]);
  RxString reactingMessageId = RxString('');

  // SEND MESSAGE
  Future<void> sendMessageTo({required UserModel chatUser, required dynamic messageText, required MessageType type}) async {
    if (messageText.isNotEmpty) {
      chatBotController.value.text = '';
      final roomId = MessageService().generatePrivateRoomId(MessageService().currentUserId, chatUser.documentId.toString());
      MessageService().closeTypingStatus(userId: MessageService().currentUserId, roomId: roomId);
      await MessageService().sendMessage(chatUser: chatUser, messageText: messageText, type: type, receiverId: chatUser.documentId.toString());
    } else {
      print('chat boot is empty');
    }
  }

  // FORMAT DATE
  String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final yesterday = DateUtils.dateOnly(now.subtract(Duration(days: 1)));
    final msgDate = DateUtils.dateOnly(date);

    if (msgDate == today) return 'Today';
    if (msgDate == yesterday) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  // PIKE THE MULTIPLE IMAGE

  Future<void> pikeMultipleIma({int i = 0}) async {
    if (i == 0) {
      pikeImageList.value = (await pickMultipleImage())!;
    } else {
      pikeImageGroupList.value = (await pickMultipleImage())!;
    }
  }

  // ADD MULTIPLE IMAGE
  void sendImage(UserModel chatUser) {
    for (var image in pikeImageList) {
      sendMessageTo(chatUser: chatUser, messageText: image, type: MessageType.image);
    }
    pikeImageList.clear();
  }

  // ADD MULTIPLE IMAGE
  void sendImageInGroup(String id) {
    for (var image in pikeImageGroupList) {
      MessageService().sendMessageInGroup(messageText: image, type: MessageType.image, docId: id);
    }
    pikeImageGroupList.clear();
  }

  // PIKE IMAGE FORM CAMERA
  Future<void> pikeImageFormCamera({int j = 0}) async {
    var data = await pickImage(i: 1);
    if (data != null) {
      if (j == 0) {
        pikeImageList.add(data);
      } else {
        pikeImageGroupList.add(data);
      }
    }
  }

  // REMOVE SELECTED IMAGE
  void removeImage(int index, {int i = 0}) {
    if (i == 0) {
      pikeImageList.removeAt(index);
    } else {
      pikeImageGroupList.removeAt(index);
    }
  }

  // SEND MESSAGE IN GROUP
  Future<void> sendMessageInGroup({required String name, required String docId, required dynamic messageText, required MessageType type}) async {
    if (messageText.isNotEmpty) {
      groupChatBotController.value.text = '';
      print('DOC ID 🎗 $docId');
      await MeetingService().sendMessageInMeetingGroup(name: name,messageText: messageText, type: type, docId: docId);
    } else {
      print('chat boot is empty');
    }
  }

  void deleteMessage(String groupId, {int i = 0, String receiverId = ''}) {
    if (i == 0) {
      for (var message in deleteGroupMessageIds) {
        MessageService().deleteGroupMessage(groupId, message);
        print('REMOVE MESSAGE ID $message');
      }
      selectedGroupMessageIds.clear();
      deleteGroupMessageIds.clear();
      isGroupSelectionMode.value = false;
    } else {
      for (var message in deleteMessageIds) {
        print('DELETE THIS MESSAGE FORM $receiverId && MID - $message');
        MessageService().deleteMessage(receiverId, message);
        print('REMOVE MESSAGE ID $message');
      }
      selectedMessageIds.clear();
      deleteMessageIds.clear();
      isSelectionMode.value = false;
    }
    Get.back();
  }
}
