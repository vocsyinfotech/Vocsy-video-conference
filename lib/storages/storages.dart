import 'package:video_conforance/utilitis/common_import.dart';

class Preferences {
  static Future<SharedPreferences> get _instance async => _prefInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefInstance;
  static Future<SharedPreferences?> init() async {
    _prefInstance = await _instance;
    return _prefInstance;
  }

  static Future<void> clear() async {
    await _prefInstance?.clear();
  }

  static int get themeMode => _prefInstance?.getInt('themeMode') ?? 0;
  static set themeMode(int value) {
    _prefInstance?.setInt('themeMode', value);
  }

  static String get languageCode => _prefInstance?.getString('languageCode') ?? "en";
  static set languageCode(String value) {
    _prefInstance?.setString('languageCode', value);
  }

  static bool get isShowBoarding => _prefInstance?.getBool('isShowBoarding') ?? false;
  static set isShowBoarding(bool value) {
    _prefInstance?.setBool('isShowBoarding', value);
  }

  static bool get isLogin => _prefInstance?.getBool('isLogin') ?? false;
  static set isLogin(bool value) {
    _prefInstance?.setBool('isLogin', value);
  }

  static bool get isSignUp => _prefInstance?.getBool('isSignUp') ?? false;
  static set isSignUp(bool value) {
    _prefInstance?.setBool('isSignUp', value);
  }

  static bool get isTackPermission => _prefInstance?.getBool('isTackPermission') ?? false;
  static set isTackPermission(bool value) {
    _prefInstance?.setBool('isTackPermission', value);
  }

  static String get userEmail => _prefInstance?.getString('userEmail') ?? '';
  static set userEmail(String value) {
    _prefInstance?.setString('userEmail', value);
  }

  static String get userName => _prefInstance?.getString('userName') ?? '';
  static set userName(String value) {
    _prefInstance?.setString('userName', value);
  }

  static String get userPassword => _prefInstance?.getString('userPassword') ?? '';
  static set userPassword(String value) {
    _prefInstance?.setString('userPassword', value);
  }

  static bool get isShowNotification => _prefInstance?.getBool('isShowNotification') ?? false;
  static set isShowNotification(bool value) {
    _prefInstance?.setBool('isShowNotification', value);
  }

  static int get meetingHostId => _prefInstance?.getInt('meetingHostId') ?? 0;
  static set meetingHostId(int value) {
    _prefInstance?.setInt('meetingHostId', value);
  }
  //
  // static String get fcmToken => _prefInstance?.getString('fcmToken') ?? '';
  // static set fcmToken(String value) {
  //   _prefInstance?.setString('fcmToken', value);
  // }
  //
  // static String get messageSenderId => _prefInstance?.getString('messageSenderId') ?? '';
  // static set messageSenderId(String value) {
  //   _prefInstance?.setString('messageSenderId', value);
  // }
  //
  // static bool get isNotification => _prefInstance?.getBool('isNotification') ?? false;
  // static set isNotification(bool value) {
  //   _prefInstance?.setBool('isNotification', value);
  // }
}
