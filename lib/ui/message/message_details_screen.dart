import 'package:video_conforance/utilitis/common_import.dart';

class MessageDetailsScreen extends StatelessWidget {
  final UserModel userData;

  MessageDetailsScreen({super.key, required this.userData});

  final mdc = MessageDetailsController();

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes = userData.image == null ? null : base64Decode(userData.image.toString());
    final roomId = MessageService().generatePrivateRoomId(MessageService().currentUserId, userData.documentId.toString());
    print('ROOM ID IS FOLLOWING IS $roomId');
    print('ONLINE STATUS ${userData.isOnline}');
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80.h,
          automaticallyImplyLeading: false,
          backgroundColor: cardColor,
          title: !mdc.isSelectionMode.value && mdc.selectedMessageIds.isEmpty
              ? StreamBuilder(
                  stream: MessageService().getUserdataStream(userData.documentId.toString()),
                  builder: (context, snapshot) {
                    var image = '';
                    var isOnline = false;
                    if (snapshot.hasData && snapshot.data != null) {
                      image = snapshot.data?.image ?? '';
                      isOnline = snapshot.data?.isOnline ?? false;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.arrow_back_rounded, color: sHeaderColor),
                            ),
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage: (bytes != null && bytes.isNotEmpty) ? MemoryImage(bytes) : null,
                              child: (bytes == null || bytes.isEmpty)
                                  ? CommonTextWidget(
                                      title: userData.username.toString().substring(0, 2).toUpperCase(),
                                      fontFamily: "RSB",
                                      fontSize: 16.sp,
                                      color: ConstColor.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 15.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget(title: userData.username.toString(), fontFamily: "RB", fontSize: 16.sp, color: sHeaderColor),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    isOnline
                                        ? Container(
                                            height: 10.w,
                                            width: 10.w,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff68E070)),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(width: isOnline ? 10.w : 0),
                                    CommonTextWidget(
                                      title: isOnline ? "Online".tr : "Offline".tr,
                                      fontFamily: "RB",
                                      fontSize: 12.sp,
                                      color: sHeaderColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTapDown: (details) {
                            final tapPosition = details.globalPosition;
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(tapPosition.dx, 100.h, 15.w, tapPosition.dy),
                              items: [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 24.sp, color: sHeaderColor),
                                      SizedBox(width: 10.w),
                                      CommonTextWidget(title: "Clear_All".tr, fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          child: Icon(Icons.more_vert, color: sHeaderColor, size: 28.sp),
                        ),
                      ],
                    );
                  },
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        mdc.isSelectionMode.value = false;
                        mdc.selectedMessageIds.clear();
                        mdc.deleteMessageIds.clear();
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: sHeaderColor),
                    ),

                    IconButton(
                      onPressed: () {
                        print('DATA IS DELETE 001 ${userData.documentId} && ${MessageService().currentUserId}');
                        showDeleteMessageDialog(
                          context,
                          isMe: true,
                          onDelete: () {
                            mdc.deleteMessage('', i: 1, receiverId: userData.documentId.toString());
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: sHeaderColor),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.share, color: sHeaderColor),
                    ),
                  ],
                ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: MessageService().getAllMessageStream(roomId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data ?? [];
                      final messages = data.reversed.toList();
                      print('MESSAGE NOT EMPTY ${messages.length}');
                      return messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonSvgView(iconPath: 'assets/images/empty_message.svg', height: 150.w, width: 150.w, fit: BoxFit.cover),
                                  SizedBox(height: 10.h),
                                  CommonTextWidget(
                                    title: 'No Any Message'.tr,
                                    fontSize: 16.sp,
                                    fontFamily: 'RM',
                                    color: Theme.of(context).secondaryHeaderColor,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              addRepaintBoundaries: true,
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];

                                final isMe = message.senderId == MessageService().currentUserId;

                                // --- showSender: avoid showing name repeatedly ---
                                bool showSender = true;
                                if (index > 0 && messages[index - 1].timestamp != null) {
                                  final prev = messages[index - 1];
                                  showSender = !(prev.senderId == message.senderId && formatTime(prev.timestamp!) == formatTime(message.timestamp!));
                                }

                                // --- showDateHeader logic ---
                                bool showDateHeader = false;
                                if (index == messages.length - 1) {
                                  showDateHeader = true;
                                } else {
                                  if (message.timestamp != null) {
                                    final currentDate = DateUtils.dateOnly(message.timestamp!);
                                    final nextDate = DateUtils.dateOnly(messages[index + 1].timestamp!);
                                    showDateHeader = currentDate != nextDate;
                                  }
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showDateHeader)
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 12.sp),
                                            decoration: BoxDecoration(
                                              color: sHeaderColor.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(15.r),
                                            ),
                                            child: CommonTextWidget(
                                              title: mdc.formatDateHeader(message.timestamp ?? DateTime.now()),
                                              fontSize: 14.sp,
                                              fontFamily: "RM",
                                              color: sHeaderColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    GestureDetector(
                                      onLongPress: () {
                                        print('ON LONG PRESS ON THE ${message.documentId}');
                                        if (!mdc.isSelectionMode.value) {
                                          mdc.isSelectionMode.value = true;
                                          mdc.selectedMessageIds.add(message.documentId.toString());
                                          if (message.senderId == MessageService().currentUserId) {
                                            mdc.deleteMessageIds.add(message.documentId.toString());
                                          }
                                        }
                                      },
                                      onTap: () {
                                        if (mdc.isSelectionMode.value) {
                                          if (mdc.selectedMessageIds.contains(message.documentId)) {
                                            mdc.selectedMessageIds.remove(message.documentId);
                                            if (mdc.selectedMessageIds.isEmpty) mdc.isSelectionMode.value = false;
                                          } else {
                                            mdc.selectedMessageIds.add(message.documentId.toString());
                                            if (message.senderId == MessageService().currentUserId) {
                                              mdc.deleteMessageIds.add(message.documentId.toString());
                                            }
                                          }
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          buildMessageBubble(messages[index], isMe, sHeaderColor, userData.documentId.toString()),
                                          if (mdc.isSelectionMode.value)
                                            Positioned.fill(
                                              child: Container(
                                                color: mdc.selectedMessageIds.contains(message.documentId)
                                                    ? ConstColor.lightBlue.withValues(alpha: 0.3) // .withValues is not ideal here
                                                    : Colors.transparent,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                  }
                },
              ),
            ),

            /// 👇 Typing Indicator
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('chatRooms').doc(roomId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox();
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final typingStatus = data?['typingStatus'] ?? {};
                // print('Data 🏝🏝🏝 $typingStatus');
                final otherUserId = userData.documentId;
                final bool isOtherUserTyping = typingStatus[otherUserId] ?? false;

                return isOtherUserTyping
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Lottie.asset('assets/animation/chat_loading.json', height: 100.h),
                      )
                    : SizedBox();
              },
            ),
          ],
        ),
        bottomNavigationBar: Obx(() {
          mdc.pikeImageList;
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 90.h,
              decoration: BoxDecoration(color: cardColor),
              child: Stack(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showShareBottomSheet(context);
                        },
                        child: CommonSvgView(iconPath: 'assets/icons/clip.svg', height: 25.w, width: 25.w, fit: BoxFit.cover, color: sHeaderColor),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          mdc.pikeImageFormCamera();
                        },
                        child: CommonSvgView(iconPath: 'assets/icons/camera.svg', height: 25.w, width: 25.w, fit: BoxFit.cover, color: sHeaderColor),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          height: 56.h,
                          child: CommonTextFiled(
                            controller: mdc.chatBotController.value,
                            hintText: "Write_your_message".tr,
                            hintStyle: TextStyle(fontSize: 12.sp, color: sHeaderColor.withValues(alpha: 0.3), fontFamily: "RM"),
                            isHideBorder: true,
                            isFiled: true,
                            filedColor: sHeaderColor.withValues(alpha: 0.05),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CommonSvgView(
                        iconPath: 'assets/icons/send.svg',
                        height: 40.w,
                        width: 40.w,
                        fit: BoxFit.cover,
                        onTap: () {
                          mdc.sendMessageTo(chatUser: userData, messageText: mdc.chatBotController.value.text.trim(), type: MessageType.text);
                        },
                      ),
                    ],
                  ),
                  if (mdc.pikeImageList.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(color: cardColor),
                      child: Row(
                        children: [
                          SizedBox(
                            width: commonWidth * 0.770,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final bytes = base64Decode(mdc.pikeImageList[index]);
                                return Stack(
                                  children: [
                                    Container(
                                      height: 50.w,
                                      width: 55.w,
                                      padding: EdgeInsets.all(2.sp),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        border: Border.all(color: Colors.blue, width: 1.5),
                                        borderRadius: BorderRadius.circular(15.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13.r),
                                        child: Image.memory(bytes, fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Hello Click the remove image');
                                          mdc.removeImage(index);
                                        },
                                        child: Container(
                                          height: 15.w,
                                          width: 15.w,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: ConstColor.lightBlue),
                                          child: Icon(Icons.close_outlined, size: 10.sp, color: ConstColor.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(width: 10.w),
                              itemCount: mdc.pikeImageList.length,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CommonSvgView(
                            iconPath: 'assets/icons/send.svg',
                            height: 40.w,
                            width: 40.w,
                            fit: BoxFit.cover,
                            onTap: () {
                              mdc.sendImage(userData);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ).paddingSymmetric(horizontal: 20.sp, vertical: 15.sp),
            ),
          );
        }),
      );
    });
  }

  void showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
      builder: (context) {
        return Container(
          height: 350.h,
          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close_outlined, color: Theme.of(context).secondaryHeaderColor),
                  ),
                  SizedBox(width: 80.w),
                  CommonTextWidget(title: 'Share Content', fontFamily: 'RS', color: Theme.of(context).secondaryHeaderColor, fontSize: 16.sp),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Container(
                      height: 50.w,
                      width: 50.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
                      child: CommonSvgView(
                        iconPath: 'assets/icons/camera.svg',
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.4),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    CommonTextWidget(title: 'Camera', fontFamily: "RR", fontSize: 14.sp, color: Theme.of(context).secondaryHeaderColor),
                  ],
                ),
              ),
              Divider(thickness: 1.5, color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.05)).paddingOnly(left: 65.w),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  pikeDocument();
                },
                child: Row(
                  children: [
                    Container(
                      height: 50.w,
                      width: 50.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
                      child: CommonSvgView(
                        iconPath: 'assets/icons/doc.svg',
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget(title: 'Documents', fontFamily: "RR", fontSize: 14.sp, color: Theme.of(context).secondaryHeaderColor),
                        CommonTextWidget(
                          title: 'Share your files',
                          fontFamily: "RR",
                          fontSize: 12.sp,
                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1.5, color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.05)).paddingOnly(left: 65.w),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  mdc.pikeMultipleIma();
                },
                child: Row(
                  children: [
                    Container(
                      height: 50.w,
                      width: 50.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
                      child: CommonSvgView(
                        iconPath: 'assets/icons/image.svg',
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget(title: 'Media', fontFamily: "RR", fontSize: 14.sp, color: Theme.of(context).secondaryHeaderColor),
                        CommonTextWidget(
                          title: 'Share photos and videos',
                          fontFamily: "RR",
                          fontSize: 12.sp,
                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1.5, color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.05)).paddingOnly(left: 65.w),
            ],
          ),
        );
      },
    );
  }

  // DELETE ALERT DIALOG
  Future<void> showDeleteMessageDialog(BuildContext context, {required VoidCallback onDelete, required bool isMe}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
          backgroundColor: Theme.of(context).cardColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                title: mdc.selectedGroupMessageIds.length == 1 ? 'Delete Message?' : 'Delete ${mdc.selectedGroupMessageIds.length} Message?',
                fontFamily: 'RM',
                fontSize: 15.sp,
                color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommonTextWidget(
                    title: 'Close',
                    fontFamily: 'RM',
                    fontSize: 13.sp,
                    color: ConstColor.lightBlue,
                    onTap: () {
                      mdc.isGroupSelectionMode.value = false;
                      mdc.selectedGroupMessageIds.clear();
                      Get.back();
                    },
                  ),
                  SizedBox(width: 20.w),
                  CommonTextWidget(
                    title: 'Delete for me',
                    fontFamily: 'RM',
                    fontSize: 13.sp,
                    color: ConstColor.lightBlue,
                    onTap: () {
                      print('DELETE CLICK');
                      onDelete();
                    },
                  ),
                  SizedBox(width: 20.w),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
