import '../utilitis/common_import.dart';

class UserModel {
  String? documentId;
  DateTime? createdAt;
  String? email;
  String? image;
  bool? isShowNotification;
  bool? isOnline;
  String? jobTitle;
  String? location;
  String? mobile;
  String? personalMeetingID;
  int? status;
  String? username;
  String? pushToken;
  DateTime? lastActive;

  UserModel({
    this.documentId,
    this.createdAt,
    this.email,
    this.image,
    this.isShowNotification,
    this.isOnline,
    this.jobTitle,
    this.location,
    this.mobile,
    this.personalMeetingID,
    this.status,
    this.username,
    this.pushToken,
    this.lastActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    Timestamp? startTs = json['createdAt'];
    Timestamp? last = json['lastActive'];
    DateTime? start = startTs?.toDate();
    DateTime? lastActive = last?.toDate();
    return UserModel(
      documentId: docId,
      createdAt: start,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      isShowNotification: json['isShowNotification'] ?? false,
      isOnline: json['isOnline'] ?? false,
      personalMeetingID: json['personalMeetingID'] ?? '',
      status: json['status'] ?? 0,
      jobTitle: json['jobTitle'] ?? '',
      location: json['location'] ?? '',
      mobile: json['mobile'] ?? '',
      pushToken: json['pushToken'] ?? '',
      lastActive: lastActive,
    );
  }
}
