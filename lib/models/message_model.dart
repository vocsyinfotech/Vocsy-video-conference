import 'package:video_conforance/utilitis/common_import.dart';

class ChatMessage {
  String? documentId;
  final String senderId;
  final String text;
  final MessageType type;
  final DateTime? timestamp;
  final List<String>? seenBy;

  ChatMessage({this.documentId, required this.senderId, required this.text, required this.type, required this.timestamp, required this.seenBy});

  factory ChatMessage.fromJson(Map<String, dynamic> map, String docId) {
    Timestamp? lastTime = map['timestamp'];
    DateTime? timeTamp = lastTime?.toDate();
    return ChatMessage(
      documentId: docId,
      senderId: map['senderId'],
      text: map['text'],
      type: MessageType.values.firstWhere((e) => e.name == map['type']),
      timestamp: timeTamp,
      seenBy: map['seenBy'] != null ? List<String>.from(map['seenBy']) : [],
    );
  }
}

class ChatRoom {
  final String roomId;
  final bool isGroup;
  final String lastMessage;
  final String lastSenderId;
  final List<String> members;
  final DateTime? lastTimestamp;

  ChatRoom({
    required this.roomId,
    required this.isGroup,
    required this.lastMessage,
    required this.members,
    required this.lastTimestamp,
    required this.lastSenderId,
  });

  factory ChatRoom.fromJson(String id, Map<String, dynamic> map) {
    Timestamp? lastTime = map['lastTimestamp'];
    DateTime? lastTimestamp = lastTime?.toDate();
    return ChatRoom(
      roomId: id,
      isGroup: map['isGroup'] ?? false,
      lastMessage: map['lastMessage'] ?? '',
      members: List<String>.from(map['members']),
      lastTimestamp: lastTimestamp,
      lastSenderId: map['lastSenderId'],
    );
  }
}

class ChatGroupRoom {
  final String documentId;
  final String createdBy;
  final String name;
  final bool isGroup;
  final List<String> members;
  final String? lastMessageSenderName;
  ChatGroupRoom({
    required this.documentId,
    required this.createdBy,
    required this.name,
    required this.isGroup,
    required this.members,
    required this.lastMessageSenderName,
  });

  factory ChatGroupRoom.fromJson(Map<String, dynamic> map, String id) {
    // Timestamp? lastTime = map['createdBy'];
    // DateTime? createdBy = lastTime?.toDate();
    return ChatGroupRoom(
      documentId: id,
      createdBy: map['createdBy'],
      name: map['name'],
      isGroup: map['isGroup'] ?? false,
      members: List<String>.from(map['members']),
      lastMessageSenderName: map['lastMessageSenderUserName'],
    );
  }
}
