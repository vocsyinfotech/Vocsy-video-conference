import 'dart:async';
import 'dart:io';

import 'package:video_conforance/utilitis/common_import.dart';
import "package:http/http.dart" as http;

enum MessageType { text, image, file }

class MessageService {
  String currentUserId = FirebaseAuth.instance.currentUser?.uid??'';
  // CONVERSATION ID
  String generatePrivateRoomId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return 'room_${sorted[0]}_${sorted[1]}';
  }

  /// SINGLE USER CHAT
  // START TYPING STATUS
  void startTypingStatus({required String roomId, required String userId, required bool isTyping}) {
    FirebaseFirestore.instance.collection('chatRooms').doc(roomId).set({
      'typingStatus': {userId: isTyping},
    }, SetOptions(merge: true));
  }

  // CLOSE TYPING STATUS
  void closeTypingStatus({required String roomId, required String userId}) {
    FirebaseFirestore.instance.collection('chatRooms').doc(roomId).set({
      'typingStatus': {userId: false},
    }, SetOptions(merge: true));
  }

  // CREATE MESSAGE
  Future<void> sendMessage({required UserModel chatUser, required String receiverId, required String messageText, required MessageType type}) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final roomId = generatePrivateRoomId(receiverId, senderId);
    print('ROOM ID IS $roomId');
    final docRef = FirebaseFirestore.instance.collection('chatRooms').doc(roomId);

    await docRef.update({
      'isGroup': false,
      'members': [senderId, receiverId],
      'lastMessage': messageText,
      'lastSenderId': senderId,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });

    await docRef.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'type': type.name,
    });

    sendPushNotification(chatUser, messageText);

    print('Message sent');
  }

  // READ MESSAGE
  Future<void> markAllMessagesAsRead(String receiverId) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final roomId = generatePrivateRoomId(receiverId, senderId);
    final messageCollection = FirebaseFirestore.instance.collection('chatRooms').doc(roomId).collection('messages');

    final allMessages = await messageCollection.get();

    // print('🎢🎢🎢🎢 ${allMessages.docs.length}');
    for (var doc in allMessages.docs) {
      final data = doc.data();
      final seenBy = data['seenBy'] as List<dynamic>?;

      // If seenBy doesn't exist or doesn't contain senderId
      if (seenBy == null || !seenBy.contains(senderId)) {
        await doc.reference.update({
          'seenBy': FieldValue.arrayUnion([senderId]),
        });
      }
    }

    print('All unread messages marked as read');
  }

  Stream<List<ChatMessage>> getUnreadMessagesStream(String roomId, String currentUserId) {
    return FirebaseFirestore.instance.collection('chatRooms').doc(roomId).collection('messages').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data(), doc.id))
          .where((msg) => msg.senderId != currentUserId && !(msg.seenBy ?? []).contains(currentUserId))
          .toList();
    });
  }

  // DELETE MESSAGE
  void deleteMessage(String receiverId, String messageId) {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final roomId = generatePrivateRoomId(receiverId, senderId);
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .then((_) => print("Message deleted"))
        .catchError((e) => print("Delete failed: $e"));
  }

  // GET SANDED USER MESSAGE TO ME
  Stream<List<UserModel>> getUsersWhoMessagedMeStream() {
    return FirebaseFirestore.instance.collection('chatRooms').where('members', arrayContains: currentUserId).snapshots().asyncMap((
      querySnapshot,
    ) async {
      List<UserModel> users = [];
      Set<String> addedUserIds = {};
      print('ENTER 002');
      for (final doc in querySnapshot.docs) {
        final room = ChatRoom.fromJson(doc.id, doc.data());

        if (room.isGroup) continue;

        // print('BEFORE LAST MESSAGE IS FOLLOWING ${room.lastMessage}');
        // getLastMessageStream(room.roomId);

        // Get the other user's ID
        final otherUserId = room.members.firstWhere((id) => id != currentUserId);
        // print('User first where $otherUserId');

        // Avoid duplicates
        if (addedUserIds.contains(otherUserId)) continue;

        try {
          // Fetch the user data
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(otherUserId).get();

          if (userDoc.exists && userDoc.data() != null) {
            final userModel = UserModel.fromJson(userDoc.data()!, userDoc.id);
            users.add(userModel);
            addedUserIds.add(otherUserId);
          }
        } catch (e) {
          print('Error fetching user $otherUserId: $e');
        }
      }

      return users;
    });
  }

  // GET LAST MESSAGE
  Stream<List<ChatMessage>> getLastMessageStream(String chatRoomId) {
    List<ChatMessage> list = [];
    // print('ID IS ID $chatRoomId');
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .asyncMap((message) {
          for (final doc in message.docs) {
            // print('🚇 ${doc.data()}');
            final data = ChatMessage.fromJson(doc.data(), doc.id);
            list.add(data);
          }
          return list;
        });
  }

  // GET ALL MESSAGE
  Stream<List<ChatMessage>> getAllMessageStream(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          print('🧨🧨🧨 ${snapshot.docs.first.data()}');
          return snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data(), doc.id)).toList(); // Create a new list every time
        });
  }

  // FETCH USER DATA
  Stream<UserModel> getUserdataStream(String id) {
    return FirebaseFirestore.instance.collection('users').doc(id).snapshots().map((user) => UserModel.fromJson(user.data()!, user.id));
  }

  // SEND NOTIFICATION WHEN SEND THE MESSAGE
  Future<void> sendPushNotification(UserModel chatUser, String msg, {String name = ''}) async {
    bool permission = await getNotificationPermissionStatus(chatUser.documentId.toString());
    debugPrint(' CHAT USER PUSH TOKEN :::  ${chatUser.pushToken}');
    debugPrint(' CHAT USER NOTIFICATION PERMISSION :::  $permission');

    if (permission) {
      try {
        final body = {
          "message": {
            "token": chatUser.pushToken,
            "notification": {
              "title": name.isNotEmpty ? name : CommonVariable.userName.value, //our name should be send
              "body": name.isNotEmpty ? '${CommonVariable.userName.value} : $msg ' : msg,
            },
          },
        };

        // Firebase Project > Project Settings > General Tab > Project ID
        const projectID = 'cc-video-conference';

        // get firebase admin token
        final bearerToken = await NotificationAccessToken.getToken;

        print('bearerToken: $bearerToken');

        // handle null token
        if (bearerToken == null) return;

        print('PROJECT ID ::: $projectID');
        var res = await http.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'Bearer $bearerToken'},
          body: jsonEncode(body),
        );

        print('Response status: ${res.statusCode}');
        print('Response body: ${res.body}');
      } catch (e) {
        print('\nsendPushNotificationE: $e');
      }
    }
  }

  // GET NOTIFICATION PERMISSION STATUS
  Future<bool> getNotificationPermissionStatus(String rID) async {
    debugPrint('GET NOTIFICATION PERMISSION STATUS $rID');
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(rID).get();
      if (userDoc.exists) {
        final data = UserModel.fromJson(userDoc.data()!, rID);
        bool isNotification = data.isShowNotification!;
        debugPrint('isNotification: $isNotification');
        return isNotification;
      } else {
        debugPrint('Document does not exist');
        return false;
      }
    } catch (e) {
      debugPrint('Error getting isNotification: $e');
      return false;
    }
  }

  /// GROUP CHAT
  Future<void> generateGroup(String name) async {
    print('Enter the 001 FU');
    var docId = 'group_$currentUserId';
    final docRef = FirebaseFirestore.instance.collection('groupChat').doc(docId);
    await docRef.set({
      'isGroup': true,
      'members': [currentUserId],
      'name': name,
      'createdBy': currentUserId,
    });
  }

  // INVITE MEMBER IN GROUP
  Future<void> inviteMemberInGroup(String docId) async {
    print('Invite member in group');
    final docRef = FirebaseFirestore.instance.collection('groupChat').doc(docId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({
        'members': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  // REMOVE THE MEMBER IN GROUP
  Future<void> removeMember(String docId) async {
    print('REMOVE THE GROUP 001');
    final docRef = FirebaseFirestore.instance.collection('groupChat').doc(docId);
    await docRef.delete();
  }

  // GET CHAT ROOM GROUP
  Stream<List<ChatGroupRoom>> getChatGroupList() {
    return FirebaseFirestore.instance.collection('groupChat').where('members', arrayContains: currentUserId).snapshots().asyncMap((
      querySnapshot,
    ) async {
      List<ChatGroupRoom> users = [];

      print('ENTER 002');
      for (final doc in querySnapshot.docs) {
        final room = ChatGroupRoom.fromJson(doc.data(), doc.id);
        // print('NAME MEETING GROUP 🎀 ${room} 🎀');
        users.add(room);
      }
      return users;
    });
  }

  // INVITE MEMBER IN GROUP
  Future<void> sendMessageInGroup({required String docId, required String messageText, required MessageType type}) async {
    print('Send Image in group');
    final docRef = FirebaseFirestore.instance.collection('groupChat').doc(docId);
    docRef.update({'lastMessageSenderUserName': CommonVariable.userName.value});

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.collection('messages').add({
        'senderId': currentUserId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'type': type.name,
        'seenBy': FieldValue.arrayUnion([currentUserId]),
      });
      sendNotificationToAllMember(docId, messageText);
    }
  }

  // SEND NOTIFICATION TO ALL USERS
  Future<void> sendNotificationToAllMember(String docId, String msg) async {
    List<UserModel> users = [];
    var groupName = '';
    final docSnapshot = await FirebaseFirestore.instance.collection('groupChat').doc(docId).get();
    if (docSnapshot.exists) {
      final room = ChatGroupRoom.fromJson(docSnapshot.data()!, docSnapshot.id);
      groupName = room.name;
      List<String> members = List<String>.from(room.members);
      // print('🎒🎒${room.members}');
      members.remove(currentUserId);
      // print('🎒🎒$members');
      users = await AuthService().getDataUsersDataBuyId(members);
    }
    for (var user in users) {
      // print('🏈 ${user.username} && ${user.pushToken} 🏈');
      if (user.pushToken != null && user.pushToken!.isNotEmpty) {
        await sendPushNotification(user, msg, name: groupName);
      }
    }
  }

  // GET ALL GROUP MESSAGE
  Stream<List<ChatMessage>> getAllGroupMessageStream(String groupId) {
    return FirebaseFirestore.instance
        .collection('groupChat')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          // print('🧨🧨🧨 ${snapshot.docs.first.data()}');
          return snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data(), doc.id)).toList(); // Create a new list every time
        });
  }

  // GET LAST MESSAGE FORM GROUP

  Stream<List<ChatMessage>> getLastMessageFromGroupStream(String chatRoomId) {
    // print('ID IS ID $chatRoomId');
    return FirebaseFirestore.instance
        .collection('groupChat')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .asyncMap((message) {
          List<ChatMessage> list = [];
          for (var doc in message.docs) {
            // print('🚇 ${doc.data()}');
            final data = ChatMessage.fromJson(doc.data(), doc.id);
            list.add(data);
          }
          // print('👕👕 ${list[0].text} 👕👕');
          return list;
        });
  }

  // READ ALL GROUP MESSAGE
  Future<void> markAllGroupMessagesAsRead(String groupId) async {
    print('GROUP ID $groupId');
    final messageCollection = FirebaseFirestore.instance.collection('groupChat').doc(groupId).collection('messages');

    final allMessages = await messageCollection.get();

    // print('🎢🎢🎢🎢 ${allMessages.docs.length}');
    for (var doc in allMessages.docs) {
      final data = doc.data();
      final seenBy = data['seenBy'] as List<dynamic>?;

      // If seenBy doesn't exist or doesn't contain senderId
      if (seenBy == null || !seenBy.contains(currentUserId)) {
        await doc.reference.update({
          'seenBy': FieldValue.arrayUnion([currentUserId]),
        });
      }
    }

    print('All unread messages marked as read');
  }

  Stream<List<ChatMessage>> getUnreadGroupMessagesStream(String groupId) {
    return FirebaseFirestore.instance.collection('groupChat').doc(groupId).collection('messages').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data(), doc.id))
          .where((msg) => msg.senderId != currentUserId && !(msg.seenBy ?? []).contains(currentUserId))
          .toList();
    });
  }

  // DELETE MESSAGE GROUP IN
  void deleteGroupMessage(String groupId, String messageId) {
    print('DELETE GROUP ID $groupId && MESSAGE ID IS $messageId');
    FirebaseFirestore.instance
        .collection('groupChat')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .then((_) => print("Message deleted"))
        .catchError((e) => print("Delete failed: $e"));
  }
}
