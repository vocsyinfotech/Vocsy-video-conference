import 'package:video_conforance/utilitis/common_import.dart';

class MeetingService {
  String currentUserId = FirebaseAuth.instance.currentUser?.uid??'';

  // START NEW MEETING
  void startNewMeeting({
    required String meetingName,
    required String hostname,
    required String userId,
    required int hostId,
  }) {
    FirebaseFirestore.instance.collection('newMeetings').doc(meetingName).set({
      'meetingName': meetingName,
      'hostName': hostname,
      'userId': userId,
      'hostId': hostId,
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  // GET HOST ID
  Future<List<GetHostModel>> getHostId({required String name}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('newMeetings')
        .where('meetingName', isEqualTo: name)
        .limit(1)
        .get();

    return snapshot.docs
        .map((doc) => GetHostModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  // DELETE THE MEETING
  Future<void> deleteMeeting({required String meetingId}) async {
    try {
      final meetingRef = FirebaseFirestore.instance
          .collection('newMeetings')
          .doc(meetingId);

      // get all groupChat docs
      final groupChatRef = meetingRef.collection('groupChat');
      final groupJoinRef = meetingRef.collection('joinRequests');
      final groupSnapshot = await groupChatRef.get();
      final joinSnapshot = await groupJoinRef.get();

      // Live chat delete
      for (var groupDoc in groupSnapshot.docs) {
        // delete messages subcollection inside each groupChat doc
        final messagesRef = groupDoc.reference.collection('messages');
        final messagesSnapshot = await messagesRef.get();

        for (var msg in messagesSnapshot.docs) {
          await msg.reference.delete();
        }

        // now delete the groupChat doc itself
        await groupDoc.reference.delete();
      }

      // join request delete
      for (var groupDoc in joinSnapshot.docs) {
        await groupDoc.reference.delete();
      }

      // finally delete the meeting doc
      await meetingRef.delete();
      await endNewMeeting(cName: meetingId);

      print("✅ Meeting $meetingId and all its groupChats + messages deleted");
    } catch (e) {
      print("❌ Error deleting meeting: $e");
    }
  }

  Future<void> addMembersInfo({
    required String meetingName,
    required String memberId,
    required String docId,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(meetingName);
    final docSnap = await docRef.get();
    print('ADD MEMBERS 000000000000000000000000000000');
    if (docSnap.exists) {
      print('IF PART IS RUN IN THE EXISTS');
      await docRef.update({
        'members': FieldValue.arrayUnion([memberId]),
      });
    } else {
      print('ELSE PART IS RUN IN NOT EXISTS');
      await docRef.set({
        'members': [memberId],
      });
    }
    await inviteMemberInGroup(meetingName, docId);
  }

  Stream<List<UserModel>> getMembersDataStream({required String name}) {
    return FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(name) // document ID
        .snapshots() // listen for changes in real-time
        .asyncMap((snapshot) async {
          // print('Data is following ${snapshot.data()}');
          if (!snapshot.exists || snapshot.data()?['members'] == null) {
            return [];
          }

          List<dynamic> members = snapshot['members']; // member array
          print("Members: $members");

          if (members.isEmpty) {
            return [];
          }
           // print('joined user as guest name : ${snapshot['name']}');
          // Fetch user data based on member IDs
          // if(snapshot['name']!=null){
          //   print('No members found for meeting: $name');
          //   UserModel userModel =UserModel(username: snapshot.data()?['name']);
          //   print('User model: $userModel');
          // }
          return await AuthService().getDataUsersDataBuyId(members);
        });
  }

  Future<void> deleteMember({
    required String meetingName,
    required String memberId,
    required String docId,
  }) async {
    if (memberId.isNotEmpty) {
      final docRef = FirebaseFirestore.instance
          .collection('newMeetings')
          .doc(meetingName);

      final docSnap = await docRef.get();
      if (docSnap.exists) {
        print('✅ Removing member: $memberId');
        await docRef.update({
          'members': FieldValue.arrayRemove([memberId]),
        });
      } else {
        print('⚠️ Meeting does not exist — nothing to delete');
      }
      removeMember(meetingName, memberId, docId);
    }
  }

  /// GROUP LIVE MEETING CHAT
  Future<void> generateGroup(String name) async {
    print('Enter the 001 FU');
    var docId = 'group_$currentUserId';
    final docRef = FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(name)
        .collection('groupChat')
        .doc(docId);
    await docRef.set({
      'isGroup': true,
      'members': [currentUserId],
      'name': name,
      'createdBy': currentUserId,
    });
  }

  // INVITE MEMBER IN GROUP
  Future<void> inviteMemberInGroup(String name, String docId) async {
    var id = 'group_$docId';
    print('Invite member in group & doc id is following :: - $id');
    final docRef = FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(name)
        .collection('groupChat')
        .doc(id);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({
        'members': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  // REMOVE THE MEMBER IN GROUP
  Future<void> removeMember(String name, String memberId, String docId) async {
    var id = 'group_$docId';
    print('REMOVE THE GROUP 00 $id 00');
    if (memberId.isNotEmpty) {
      final docRef = FirebaseFirestore.instance
          .collection('newMeetings')
          .doc(name)
          .collection('groupChat')
          .doc(id);

      final docSnap = await docRef.get();
      if (docSnap.exists) {
        print('✅ Removing member of inside: $memberId');
        await docRef.update({
          'members': FieldValue.arrayRemove([memberId]),
        });
      } else {
        print('⚠️ Meeting does not exist — nothing to delete');
      }
    }
  }

  // GET CHAT ROOM GROUP
  Stream<List<ChatGroupRoom>> getChatGroupList(String name) {
    return FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(name)
        .collection('groupChat')
        .where('members', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((querySnapshot) async {
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

  // SEND MESSAGE IN GROUP
  Future<void> sendMessageInMeetingGroup({
    required String docId,
    required String name,
    required String messageText,
    required MessageType type,
  }) async {
    // var id = 'group_$docId';
    print('Send Image in group');
    final docRef = FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(name)
        .collection('groupChat')
        .doc(docId);
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
    }
  }

  // GET ALL GROUP MESSAGE
  Stream<List<ChatMessage>> getAllGroupMeetingMessageStream({
    required String name,
    required String groupId,
  }) {
    return FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(name)
        .collection('groupChat')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          // print('🧨🧨🧨 ${snapshot.docs.first.data()}');
          return snapshot.docs
              .map((doc) => ChatMessage.fromJson(doc.data(), doc.id))
              .toList(); // Create a new list every time
        });
  }

  // SCHEDULE NEW MEETING
  Future<void> scheduleNewMeeting({
    required String name,
    required String channelName,
    required String meetingID,
    required DateTime startDate,
    required String passcode,
    required DateTime endDate,
    required String ownerName,
    required String duration,
  }) async {
    await FirebaseFirestore.instance.collection('meetings').add({
      'meetingName': name,
      'channelName': channelName,
      'startTime': Timestamp.fromDate(startDate),
      'endTime': Timestamp.fromDate(endDate),
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
      "passcode": passcode,
      'meetingID': meetingID,
      'owner': ownerName,
      'duration': duration,
      'participants': [FirebaseAuth.instance.currentUser!.uid],
    });

    // await MessageService().generateGroup(name);
  }

  // DELETE MEETING WHEN MEETING END
  Future<void> endNewMeeting({required String cName}) async {
    try {
      final meetingRef = FirebaseFirestore.instance
          .collection('meetings')
          .where('channelName', isEqualTo: cName);

      final querySnapshot = await meetingRef.get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted meeting: ${doc.id}");
      }
    } catch (e) {
      print("Error deleting meeting: $e");
    }
  }

  Future<void> sendJoinRequest(String meetingId, String userId) async {
    await FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(meetingId)
        .collection('joinRequests')
        .doc(userId)
        .set({
          'userId': userId,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> sendJoinRequestAsGuest(String meetingId, String userId,String name) async {
    print('Enter the Join request as guest $name');
    await FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(meetingId)
        .collection('joinRequests')
        .doc(userId)
        .set({
          'name': name,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<UserModel>> listenToJoinRequestsWithUser(String meetingId) {
    return FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(meetingId)
        .collection('joinRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .asyncMap((snapshot) async {
          // for each request doc → fetch user data
          final users = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              final userId = data['userId'] as String;
              final userData = AuthService().getUserDataById(userId);
              return userData;
            },
            ),
          );
          return users;
        });
  }

  // RESPONSE TO THE JOINING REQUEST
  Future<void> respondToRequest({
    required String meetingId,
    required String userId,
    required bool accept,
  }) async {
    await FirebaseFirestore.instance
        .collection('newMeetings')
        .doc(meetingId)
        .collection('joinRequests')
        .doc(userId)
        .update({
          'status': accept ? 'accepted' : 'rejected',
          'respondedAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<DocumentSnapshot> listenToMyRequest(String meetingId, String userId) {
    return FirebaseFirestore.instance.collection('newMeetings')
        .doc(meetingId)
        .collection('joinRequests')
        .doc(userId)
        .snapshots();
  }
}
