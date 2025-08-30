class GetHostModel {
  final String documentId;
  final String meetingChanelName;
  final String hostName;
  final String userId;
  final List<String> members;
  final int hostId;

  GetHostModel({
    required this.documentId,
    required this.meetingChanelName,
    required this.hostId,
    required this.userId,
    required this.members,
    required this.hostName,
  });

  factory GetHostModel.fromJson( Map<String, dynamic> map,String id) {
    return GetHostModel(
      documentId: id,
      meetingChanelName: map['meetingName'],
      hostName: map['hostName'],
      userId: map['userId'],
      members: List<String>.from(map['members']),
      hostId: map['hostId'],
    );
  }
}