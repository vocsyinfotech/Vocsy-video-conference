/*
import 'package:video_conforance/utilitis/common_import.dart';

class MeetingCallScreen extends StatelessWidget {
  MeetingCallScreen({super.key});

  final mcsc = Get.put(MeetingCallController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: ConstColor.darkGray,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 35.h),
                Row(
                  children: [
                    Icon(Icons.arrow_back_rounded, color: ConstColor.white).paddingOnly(left: 10.sp),
                    SizedBox(width: 20.w),
                    CommonSvgView(iconPath: "assets/icons/switch_camera.svg", height: 32.h, width: 32.h, fit: BoxFit.cover),
                    SizedBox(width: 30.w),
                    CommonTextWidget(title: 'Weboxcam', color: ConstColor.lightBlue, fontFamily: "RB", fontSize: 25.sp),
                    Spacer(),
                    CommonContainer(
                      onTap: () {
                        mcsc.endCall(context);
                      },
                      height: 34.h,
                      width: 66.w,
                      radius: 10.r,
                      containerColor: ConstColor.red,
                      child: CommonTextWidget(title: 'End', fontSize: 14.sp, fontFamily: "RM", color: ConstColor.white),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: DecorationImage(
                        image: NetworkImage('https://cdn.pixabay.com/photo/2024/11/10/12/33/woman-9187757_640.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: DecorationImage(
                        image: NetworkImage('https://cdn.pixabay.com/photo/2024/11/10/12/33/businessman-9187791_640.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
            Positioned(
              bottom: 25.sp,
              left: 25.sp,
              child: Container(
                height: 35.h,
                width: 35.w,
                padding: EdgeInsets.all(5.sp),
                decoration: BoxDecoration(shape: BoxShape.circle, color: mcsc.isMute.value ? ConstColor.white : ConstColor.red),
                child: CommonSvgView(
                  iconPath: "assets/icons/mic_1.svg",
                  height: 20.w,
                  width: 20.w,
                  color: mcsc.isMute.value ? ConstColor.red : ConstColor.white,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 100.h,
          color: Color(0xff191919),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button('assets/icons/mic_1.svg', mcsc.isMute.value ? "Unmute" : ' Mute ', mcsc.isMute.value ? ConstColor.red : ConstColor.white, () {
                mcsc.isMute.value = !mcsc.isMute.value;
              }),
              button(
                'assets/icons/mic_2.svg',
                mcsc.isStopVideo.value ? 'Start Video' : 'Stop Video',
                mcsc.isStopVideo.value ? ConstColor.red : ConstColor.white,
                () => mcsc.isStopVideo.value = !mcsc.isStopVideo.value,
              ),
              button('assets/icons/mic_3.svg', "Participants", ConstColor.white, () => mcsc.participantsBottomSheet(context)),
              button('assets/icons/chat_message.svg', "Chat", ConstColor.white, () => mcsc.chatBottomSheet(context)),
            ],
          ),
        ),
      );
    });
  }

  Widget button(String iconPath, String title, Color c1, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonSvgView(iconPath: iconPath, height: 30.w, width: 30.w, color: c1, fit: BoxFit.cover),
          SizedBox(height: 5.h),
          CommonTextWidget(title: title, fontSize: 14.sp, fontFamily: "RR", color: c1),
        ],
      ),
    );
  }
}
*/

// video_call_page.dart

// DEMO
/*import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_conforance/utilitis/common_import.dart';


class VideoCallPage extends StatefulWidget {
  final String channelName;
  final int uid;
  final int i;

  const VideoCallPage({
    super.key,
    required this.channelName,
    required this.uid,
    required this.i,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  Future<void> initAgora() async {
    await CallService().initAgora();
    await CallService().joinChannel(
        'ABC'
    );
  }


  Widget _renderRemoteVideo(int uid) {
    print('≤≤≤≤≤≤≤≤≤≤≤   $uid   ≥≥≥≥≥≥≥≥≥≥≥');
    return Container(
      margin: const EdgeInsets.all(4),
      color: Colors.grey[900],
      child: AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: CallService().engine,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      ),
    );
  }

  Widget _renderLocalPreview() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: CallService().engine,
        canvas: const VideoCanvas(uid: 0),
        useFlutterTexture: true,
      ),
    );
  }


  @override
  void dispose() {
    CallService().disposeAgora();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(' USER HH :: --  ${CallService().remoteUID.length}');
    return Obx(() {
      CallService().remoteUID;
      return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(child: _renderLocalPreview()), // Local video
            const Divider(height: 1),
            Expanded(
              child: CallService().remoteUID.isEmpty
                  ? const Center(child: Text('Waiting for others to join...'))
                  : GridView.count(
                crossAxisCount: 2,
                children:
                CallService().remoteUID.map((uid) => _renderRemoteVideo(uid)).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}*/

import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_conforance/utilitis/common_import.dart';

// Replace with your Agora App ID
const String appId = "9af0e9f912e143939a3e7f400f51bec6";

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final bool videoOff;
  final bool audioOff;

  // final String? name;

  const VideoCallScreen({
    Key? key,
    required this.channelName,
    required this.videoOff,
    required this.audioOff,
    // this.name,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  final List<int> _remoteUsers = [];
  bool meetingActive = true;
  bool _localUserJoined = false;
  bool _muted = false;
  bool _videoOff = false;
  bool isInitialize = true;
  List<GetHostModel>? model;
  UserModel? user;
  List<UserModel> userList = [];
  int? _hostUid; // pinned user
  int? _localUid;
  List<ChatGroupRoom> groupChatUser = [];
  var meetingId = '';
  var userId = '';

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initAgora();
  }

  Future<void> _initAgora() async {
    if (MeetingService().currentUserId.isEmpty) {
      userId = generatePasscode();
    }
    model = await MeetingService().getHostId(name: widget.channelName);

    MeetingService().getChatGroupList(widget.channelName).listen((user) {
      if (mounted) {
        setState(() {
          groupChatUser = user;
        });
      }
    });

    if (model != null && model!.isNotEmpty) {
      _hostUid = model!.first.hostId;
      if (_hostUid != null) {
        var data = await AuthService().getUserDataById(
          model?.first.userId ?? '',
        );
        user = data;
        print('<<<<<<<< $user ????????');
      }
    }

    if (_hostUid != _localUid) {
      MeetingService().sendJoinRequest(
        widget.channelName,
        MeetingService().currentUserId,
      );
    }

    await [Permission.microphone, Permission.camera].request();

    // 2. Listen for host response
    if (_hostUid != _localUid) {
      MeetingService()
          .listenToMyRequest(widget.channelName, MeetingService().currentUserId)
          .listen((doc) async {
            if (doc.exists) {
              final data = doc.data() as Map<String, dynamic>;
              if (data['status'] == 'accepted') {
                await joinAgora();
              } else if (data['status'] == 'rejected') {
                if (mounted) {
                  Get.back();
                  Get.snackbar(
                    "Request Denied",
                    "Host rejected your request ❌",
                  );
                }
              }
            }
          });
    } else {
      await joinAgora();
    }
  }

  Future<void> joinAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
            _localUid = connection.localUid;
            if (_hostUid == null && _remoteUsers.isEmpty) {
              _hostUid = connection.localUid;
              // _localUid = connection.localUid;
              _remoteUsers.add(_hostUid!);
              if (model!.isEmpty) {
                MeetingService().startNewMeeting(
                  meetingName: widget.channelName,
                  hostId: connection.localUid!,
                  hostname: CommonVariable.userName.value,
                  userId: MessageService().currentUserId.toString(),
                );
              }
              print('${Preferences.meetingHostId}');
              print("🟢 First local user joined. Set as host (You)");
            }
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            if (!_remoteUsers.contains(remoteUid)) {
              _remoteUsers.add(remoteUid);
            }
          });
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              setState(() {
                _remoteUsers.remove(remoteUid);
                if (_hostUid == remoteUid) {
                  // reassign host
                  if (_remoteUsers.isNotEmpty) {
                    _hostUid = _remoteUsers.first;
                  } else if (_localUserJoined) {
                    _hostUid = 0;
                  } else {
                    _hostUid = null;
                  }
                  print("🔁 Host left. Reassigned host to $_hostUid");
                }
              });
            },
      ),
    );
    if (_hostUid == _localUid) {
      await MeetingService().generateGroup(widget.channelName);
    }

    await _engine.startPreview();

    String token = await generateToken(widget.channelName);
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
    if (model != null && model!.isNotEmpty) {
      await MeetingService().addMembersInfo(
        meetingName: widget.channelName,
        memberId: MeetingService().currentUserId.isNotEmpty
            ? MeetingService().currentUserId
            : userId,
        docId: model?.first.userId ?? '', // safe now
      );
    } else {
      print("❌ Model is empty or null");
    }

    setState(() {
      _videoOff = widget.videoOff;
      _muted = widget.audioOff;
      isInitialize = false;
    });
    print('INIT CAMERA IS ON OR OFF ${widget.videoOff} && $_videoOff');
    print('INIT CAMERA IS ON OR OFF ${widget.audioOff} && $_muted');
    _onToggleCamera();

    if (_localUid == _hostUid) {
      meetingId = generateMeetingId();
      MeetingService().scheduleNewMeeting(
        name: 'HELLO 001',
        duration: '1 Hours',
        channelName: widget.channelName,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(hours: 1)),
        meetingID: meetingId,
        ownerName: CommonVariable.userName.value,
        passcode: generatePasscode(),
      );
    }
  }

  Future<void> deleteMeeting() async {
    model = await MeetingService().getHostId(name: widget.channelName);
    print(
      '123456789101010101 ${model?.first.hostId} == $_hostUid.   &&  ${model?.isNotEmpty}  &&  ${model!.first.hostId == _localUid}',
    );
    if ((model?.isNotEmpty ?? false) && model!.first.hostId == _localUid) {
      print('DDDDDDDDĎ');
      MeetingService().deleteMeeting(meetingId: widget.channelName);
    }
  }

  List<int> getAllUids() {
    final uids = <int>[];
    if (_localUserJoined && _hostUid != _localUid) uids.add(0);
    uids.addAll(_remoteUsers);
    print('HELLO THIS IS FOR $uids');
    return uids;
  }

  Widget _buildAgoraView(int uid) {
    print('RE TT VV BB  $uid');
    return AgoraVideoView(
      controller: uid == 0
          ? VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            )
          : VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: uid),
              connection: RtcConnection(channelId: widget.channelName),
            ),
    );
  }

  Widget _buildVideoLayout() {
    if (!isInitialize) {
      print('<<<<<<<<<<<<<<<<<< $_hostUid  &&  $_localUid >>>>>>>>>>>>>>>>>>>');
      final allUids = getAllUids();
      if (allUids.isEmpty && _hostUid == null) {
        return Center(child: CircularProgressIndicator());
      }
      Uint8List? bytes = _localUid == _hostUid
          ? CommonVariable.userImage.value.isNotEmpty
                ? base64Decode(CommonVariable.userImage.value)
                : null
          : user?.image == null
          ? null
          : base64Decode(user!.image.toString());

      print('BB YY TT EE SS $bytes');
      final int pinnedUid = _hostUid ?? allUids.first;
      // print('🪰🕸️ MEMBERS LIST 🕸️🦋');
      print(allUids);
      final memberUids = allUids.where((uid) => uid != pinnedUid).toList();
      // print('👩‍❤️‍💋‍👨 MEMBERS LIST 🪰');
      print(memberUids);

      return Column(
        children: [
          // Pinned view
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    _buildAgoraView(_hostUid == _localUid ? 0 : pinnedUid),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          // blur intensity
                          child: Container(
                            width: commonWidth * 0.91,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: ConstColor.white.withValues(alpha: 0.3),
                              // semi-transparent white
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.sp,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          (bytes != null && bytes.isNotEmpty)
                                          ? MemoryImage(bytes)
                                          : null,
                                      child: (bytes == null || bytes.isEmpty)
                                          ? CommonTextWidget(
                                              title: _hostUid == _localUid
                                                  ? getUserInitials(
                                                      CommonVariable
                                                          .userName
                                                          .value,
                                                    )
                                                  : getUserInitials(
                                                      model!.first.hostName,
                                                    ),
                                              fontFamily: "RSB",
                                              fontSize: 16.sp,
                                              color: ConstColor.white,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 8.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget(
                                          title: _localUid == _hostUid
                                              ? 'You'
                                              : user?.username ?? '',
                                          fontFamily: "RB",
                                          color: ConstColor.darkGray,
                                        ),
                                        CommonTextWidget(
                                          title: 'Host',
                                          fontFamily: 'RM',
                                          color: ConstColor.darkGray.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 20.sp,
                                  backgroundColor: ConstColor.darkGray,
                                  child: CommonSvgView(
                                    iconPath: 'assets/icons/mic_1.svg',
                                    height: 20.w,
                                    width: 20.w,
                                    color: ConstColor.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (memberUids.length == 1)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      _buildAgoraView(memberUids.first),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: CircleAvatar(
                          radius: 20.sp,
                          backgroundColor: ConstColor.darkGray,
                          child: CommonSvgView(
                            iconPath: 'assets/icons/mic_1.svg',
                            height: 20.w,
                            width: 20.w,
                            color: ConstColor.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Thumbnail members
          if (memberUids.isNotEmpty &&
              memberUids.length != 1 &&
              !memberUids.contains(pinnedUid))
            SizedBox(
              height: 160.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: memberUids.length,
                itemBuilder: (context, index) {
                  final uid = memberUids[index];
                  return Container(
                    width: 120.w,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          _buildAgoraView(uid),
                          Positioned(
                            bottom: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                uid == 0 ? "You" : "User $uid",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    } else {
      return Container(
        alignment: Alignment.center,
        color: ConstColor.lightBlue,
        child: Column(
          children: [
            CommonTextWidget(
              title: 'Weboxcam',
              color: ConstColor.white,
              fontFamily: "RB",
              fontSize: 30.sp,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 200.h),
            CommonTextWidget(
              title: CommonVariable.userName.value,
              color: ConstColor.white,
              fontFamily: "RB",
              fontSize: 40.sp,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            CommonTextWidget(
              title: 'Personal Room Meeting',
              color: ConstColor.white,
              fontFamily: "RSB",
              fontSize: 30.sp,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            CommonTextWidget(
              title: 'Waiting for the host to start the meeting',
              color: ConstColor.white,
              fontFamily: "RSB",
              fontSize: 16.sp,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Image.asset('assets/animation/loader.gif', height: 100.h),
          ],
        ),
      );
    }
  }

  void endCall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColor.darkGray,
      builder: (context) {
        return Container(
          height: 200.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonContainer(
                onTap: _onEndCall,
                height: 60.h,
                containerColor: ConstColor.red,
                child: CommonTextWidget(
                  title: 'End Meeting'.tr,
                  fontSize: 16.sp,
                  fontFamily: "RM",
                  color: ConstColor.white,
                ),
              ),
              SizedBox(height: 8.h),
              CommonContainer(
                onTap: () => Get.back(),
                height: 60.h,
                containerColor: ConstColor.white.withValues(alpha: 0.1),
                child: CommonTextWidget(
                  title: 'Cancel'.tr,
                  fontSize: 16.sp,
                  fontFamily: "RM",
                  color: ConstColor.white,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void _onToggleMute() {
    setState(() => _muted = !_muted);
    print('MUTED IS FOLLOWING $_muted');
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleCamera() {
    setState(() => _videoOff = !_videoOff);
    _engine.muteLocalVideoStream(_videoOff);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onEndCall() {
    setState(() => meetingActive = false);
    if (model != null && model!.isNotEmpty) {
      MeetingService().deleteMember(
        meetingName: widget.channelName,
        memberId: MessageService().currentUserId,
        docId: model?.first.userId ?? '',
      );
    } else {
      print("❌ Model is empty or null");
    }

    _engine.leaveChannel();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    deleteMeeting();
    if (!isInitialize) {
      _engine.leaveChannel();
      _engine.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && meetingActive) {
          endCall(context);
        }
      },
      child: Scaffold(
        backgroundColor: !isInitialize ? Colors.black : ConstColor.lightBlue,
        appBar: AppBar(
          backgroundColor: !isInitialize ? Colors.black : ConstColor.lightBlue,
          toolbarHeight: 80.h,
          automaticallyImplyLeading: false,
          title: !isInitialize
              ? Row(
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      color: ConstColor.white,
                    ).paddingOnly(left: 10.sp),
                    SizedBox(width: 20.w),
                    CommonSvgView(
                      iconPath: "assets/icons/switch_camera.svg",
                      height: 32.h,
                      width: 32.h,
                      fit: BoxFit.cover,
                      onTap: _onSwitchCamera,
                    ),
                    SizedBox(width: 30.w),
                    CommonTextWidget(
                      title: 'Weboxcam',
                      color: ConstColor.lightBlue,
                      fontFamily: "RB",
                      fontSize: 25.sp,
                    ),
                    Spacer(),
                    CommonContainer(
                      onTap: () {
                        endCall(context);
                      },
                      height: 34.h,
                      width: 66.w,
                      radius: 10.r,
                      containerColor: ConstColor.red,
                      child: CommonTextWidget(
                        title: 'End',
                        fontSize: 14.sp,
                        fontFamily: "RM",
                        color: ConstColor.white,
                      ),
                    ),
                  ],
                )
              : CommonTextWidget(
                  title: 'Cancel'.tr,
                  color: ConstColor.white,
                  fontFamily: "RSB",
                  fontSize: 16.sp,
                  onTap: () {
                    endCall(context);
                  },
                ),
        ),
        body: Column(
          children: [
            Expanded(child: _buildVideoLayout()),
            if (!isInitialize)
              Container(
                height: 100.h,
                color: Color(0xff191919),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button(
                      'assets/icons/mic_1.svg',
                      _muted ? "Unmute" : '  Mute ',
                      _muted ? ConstColor.red : ConstColor.white,
                      _onToggleMute,
                    ),
                    button(
                      'assets/icons/mic_2.svg',
                      _videoOff ? 'Start Video' : 'Stop Video',
                      _videoOff ? ConstColor.red : ConstColor.white,
                      _onToggleCamera,
                    ),
                    button(
                      'assets/icons/mic_3.svg',
                      "Participants",
                      ConstColor.white,
                      () async {
                        participants(
                          context,
                          widget.channelName,
                          meetingId,
                          isHost: _hostUid == _localUid ? true : false,
                        );
                      },
                    ),
                    button(
                      'assets/icons/chat_message.svg',
                      "Chat",
                      ConstColor.white,
                      () {
                        chatBottomSheet(
                          context,
                          widget.channelName,
                          groupChatUser[0],
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget button(String iconPath, String title, Color c1, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonSvgView(
            iconPath: iconPath,
            height: 30.w,
            width: 30.w,
            color: c1,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5.h),
          CommonTextWidget(
            title: title,
            fontSize: 14.sp,
            fontFamily: "RR",
            color: c1,
          ),
        ],
      ),
    );
  }
}

void participants(
  BuildContext context,
  String channelName,
  String meetingId, {
  bool isHost = false,
}) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    backgroundColor: Colors.black,
    // isScrollControlled: false,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    StreamBuilder<List<UserModel>>(
                      stream: MeetingService().getMembersDataStream(
                        name: channelName,
                      ),
                      builder: (context, snapshot) {
                        final count = snapshot.hasData
                            ? snapshot.data!.length
                            : 0;
                        return CommonTextWidget(
                          title: 'Participants ($count)',
                          fontFamily: "RB",
                          fontSize: 20.sp,
                          color: ConstColor.white,
                        ).paddingSymmetric(vertical: 10.sp);
                      },
                    ),

                    Divider(color: ConstColor.white.withValues(alpha: 0.3)),

                    // 🔹 If host, show pending requests first
                    if (isHost)
                      StreamBuilder<List<UserModel>>(
                        stream: MeetingService().listenToJoinRequestsWithUser(
                          channelName,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return SizedBox();
                          }
                          final requests = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget(
                                title: 'Waiting Participants',
                                fontFamily: "RR",
                                fontSize: 12.sp,
                                color: ConstColor.white.withValues(alpha: 0.3),
                              ),
                              SizedBox(height: 10.h),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: requests.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 8.h),
                                itemBuilder: (context, index) {
                                  final user = requests[index];
                                  Uint8List? bytes =
                                      user.image != null &&
                                          user.image!.isNotEmpty
                                      ? base64Decode(user.image!)
                                      : null;
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 195.w,
                                          child: Row(
                                            children: [
                                              bytes == null
                                                  ? Container(
                                                      height: 45.w,
                                                      width: 45.w,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        color: ConstColor.white,
                                                      ),
                                                      child: CommonTextWidget(
                                                        title: getUserInitials(
                                                          user.username!,
                                                        ),
                                                        fontFamily: "RSB",
                                                        fontSize: 16.sp,
                                                        color: ConstColor
                                                            .lightBlue,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 45.w,
                                                      width: 45.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        image: DecorationImage(
                                                          image: MemoryImage(
                                                            bytes,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: CommonTextWidget(
                                                  title:
                                                      '${user.username}',
                                                  fontSize: 16.sp,
                                                  fontFamily: "RM",
                                                  color: ConstColor.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 15.w),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                MeetingService()
                                                    .respondToRequest(
                                                      meetingId: channelName,
                                                      userId: user.documentId
                                                          .toString(),
                                                      accept: false,
                                                    );
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 60.w,
                                                height: 30.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5.r,
                                                      ),
                                                  color: ConstColor.red,
                                                ),
                                                child: CommonTextWidget(
                                                  title: 'Cancel',
                                                  color: ConstColor.white,
                                                  fontFamily: "RR",
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            GestureDetector(
                                              onTap: () {
                                                MeetingService()
                                                    .respondToRequest(
                                                      meetingId: channelName,
                                                      userId: user.documentId
                                                          .toString(),
                                                      accept: true,
                                                    );
                                              },
                                              child: Container(
                                                height: 30.h,
                                                width: 60.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5.r,
                                                      ),
                                                  color: ConstColor.lightBlue,
                                                ),
                                                child: CommonTextWidget(
                                                  title: 'Accept',
                                                  color: ConstColor.white,
                                                  fontFamily: "RR",
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              if (requests.isNotEmpty)
                                Divider(
                                  color: ConstColor.white.withValues(
                                    alpha: 0.3,
                                  ),
                                ).paddingOnly(top: 15.sp),
                            ],
                          ).paddingSymmetric(horizontal: 15.sp, vertical: 5.sp);
                        },
                      ),

                    // 🔹 Show actual participants
                    StreamBuilder(
                      stream: MeetingService().getMembersDataStream(
                        name: channelName,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: CommonTextWidget(
                              title: 'NO PARTICIPANTS FOUND',
                            ),
                          );
                        }
                        List<UserModel> users = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            UserModel data = users[index];
                            Uint8List? bytes =
                                data.image != null && data.image!.isNotEmpty
                                ? base64Decode(data.image!)
                                : null;

                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      bytes == null
                                          ? Container(
                                              height: 45.w,
                                              width: 45.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color: ConstColor.white,
                                              ),
                                              child: CommonTextWidget(
                                                title: getUserInitials(
                                                  data.username!,
                                                ),
                                                fontFamily: "RSB",
                                                fontSize: 16.sp,
                                                color: ConstColor.lightBlue,
                                              ),
                                            )
                                          : Container(
                                              height: 45.w,
                                              width: 45.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                image: DecorationImage(
                                                  image: MemoryImage(bytes),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 10.w),
                                      CommonTextWidget(
                                        title: data.username!,
                                        fontSize: 16.sp,
                                        fontFamily: "RM",
                                        color: ConstColor.white,
                                      ),
                                      SizedBox(width: 5),
                                      if (index == 0)
                                        CommonTextWidget(
                                          title: '(Host)',
                                          fontSize: 16.sp,
                                          fontFamily: "RM",
                                          color: ConstColor.white,
                                        ),
                                    ],
                                  ),
                                  if (index != 0)
                                    CommonSvgView(
                                      iconPath: 'assets/icons/chat_message.svg',
                                      height: 30.w,
                                      width: 30.w,
                                      color: ConstColor.white.withValues(
                                        alpha: 0.45,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 13.h),
                          itemCount: users.length,
                        ).paddingSymmetric(horizontal: 15.sp, vertical: 15.sp);
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isHost)
              GestureDetector(
                onTap: () async {
                  var link = await createDynamicLink(
                    meetingId: meetingId,
                    action: 'invite',
                    docId: FirebaseAuth.instance.currentUser!.uid,
                  );
                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          'check out my website $link \n meeting id :- $channelName',
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.h,
                  width: commonWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: ConstColor.lightBlue,
                  ),
                  child: CommonTextWidget(
                    title: 'invite',
                    color: ConstColor.white,
                    fontSize: 18.sp,
                    fontFamily: "RSB",
                  ),
                ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
              ),
          ],
        ),
      );
    },
  );
}

void chatBottomSheet(
  BuildContext context,
  String channelName,
  ChatGroupRoom userData,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.black,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        child: MeetingChatSheet(groupRoom: userData, channelName: channelName),
      );
    },
  );
}

/// working

/*void participants(BuildContext context, String channelName) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    builder: (context) {
      return StreamBuilder(
        stream: MeetingService().getMembersDataStream(name: channelName),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.isEmpty) {
            return Center(
              child: CommonTextWidget(title: 'NO PARTICIPANTS FOUND'),
            );
          }
          List<UserModel> users = snapshot.data ?? [];
          return Column(
            children: [
              SizedBox(height: 10.h),
              CommonTextWidget(
                title: 'Participants (${users.length})',
                fontFamily: "RB",
                fontSize: 20.sp,
                color: ConstColor.white,
              ).paddingSymmetric(vertical: 10.sp),
              Divider(color: ConstColor.white.withValues(alpha: 0.3)),

              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    UserModel data = users[index];
                    Uint8List? bytes = data.image != null
                        ? base64Decode(data.image!)
                        : null;
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              data.image!.isEmpty
                                  ? Container(
                                height: 50.w,
                                width: 50.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5.r,
                                  ),
                                  color: ConstColor.white,
                                ),
                                child: CommonTextWidget(
                                  title: getUserInitials(
                                    CommonVariable.userName.value,
                                  ),
                                  fontFamily: "RSB",
                                  fontSize: 16.sp,
                                  color: ConstColor.lightBlue,
                                ),
                              )
                                  : Container(
                                height: 50.w,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5.r,
                                  ),
                                  image: DecorationImage(
                                    image: MemoryImage(bytes!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              CommonTextWidget(
                                title: data.username.toString(),
                                fontSize: 16.sp,
                                fontFamily: "RM",
                                color: ConstColor.white,
                              ),
                              SizedBox(width: 5),
                              if (index == 0)
                                CommonTextWidget(
                                  title: '(Host)',
                                  fontSize: 16.sp,
                                  fontFamily: "RM",
                                  color: ConstColor.white,
                                ),
                            ],
                          ),
                          if (index != 0)
                            CommonSvgView(
                              iconPath: 'assets/icons/chat_message.svg',
                              height: 30.w,
                              width: 30.w,
                              color: ConstColor.white.withValues(alpha: 0.45),
                              fit: BoxFit.cover,
                            ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 13.h),
                  itemCount: users.length,
                ).paddingSymmetric(horizontal: 15.sp, vertical: 15.sp),
              ),
            ],
          );
        },
      );
    },
  );
}*/

/*class VideoCallScreen extends StatefulWidget {
  final String channelName;

  const VideoCallScreen({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  final List<int> _remoteUsers = [];
  final List<int> _joinedUserOrder = [];
  bool _localUserJoined = false;
  bool _muted = false;
  bool _video = false;
  int? _hostUid; // Track the actual host UID
  bool _isFirstUserInChannel = false; // Track if local user is first

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _localUserJoined = true;
            print('JOINED SUCCESS FULLY  ${connection.channelId}');

          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            print('JOIN DATA IS $remoteUid');
            if (!_remoteUsers.contains(remoteUid)) {
              _remoteUsers.add(remoteUid);
            }
            print('LIST OF THE USER JOINED ::: $_remoteUsers');

          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUsers.remove(remoteUid);
            _joinedUserOrder.remove(remoteUid);
          });
        },
      ),
    );

    String token = await generateToken(widget.channelName);
    final allUsers = getAllUserUids();
    print('LIST OF JOINED USER $allUsers}');
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  List<int> getAllUserUids() {
    final List<int> uids = [];
    if (_localUserJoined) uids.add(0);
    uids.addAll(_remoteUsers);
    return uids;
  }

  List<int> getAllJoinedUsers() {
    return List.from(_joinedUserOrder);
  }

  Widget _buildAgoraView(int uid) {
    return AgoraVideoView(
      controller: uid == 0
          ? VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      )
          : VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: widget.channelName),
      ),
    );
  }

  Widget _buildVideoLayout() {
    final allUsers = getAllUserUids();

    if (allUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // The host is whoever joined first (stored in _hostUid)
    final hostUid = _hostUid;

    // If no specific host is set, use the first user in the joined order
    final actualHostUid = hostUid ?? allUsers.first;
    print('😇😃🫦 $hostUid');
    // print('😇😃🫦 ${allUsers[1]}');

    // Members are all users except the host
    final memberUids = allUsers.where((uid) => uid != actualHostUid).toList();

    return Column(
      children: [
        // HOST (Big video area)
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  _buildAgoraView(actualHostUid),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        actualHostUid == 0 ? "Host (You)" : "Host",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // MEMBERS (Small video area)
        if (memberUids.isNotEmpty)
          SizedBox(
            height: 150.w,
            child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: memberUids.length,
                  itemBuilder: (context, index) {
                    final uid = memberUids[index];
                    return Container(
                      width: MediaQuery.of(context).size.width / 3,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            _buildAgoraView(uid),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  uid == 0 ? "You" : "User $uid",
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),


          ),
      ],
    );
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onCallEnd() {
    _engine.leaveChannel();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void endCall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColor.darkGray,
      builder: (context) {
        return Container(
          height: 200.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonContainer(
                onTap: _onCallEnd,
                height: 60.h,
                containerColor: ConstColor.red,
                child: CommonTextWidget(title: 'End Meeting'.tr, fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
              ),
              SizedBox(height: 8.h),
              CommonContainer(
                onTap: () => Get.back(),
                height: 60.h,
                containerColor: ConstColor.white.withValues(alpha: 0.1),
                child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void _onCameraMute() {
    setState(() {
      _video = !_video;
    });
    _engine.muteLocalVideoStream(_video);
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.arrow_back_rounded, color: ConstColor.white).paddingOnly(left: 10.sp),
            SizedBox(width: 20.w),
            CommonSvgView(iconPath: "assets/icons/switch_camera.svg", height: 32.h, width: 32.h, fit: BoxFit.cover, onTap: _onSwitchCamera),
            SizedBox(width: 30.w),
            CommonTextWidget(title: 'Weboxcam', color: ConstColor.lightBlue, fontFamily: "RB", fontSize: 25.sp),
            Spacer(),
            CommonContainer(
              onTap: () {
                endCall(context);
              },
              height: 34.h,
              width: 66.w,
              radius: 10.r,
              containerColor: ConstColor.red,
              child: CommonTextWidget(title: 'End', fontSize: 14.sp, fontFamily: "RM", color: ConstColor.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildVideoLayout()),
          SizedBox(height: 10.h),
          Container(
            height: 100.h,
            color: Color(0xff191919),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button('assets/icons/mic_1.svg', _muted ? "Unmute" : ' Mute ', _muted ? ConstColor.red : ConstColor.white, _onToggleMute),
                button(
                  'assets/icons/mic_2.svg',
                  _video ? 'Start Video' : 'Stop Video',
                  _video ? ConstColor.red : ConstColor.white,
                  _onCameraMute,
                ),
                button('assets/icons/mic_3.svg', "Participants", ConstColor.white, () {}),
                button('assets/icons/chat_message.svg', "Chat", ConstColor.white, () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget button(String iconPath, String title, Color c1, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonSvgView(iconPath: iconPath, height: 30.w, width: 30.w, color: c1, fit: BoxFit.cover),
          SizedBox(height: 5.h),
          CommonTextWidget(title: title, fontSize: 14.sp, fontFamily: "RR", color: c1),
        ],
      ),
    );
  }
}*/

/*class VideoCallScreen extends StatefulWidget {
  final String channelName;

  const VideoCallScreen({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  final List<int> _remoteUsers = [];
  final List<int> _joinedUserOrder = [];
  bool _localUserJoined = false;
  bool _muted = false;
  bool _video = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _localUserJoined = true;
            if (!_joinedUserOrder.contains(0)) {
              _joinedUserOrder.add(0); // Add self (UID 0) to joined order
            }
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            if (!_remoteUsers.contains(remoteUid)) {
              _remoteUsers.add(remoteUid);
            }
            if (!_joinedUserOrder.contains(remoteUid)) {
              _joinedUserOrder.add(remoteUid);
            }
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUsers.remove(remoteUid);
          });
        },
      ),
    );

    String token = await generateToken(widget.channelName);
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  List<int> getAllUserUids() {
    final List<int> uids = [];
    if (_localUserJoined) uids.add(0);
    uids.addAll(_remoteUsers);
    return uids;
  }


  List<int> getAllJoinedUsers() {
    return List.from(_joinedUserOrder); // real join order: host first
  }

  Widget _buildAgoraView(int uid) {
    return AgoraVideoView(
      controller: uid == 0
          ? VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      )
          : VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: widget.channelName),
      ),
    );
  }

  Widget _buildVideoLayout() {
    final allUsers = getAllJoinedUsers();

    if (allUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final hostUid = allUsers.first;
    final memberUids = allUsers.skip(1).toList();

    return Column(
      children: [
        // HOST
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  _buildAgoraView(hostUid),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("Host", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // MEMBERS
        if (memberUids.isNotEmpty)
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: memberUids.length,
              itemBuilder: (context, index) {
                final uid = memberUids[index];
                return Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        _buildAgoraView(uid),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text("User $uid", style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onCallEnd() {
    _engine.leaveChannel();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }
  void endCall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColor.darkGray,
      builder: (context) {
        return Container(
          height: 200.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonContainer(
                onTap: _onCallEnd,
                height: 60.h,
                containerColor: ConstColor.red,
                child: CommonTextWidget(title: 'End Meeting'.tr, fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
              ),
              SizedBox(height: 8.h),
              CommonContainer(
                onTap: () => Get.back(),
                height: 60.h,
                containerColor: ConstColor.white.withValues(alpha: 0.1),
                child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void _onCameraMute() {
    setState(() {
      _video=!_video;
    });
    _engine.muteLocalVideoStream(_video);
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.arrow_back_rounded, color: ConstColor.white).paddingOnly(left: 10.sp),
            SizedBox(width: 20.w),
            CommonSvgView(iconPath: "assets/icons/switch_camera.svg", height: 32.h, width: 32.h, fit: BoxFit.cover,onTap: _onSwitchCamera,),
            SizedBox(width: 30.w),
            CommonTextWidget(title: 'Weboxcam', color: ConstColor.lightBlue, fontFamily: "RB", fontSize: 25.sp),
            Spacer(),
            CommonContainer(
              onTap: () {
                endCall(context);
              },
              height: 34.h,
              width: 66.w,
              radius: 10.r,
              containerColor: ConstColor.red,
              child: CommonTextWidget(title: 'End', fontSize: 14.sp, fontFamily: "RM", color: ConstColor.white),
            ),
          ],
        ),
      ),
      body:
          Column(
            children: [
              Expanded(child: _buildVideoLayout()),
              SizedBox(height: 10.h),
              Container(
                height: 100.h,
                color: Color(0xff191919),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    button('assets/icons/mic_1.svg',  _muted ? "Unmute" : ' Mute ', _muted ?  ConstColor.red : ConstColor.white, _onToggleMute),
                    button(
                      'assets/icons/mic_2.svg',
                      _video ? 'Start Video' : 'Stop Video',
                      _video ? ConstColor.red : ConstColor.white,
                      _onCameraMute,
                    ),
                    button('assets/icons/mic_3.svg', "Participants", ConstColor.white,(){}),
                    button('assets/icons/chat_message.svg', "Chat", ConstColor.white, () {}),
                  ],
                ),
              )
            ],
          ),


    );
  }
  Widget button(String iconPath, String title, Color c1, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonSvgView(iconPath: iconPath, height: 30.w, width: 30.w, color: c1, fit: BoxFit.cover),
          SizedBox(height: 5.h),
          CommonTextWidget(title: title, fontSize: 14.sp, fontFamily: "RR", color: c1),
        ],
      ),
    );
  }
}*/

/*Widget _buildVideoGrid() {
    List<int> allUsers = getAllUserUids();

    if (allUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: allUsers.length <= 2 ? 1 : 2,
        childAspectRatio:allUsers.length <= 2 ? 1.3 : 1,
      ),
      itemCount: allUsers.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildAgoraView(allUsers[index]),
          ),
        );
      },
    );
  }*/
