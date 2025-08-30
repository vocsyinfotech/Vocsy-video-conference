import 'package:video_conforance/utilitis/common_import.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});

  final mc = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    return Obx(() {
      return mc.groupChatUser.isEmpty && mc.userList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonSvgView(iconPath: 'assets/images/empty_message.svg', height: 150.w, width: 150.w, fit: BoxFit.cover),
                  SizedBox(height: 10.h),
                  CommonTextWidget(title: 'No Any Message'.tr, fontSize: 16.sp, fontFamily: 'RM', color: Theme.of(context).secondaryHeaderColor),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.only(top: 20.sp),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          var userData = mc.groupChatUser[index];
                          Get.to(() => GroupMessageDetailsScreen(groupRoom: userData));
                        },
                        child: Row(
                          children: [
                            StreamBuilder(
                              stream: MessageService().getUnreadGroupMessagesStream(mc.groupChatUser[index].documentId),
                              builder: (context, unreadSnapshot) {
                                final hasUnread = unreadSnapshot.hasData && unreadSnapshot.data!.isNotEmpty;
                                return Container(
                                  height: 8.w,
                                  width: 8.w,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: hasUnread ? ConstColor.lightBlue : Colors.transparent),
                                );
                              },
                            ),
                            SizedBox(width: 5.w),
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage: null,
                              child: CommonTextWidget(
                                title: getUserInitials(mc.groupChatUser[index].name.toString()),
                                fontFamily: "RSB",
                                fontSize: 16.sp,
                                color: ConstColor.white,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            StreamBuilder(
                              stream: MessageService().getLastMessageFromGroupStream(mc.groupChatUser[index].documentId),
                              builder: (context, snapshot) {
                                String lastMessage = '';
                                String lastMessageTime = '';
                                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  var data = snapshot.data!.first;
                                  var name = MessageService().currentUserId == data.senderId ? "You" : mc.groupChatUser[index].lastMessageSenderName;

                                  lastMessage = data.type.name == 'image' ? '$name : 📷 Photo' : '$name : ${data.text}';
                                  lastMessageTime = data.timestamp != null ? timeAgo(data.timestamp!) : '';
                                } else {
                                  lastMessage = "No messages yet"; // ✅ Default message when null
                                  lastMessageTime = '';
                                }
                                mc.msg.value = lastMessage;
                                mc.time.value = lastMessageTime;
                                return Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CommonTextWidget(
                                              title: mc.groupChatUser[index].name,
                                              fontFamily: "RSB",
                                              fontSize: 18.sp,
                                              color: sHeaderColor,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Row(
                                            children: [
                                              CommonTextWidget(
                                                title: mc.time.value,
                                                fontFamily: "RM",
                                                fontSize: 16.sp,
                                                color: sHeaderColor.withValues(alpha: 0.6),
                                              ),
                                              SizedBox(width: 5.w),
                                              Icon(Icons.arrow_forward_ios_rounded, size: 20.sp, color: sHeaderColor.withValues(alpha: 0.2)),
                                              SizedBox(width: 10.w),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      CommonTextWidget(
                                        title: mc.msg.value,
                                        fontFamily: "RR",
                                        fontSize: 12.sp,
                                        color: sHeaderColor,
                                        maxLines: 1,
                                      ).paddingOnly(right: 10.sp),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ).paddingOnly(left: 15.sp),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), indent: 30);
                    },
                    itemCount: mc.groupChatUser.length,
                  ),
                  if (mc.groupChatUser.isNotEmpty) Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), indent: 30),
                  ListView.separated(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final roomId = MessageService().generatePrivateRoomId(MessageService().currentUserId, mc.userList[index].documentId.toString());
                      Uint8List? bytes = mc.userList[index].image == null ? null : base64Decode(mc.userList[index].image.toString());
                      return GestureDetector(
                        onTap: () {
                          var userData = mc.userList[index];
                          Get.to(() => MessageDetailsScreen(userData: userData));
                        },
                        child: Row(
                          children: [
                            StreamBuilder(
                              stream: MessageService().getUnreadMessagesStream(roomId, MessageService().currentUserId),
                              builder: (context, unreadSnapshot) {
                                final hasUnread = unreadSnapshot.hasData && unreadSnapshot.data!.isNotEmpty;
                                return Container(
                                  height: 8.w,
                                  width: 8.w,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: hasUnread ? ConstColor.lightBlue : Colors.transparent),
                                );
                              },
                            ),
                            SizedBox(width: 5.w),
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage: (bytes != null && bytes.isNotEmpty) ? MemoryImage(bytes) : null,
                              child: (bytes == null || bytes.isEmpty)
                                  ? CommonTextWidget(
                                      title: getUserInitials(mc.userList[index].username.toString()),
                                      fontFamily: "RSB",
                                      fontSize: 16.sp,
                                      color: ConstColor.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 20.w),
                            StreamBuilder(
                              stream: MessageService().getLastMessageStream(roomId),
                              builder: (context, snapshot) {
                                var msg = '';
                                var time = '';
                                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  // print('SNAP SHORT DATA IS  ${snapshot.data!.first.text}');
                                  // print('SNAP SHORT DATA IS  ${snapshot.data!.first.text}');
                                  if (snapshot.data?.first.type.name == 'image') {
                                    msg = '📷 Photo';
                                  } else {
                                    msg = snapshot.data?.first.text ?? '';
                                  }
                                  time = snapshot.data!.first.timestamp != null ? timeAgo(snapshot.data!.first.timestamp!) : '';
                                }
                                return Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CommonTextWidget(
                                              title: '${mc.userList[index].username}',
                                              fontFamily: "RSB",
                                              fontSize: 18.sp,
                                              color: sHeaderColor,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Row(
                                            children: [
                                              CommonTextWidget(
                                                title: time,
                                                fontFamily: "RM",
                                                fontSize: 16.sp,
                                                color: sHeaderColor.withValues(alpha: 0.6),
                                              ),
                                              SizedBox(width: 5.w),
                                              Icon(Icons.arrow_forward_ios_rounded, size: 20.sp, color: sHeaderColor.withValues(alpha: 0.2)),
                                              SizedBox(width: 10.w),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      CommonTextWidget(
                                        title: msg,
                                        fontFamily: "RR",
                                        fontSize: 12.sp,
                                        color: mc.userList[index].isOnline! ? sHeaderColor : sHeaderColor.withValues(alpha: 0.5),
                                        maxLines: 1,
                                      ).paddingOnly(right: 10.sp),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ).paddingOnly(left: 15.sp),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 1.5, color: sHeaderColor.withValues(alpha: 0.1), indent: 30);
                    },
                    itemCount: mc.userList.length,
                  ),
                ],
              ),
            );
    });
  }
}
