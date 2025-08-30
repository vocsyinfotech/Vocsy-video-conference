import '../utilitis/common_import.dart';

class MeetingModel {
  String? documentId;
  String? createdBy;
  String? meetingTitle;
  String? owner;
  String? meetingId;
  String? passcode;
  String? duration;
  String? channelName;
  DateTime? meetingStartTime;
  DateTime? meetingEndTime;
  bool? isOngoing;
  List<String>? members;

  MeetingModel({
    this.documentId,
    this.createdBy,
    this.meetingTitle,
    this.owner,
    this.meetingId,
    this.passcode,
    this.duration,
    this.channelName,
    this.meetingStartTime,
    this.meetingEndTime,
    this.isOngoing,
    this.members,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json, String docId) {
    Timestamp? startTs = json['startTime'];
    Timestamp? endTs = json['endTime'];
    DateTime? start = startTs?.toDate();
    DateTime? end = endTs?.toDate();
    final now = DateTime.now();
    return MeetingModel(
      documentId: docId,
      createdBy: json['createdBy'],
      meetingTitle: json['meetingName'],
      owner: json['owner'],
      meetingId: json['meetingID'],
      passcode: json['passcode'],
      duration: json['duration'],
      channelName: json['channelName']??'',
      meetingStartTime: start,
      meetingEndTime: end,
      isOngoing: start != null && end != null ? now.isAfter(start) && now.isBefore(end) : false,
      members: json['participants'] != null ? List<String>.from(json['participants']) : [],
    );
  }
}
