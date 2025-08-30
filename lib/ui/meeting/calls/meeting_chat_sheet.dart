import 'package:video_conforance/utilitis/common_import.dart';

class MeetingChatSheet extends StatelessWidget {
  final ChatGroupRoom groupRoom;
  final String channelName;

  MeetingChatSheet({super.key, required this.groupRoom, required this.channelName});

  final mcsc = MeetingChatSheetController();

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return
       Scaffold(
        backgroundColor: ConstColor.darkGray,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: MeetingService().getAllGroupMeetingMessageStream(name: channelName,groupId:  groupRoom.documentId),
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
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          final isMe = false /*message.senderId == MessageService().currentUserId*/;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                // onLongPress: () {
                                //   print('ON LONG PRESS ON THE ${message.documentId}');
                                //   if (!mcsc.isGroupSelectionMode.value) {
                                //     mcsc.isGroupSelectionMode.value = true;
                                //     mcsc.selectedGroupMessageIds.add(message.documentId.toString());
                                //     if (message.senderId == MessageService().currentUserId) {
                                //       mcsc.deleteGroupMessageIds.add(message.documentId.toString());
                                //     }
                                //   }
                                // },
                                // onTap: () {
                                //   if (mcsc.isGroupSelectionMode.value) {
                                //     if (mcsc.selectedGroupMessageIds.contains(message.documentId)) {
                                //       mcsc.selectedGroupMessageIds.remove(message.documentId);
                                //       if (mcsc.selectedGroupMessageIds.isEmpty) mcsc.isGroupSelectionMode.value = false;
                                //     } else {
                                //       mcsc.selectedGroupMessageIds.add(message.documentId.toString());
                                //       if (message.senderId == MessageService().currentUserId) {
                                //         mcsc.deleteGroupMessageIds.add(message.documentId.toString());
                                //       }
                                //     }
                                //   }
                                // },
                                child: Stack(
                                  children: [
                                    liveMeetingChatMessageBubble(message, isMe, sHeaderColor, groupRoom.documentId.toString()),
                                    // if (mcsc.isGroupSelectionMode.value)
                                    //   Positioned.fill(
                                    //     child: Container(
                                    //       color: mcsc.selectedGroupMessageIds.contains(message.documentId)
                                    //           ? ConstColor.lightBlue.withValues(alpha: 0.3) // .withValues is not ideal here
                                    //           : Colors.transparent,
                                    //     ),
                                    //   ),
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
          ],
        ),
        bottomNavigationBar: Obx(() {
          mcsc.pikeImageGroupList;
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 90.h,
              decoration: BoxDecoration(color: ConstColor.darkGray),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56.h,
                          child: CommonTextFiled(
                            controller: mcsc.groupChatBotController.value,
                            hintText: "Write_your_message".tr,
                            hintStyle: TextStyle(fontSize: 12.sp, color: ConstColor.white.withValues(alpha: 0.3), fontFamily: "RM"),
                            textColor: ConstColor.white,
                            isHideBorder: true,
                            isFiled: true,
                            filedColor: ConstColor.white.withValues(alpha: 0.05),
                            onChanged: (value) {
                              // MessageService().startTypingStatus(isTyping: value.isNotEmpty, roomId: roomId, userId: MessageService().currentUserId);
                            },
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
                          mcsc.sendMessageInGroup(
                            name: channelName,
                            docId: groupRoom.documentId,
                            messageText: mcsc.groupChatBotController.value.text.trim(),
                            type: MessageType.text,
                          );
                        },
                      ),
                    ],
                  ),
                  if (mcsc.pikeImageGroupList.isNotEmpty)
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
                                final bytes = base64Decode(mcsc.pikeImageGroupList[index]);
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
                                          mcsc.removeImage(index, i: 1);
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
                              itemCount: mcsc.pikeImageGroupList.length,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CommonSvgView(
                            iconPath: 'assets/icons/send.svg',
                            height: 40.w,
                            width: 40.w,
                            fit: BoxFit.cover,
                            onTap: () {
                              mcsc.sendImageInGroup(groupRoom.documentId);
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
                  mcsc.pikeMultipleIma(i: 1);
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
                title: mcsc.selectedGroupMessageIds.length == 1 ? 'Delete Message?' : 'Delete ${mcsc.selectedGroupMessageIds.length} Message?',
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
                      mcsc.isGroupSelectionMode.value = false;
                      mcsc.selectedGroupMessageIds.clear();
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








/*
import 'package:video_conforance/utilitis/common_import.dart';

class MeetingChatSheet extends StatelessWidget {
  final ChatGroupRoom groupRoom;

  MeetingChatSheet({super.key, required this.groupRoom});

  final mcsc = MessageDetailsController();

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          automaticallyImplyLeading: false,
          backgroundColor: cardColor,
          title: !mcsc.isGroupSelectionMode.value && mcsc.selectedGroupMessageIds.isEmpty
              ? Row(
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
                backgroundImage: null,
                child: CommonTextWidget(
                  title: groupRoom.name.toString().substring(0, 2).toUpperCase(),
                  fontFamily: "RSB",
                  fontSize: 16.sp,
                  color: ConstColor.white,
                ),
              ),
              SizedBox(width: 15.w),
              FutureBuilder(
                future: AuthService().getDataUsersDataBuyId(groupRoom.members),
                builder: (context, snapshot) {
                  var members = '';
                  if (snapshot.hasData && snapshot.data != null) {
                    members = snapshot.data!.map((user) => user.username).join(', ');
                    print('MEMBERS NAME LIST: $members');
                  }
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget(title: groupRoom.name, fontFamily: "RB", fontSize: 16.sp, color: sHeaderColor),
                        SizedBox(height: 5.h),
                        CommonTextWidget(title: members, fontFamily: "RB", fontSize: 12.sp, color: sHeaderColor.withValues(alpha: 0.5)),
                      ],
                    ),
                  );
                },
              ),
            ],
          )
              : Row(
            children: [
              IconButton(
                onPressed: () {
                  mcsc.isGroupSelectionMode.value = false;
                  mcsc.selectedGroupMessageIds.clear();
                  mcsc.deleteGroupMessageIds.clear();
                },
                icon: Icon(Icons.arrow_back_rounded, color: sHeaderColor),
              ),

              IconButton(
                onPressed: () {
                  print('DATA IS DELETE 001 ${groupRoom.documentId.split('_')[1]} && ${MessageService().currentUserId}');
                  showDeleteMessageDialog(
                    context,
                    isMe: true,
                    onDelete: () {
                      mcsc.deleteMessage(groupRoom.documentId);
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
                stream: MessageService().getAllGroupMessageStream(groupRoom.documentId),
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

                          final isMe = true */
/*message.senderId == MessageService().currentUserId*//*
;

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
                                        title: mcsc.formatDateHeader(message.timestamp ?? DateTime.now()),
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
                                  if (!mcsc.isGroupSelectionMode.value) {
                                    mcsc.isGroupSelectionMode.value = true;
                                    mcsc.selectedGroupMessageIds.add(message.documentId.toString());
                                    if (message.senderId == MessageService().currentUserId) {
                                      mcsc.deleteGroupMessageIds.add(message.documentId.toString());
                                    }
                                  }
                                },
                                onTap: () {
                                  if (mcsc.isGroupSelectionMode.value) {
                                    if (mcsc.selectedGroupMessageIds.contains(message.documentId)) {
                                      mcsc.selectedGroupMessageIds.remove(message.documentId);
                                      if (mcsc.selectedGroupMessageIds.isEmpty) mcsc.isGroupSelectionMode.value = false;
                                    } else {
                                      mcsc.selectedGroupMessageIds.add(message.documentId.toString());
                                      if (message.senderId == MessageService().currentUserId) {
                                        mcsc.deleteGroupMessageIds.add(message.documentId.toString());
                                      }
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    buildGroupMessageBubble(message, isMe, sHeaderColor, groupRoom.documentId.toString()),
                                    if (mcsc.isGroupSelectionMode.value)
                                      Positioned.fill(
                                        child: Container(
                                          color: mcsc.selectedGroupMessageIds.contains(message.documentId)
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
          ],
        ),
        bottomNavigationBar: Obx(() {
          mcsc.pikeImageGroupList;
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
                          mcsc.pikeImageFormCamera(j: 1);
                        },
                        child: CommonSvgView(iconPath: 'assets/icons/camera.svg', height: 25.w, width: 25.w, fit: BoxFit.cover, color: sHeaderColor),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          height: 56.h,
                          child: CommonTextFiled(
                            controller: mcsc.groupChatBotController.value,
                            hintText: "Write_your_message".tr,
                            hintStyle: TextStyle(fontSize: 12.sp, color: sHeaderColor.withValues(alpha: 0.3), fontFamily: "RM"),
                            isHideBorder: true,
                            isFiled: true,
                            filedColor: sHeaderColor.withValues(alpha: 0.05),
                            onChanged: (value) {
                              // MessageService().startTypingStatus(isTyping: value.isNotEmpty, roomId: roomId, userId: MessageService().currentUserId);
                            },
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
                          mcsc.sendMessageInGroup(
                            docId: groupRoom.documentId,
                            messageText: mcsc.groupChatBotController.value.text.trim(),
                            type: MessageType.text,
                          );
                        },
                      ),
                    ],
                  ),
                  if (mcsc.pikeImageGroupList.isNotEmpty)
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
                                final bytes = base64Decode(mcsc.pikeImageGroupList[index]);
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
                                          mcsc.removeImage(index, i: 1);
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
                              itemCount: mcsc.pikeImageGroupList.length,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CommonSvgView(
                            iconPath: 'assets/icons/send.svg',
                            height: 40.w,
                            width: 40.w,
                            fit: BoxFit.cover,
                            onTap: () {
                              mcsc.sendImageInGroup(groupRoom.documentId);
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
                  mcsc.pikeMultipleIma(i: 1);
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
                title: mcsc.selectedGroupMessageIds.length == 1 ? 'Delete Message?' : 'Delete ${mcsc.selectedGroupMessageIds.length} Message?',
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
                      mcsc.isGroupSelectionMode.value = false;
                      mcsc.selectedGroupMessageIds.clear();
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
*/
