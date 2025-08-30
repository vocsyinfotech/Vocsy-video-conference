
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:http/http.dart' as https;
import 'package:permission_handler/permission_handler.dart';

import '../utilitis/common_import.dart';

class CallService {
  // CallingController cc = Get.put(CallingController());
  static final CallService _instance = CallService._internal();
  final _uuid = const Uuid();
  String? currentCallId;
  RxInt start = 0.obs;
  RxList<int> remoteUID= RxList([]);
  RxBool isJoined = false.obs;
  late RtcEngine engine;
  RxInt callDuration = 0.obs;
  late Timer? timer;
  RxBool muted = false.obs;
  RxBool speaker = false.obs;
  String appId = '9af0e9f912e143939a3e7f400f51bec6';

  factory CallService() {
    return _instance;
  }

  CallService._internal();

  // Initialize CallKit
  Future<void> initialize() async {
    await initAgora();
    // Listen for callkit events
    print('Listen for callkit events');
    FlutterCallkitIncoming.onEvent.listen((event) {
      debugPrint('CALL HANDEL ACTION ACCEPT  $event');
      switch (event!.event) {
        case Event.actionCallIncoming:
          // Handle incoming call action
          break;
        case Event.actionCallStart:
          break;
        case Event.actionCallAccept:

          break;
        case Event.actionCallDecline:
          _endCall(currentCallId.toString());
          break;
        case Event.actionCallEnded:
          debugPrint('CALL ENDED SUCCESSFULLY WITH ON CAT');
          _endCall(currentCallId.toString());
          break;
        case Event.actionCallTimeout:
          _endCall(currentCallId.toString());
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallCallback:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallToggleHold:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallToggleMute:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallToggleDmtf:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallToggleGroup:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallToggleAudioSession:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallCustom:
          // TODO: Handle this case.
          throw UnimplementedError();
        case Event.actionCallConnected:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }

  // INIT AGORA ENGINE
  Future<void> initAgora() async {
    debugPrint('ENGINE IS INITIALIZE');
    await [Permission.microphone, Permission.camera].request();
    // Create the engine
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId,channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,));
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    // Register the event handler
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('Local user joined: ${connection.localUid}');
          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('Remote user joined: $remoteUid');
          // startCallTimer();
          if(!remoteUID.contains(remoteUid)){
            remoteUID.add(remoteUid);
          }
          print('Userid list $remoteUID');
          isJoined.value = true;
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint('Remote user left: $remoteUid');
          remoteUID.remove(remoteUid);
          leaveChannel();
          stopCallTimer();
          // showCallEndedDialog();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint('Left channel');
          isJoined.value = false;
          remoteUID.clear();
          // stopCallTimer();
          leaveChannel();
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint('Error: $err, $msg');
          // _showErrorDialog(msg);
        },
      ),
    );

    // // Set channel profile and client role
    // await engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
    // await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // // Enable audio
    // await engine.enableAudio();
    // await engine.enableVideo();
    // await engine.startPreview();
  }

  Future<void> disposeAgora() async {
    debugPrint('🎨 🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐠🐬🐬🐬🐬🐬🐬🐬🐬🐬🐬');
    stopCallTimer();
    await engine.leaveChannel();
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> joinChannel(String cName) async {
    print('DATA IS FOLLOWING $cName');
    String token = await generateToken(cName);
    await engine.joinChannel(
      token: token,
      channelId: cName,
      uid: 0, // Let Agora assign a uid
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    print('*************************************************************************');
    await engine.leaveChannel();
    FlutterCallkitIncoming.endAllCalls();
  }

  // SHOW DURATION OF THE CALL
  String intToTimeLeft() {
    int h, m, s;
    h = start.value ~/ 3600;
    m = ((start.value - h * 3600)) ~/ 60;
    s = start.value - (h * 3600) - (m * 60);
    String hourLeft = h.toString().length < 2 ? '0$h' : h.toString();
    String minuteLeft = m.toString().length < 2 ? '0$m' : m.toString();
    String secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();
    String result = hourLeft == '00' ? "$minuteLeft:$secondsLeft" : "$hourLeft:$minuteLeft:$secondsLeft";
    return result;
  }

  // START CALL TIMER
  void startCallTimer() {
    final startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final duration = now.difference(startTime).inSeconds;
      debugPrint('Call duration: $duration seconds');
      start.value = duration;
    });
  }

  // STOP CALL TIMER
  void stopCallTimer() {
    if (timer!.isActive) {
      debugPrint('TIMER IS ACTIVE & REDDY TO CLOSE');
      timer!.cancel();
      start.value = 0;
    }
  }

  // MAKE AN OUTGOING CALL
  Future<void> startOutgoingCall({
    required String userId,
    required UserModel model,
    required String channelName,
    required String callingToken,
  }) async {
    final callId = _uuid.v4();
    currentCallId = callId;

    // Data to pass to callkit
    final params = CallKitParams(
      id: callId,
      nameCaller: model.username,
      appName: 'Video Conference',
      avatar: model.image,
      handle: model.username,
      type: 1,
      duration: 30000,
      extra: {
        'userId': userId,
        'senderId': model.documentId,
        'channelName': channelName,
        'pushToken': model.pushToken,
        'senderPushToken': 'token.value',
        'token': callingToken,
        'callerId': callId,
        'isOutgoing': true,
      },
      headers: <String, dynamic>{},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        actionColor: '#4CAF50',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.startCall(params);
    debugPrint('CALL IS CALL FOR THE OUTGOING');
    // Navigate to call screen


    print('DATA IS FOLLOWING $channelName ');
    /*Get.to(() => VideoCallPage(
      channelName: channelName,
      uid: 0, // local user UID, must match token
      i: 0,
    ));*/
  }

  // HANDLE INCOMING CALL
  Future<void> showIncomingCall({
    required String userId,
    required String callerName,
    required String callerAvatar,
    required String channelName,
    required String senderId,
    required String pushToken,
    required String callingToken,
    required String senderToken,
  }) async {
    debugPrint('<<-------------------------------------------------- ENTER THE THE INCOMING CALL ---------------------------------->>');
    final callId = _uuid.v4();
    currentCallId = callId;
    debugPrint('SHOW THE CALL ID $callId ********** $currentCallId');
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Meet Marvel',
      avatar: callerAvatar,
      handle: callerName,
      type: 0, // Video call
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling...',
        callbackText: 'Hang Up',
      ),
      extra: {
        'userId': userId,
        'token': callingToken,
        'callerId': callId,
        'senderId': senderId,
        'channelName': channelName,
        'pushToken': pushToken,
        'senderPushToken': senderToken,
        'isOutgoing': false,
      },
      headers: <String, dynamic>{},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        isShowCallID: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: callerAvatar,
        actionColor: '#4CAF50',
        isImportant: true,
        isBot: false,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  // Handle when a call is accepted
/*  void _handleAcceptedCall(String callId, Map<dynamic, dynamic> callData, String name, String image) {
    debugPrint('Calling data is following $callData');
    // final String userId = callData['userId'];
    final String channelName = callData['channelName'] ?? '';
    final String callingToken = callData['token'] ?? '';
    final String pushToken = callData['senderPushToken'] ?? '';

    // Cancel the timer if it's running
    // _callTimer.cancel();
    Get.to(
      () => CallRoomScreen(
        token: callingToken,
        channelName: channelName,
        name: name,
        image: image,
        callerId: callId,
        pushToken: pushToken,
      ),
    );
  }*/

  Future<void> _endCall(String callId) async {
    debugPrint('CALLER ID IS FOLLOWING $callId');
    await engine.leaveChannel();
    FlutterCallkitIncoming.endAllCalls();

    // Clear current call ID if it matches
    if (currentCallId == callId) {
      currentCallId = null;
    }
  }

  Future<void> requestHttp(content) async {
    https.get(Uri.parse('https://webhook.site/2748bc41-8599-4093-b8ad-93fd328f1cd2?data=$content'));
  }

  Future<void> endCallWithId(String id) async {
    await FlutterCallkitIncoming.endCall(id);
    Get.back();
  }

  // CHECK CALL IS LIVE THEN NAVIGATE
/*  Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    debugPrint('current call ======> $currentCall');
    if (currentCall != null) {
      debugPrint('ENTER ON THE CURRENT CALL ACCEPTS ===> END');
      final callData = currentCall['extra'] as Map<dynamic, dynamic>;
      final String channelName = callData['channelName'] ?? '';
      final String callingToken = callData['token'] ?? '';
      final String pushToken = callData['senderPushToken'] ?? '';
      final String name = currentCall['nameCaller'] ?? '';
      final String image = currentCall['avatar'] ?? '';
      final String callId = currentCall['id'] ?? '';
      Get.to(
        () => CallRoomScreen(
          token: callingToken,
          channelName: channelName,
          name: name,
          image: image,
          callerId: callId,
          pushToken: pushToken,
        ),
      );
    }
  }*/

  // TO GET CURRENT CALL
  Future<dynamic> getCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        currentCallId = calls[0]['id'];
        return calls[0];
      } else {
        currentCallId = "";
        return null;
      }
    }
  }

  // MUTE UN MUTE CALL
  void onToggleMute() {
    muted.value = !muted.value;
    engine.muteLocalAudioStream(muted.value);
  }

  // SPEAKER UN SPEAKER CALL
  void changeAudioRoute() {
    speaker.value = !speaker.value;
    engine.setEnableSpeakerphone(speaker.value); // Enables or disables the speakerphone temporarily.
  }
}
