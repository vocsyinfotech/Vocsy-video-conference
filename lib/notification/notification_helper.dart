import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:video_conforance/firebase_options.dart';
import 'package:video_conforance/utilitis/common_import.dart';

/// BACKGROUND NOTIFICATION
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // print('MESSAGE IS $message');
  if (message.notification != null && Preferences.isShowNotification) {
    print('NOTIFICATION NNN NNN MMMM KK   ${message.data['type']}');
    print('Message ----- $message');
    await showNotificationFromMessage(message);
    if (message.data.isNotEmpty) {
      print('PAYLOAD OF THE NOTIFICATION : ${message.data}');
    }
  } else {
    print('MESSAGE NOTIFICATION IS NULL');
  }
  // }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final FirebaseMessaging messaging = FirebaseMessaging.instance;
const String channelId = 'video_conformance_channel'; // Your channel ID
const String channelName = 'Video Conformance Notifications';

Future<void> initializeNotifications() async {
  requestNotificationPermission();

  const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings iOSSettings = const DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: true,
    defaultPresentAlert: false,
    defaultPresentBadge: false,
    defaultPresentBanner: true,
    defaultPresentList: false,
    defaultPresentSound: true,
    requestCriticalPermission: false,
    requestProvisionalPermission: false /*onDidReceiveLocalNotification: ondidReceive*/,
  );
  await messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Notification clicked with payload: ${response.payload}');
    },
    // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // HANDEL FOREGROUND MESSAGE
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // print('MESSAGE IS $message && ${Preferences.isShowNotification}');
    if (message.notification != null && Preferences.isShowNotification) {
      // print('NOTIFICATION NNN NNN MMMM KK   ${message.data['type']}');
      // print('Message ----- $message');
      await showNotificationFromMessage(message);
      if (message.data.isNotEmpty) {
        print('PAYLOAD OF THE NOTIFICATION : ${message.data}');
      }
    } else {
      print('OPEN APP MESSAGE NOTIFICATION IS NULL');
    }
    // }
  });

  // HANDLE BACK MESSAGE
  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  print('------------------------------------- 777777777777777777777777777 ---------------------------------------------');
  if (message != null) {
    print('------------------------------------- ${message.data} ---------------------------------------------');
  }

  NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {}

  // HANDLE BACKGROUND MESSAGE
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// SHOW NOTIFICATION MESSAGE
Future<void> showNotificationFromMessage(RemoteMessage message) async {
  print('NOTIFICATION ON OFF IS -----${Preferences.isShowNotification}');
  if (Preferences.isShowNotification) {
    var payload = message.data;
    var data = message.notification!;
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(0, data.title, data.body, platformDetails, payload: payload.toString());
  }
}

// BACKGROUND MESSAGE HANDLE METHOD
/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background Notification $message');
  await Firebase.initializeApp();
}*/

// GET FCM TOKEN
Future<void> getToken() async {
  await messaging.getToken() ?? '';
}

// CLOSE PENDING NOTIFICATION
Future<void> closeNotification() async {
  print("cancel Notification -------->");
  await flutterLocalNotificationsPlugin.cancelAll();
}

// CANCEL ALL NOTIFICATION
Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
  print('Close all the pending notification');
}

// TO GET NOTIFICATION PERMISSION
Future<void> requestNotificationPermission() async {
  if (Platform.isIOS) {
    print('Device is Ios');
    var permission = await Permission.notification.request();
    print('$permission Ios');
    if (permission.isGranted) {
      print('Permission is granted');
    }
  } else {
    PermissionStatus status = await Permission.notification.status;
    print('Statue---> $status');
    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus = await Permission.notification.request();
      if (newStatus.isGranted) {
        Preferences.isShowNotification = true;
        print('Notification permission granted.');
      } else {
        if (status.isGranted) {
          Preferences.isShowNotification = true;
          print('Notification permission granted.');
        } else {
          print('Notification permission denied.');
        }
      }
    } else {
      print('Notification permission already granted.');
    }
  }
}

// CLASS
class Receive {
  Receive({required this.id, required this.title, required this.body, required this.payload});

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

// SCHEDULE NOTIFICATION
Future<void> zonedScheduleNotification(tz.TZDateTime scheduledDate, String name, String title, String py) async {
  print('HELLO SCHEDULE NOTIFICATION $scheduledDate');
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
  await flutterLocalNotificationsPlugin.zonedSchedule(
    UniqueKey().hashCode,
    name,
    title,
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        visibility: NotificationVisibility.public,
        enableVibration: true,
      ),
      iOS: iosDetails,
    ),
    androidScheduleMode: AndroidScheduleMode.alarmClock,
    // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    payload: py,
  );
}

// TO CALL
/*void handleIncomingCall(Map<String, dynamic> data) async {
  print('MAP DATA IS FOLLOWING ::-  $data');
  final channelName = data['channelName'];
  final callingToken = data['token'] ?? 'dgtrdhyfdhgdfg';
  final callerName = data['callerName'] ?? 'KKKKKK';
  final callerAvatar = data['callerAvatar'] ?? '';
  final senderId = data['senderId'] ?? '';
  final pushToken = data['pushToken'] ?? '';
  final senderPushToken = data['senderPushToken'] ?? '';

  // Show incoming call UI using CallKit
  CallService().showIncomingCall(
    userId: userId.toString(),
    callerName: callerName,
    callerAvatar: callerAvatar,
    channelName: channelName,
    callingToken: callingToken,
    senderId: senderId,
    pushToken: pushToken,
    senderToken: senderPushToken,
  );
}*/
