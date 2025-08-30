import 'common_import.dart';

abstract class ConstColor {
  static Color get blue => Color(0xff5C66BD);

  static Color get lightBlue => Color(0xff567DFF);

  static Color get white => Color(0xffFFFFFF);

  static Color get darkGray => Color(0xff121212);

  static Color get midGray => Color(0xff1A1A1A);

  static Color get neroGray => Color(0xff191919);

  static Color get eerieBlack => Color(0xff1E1E1E);

  static Color get lightGray => Color(0xffF5F5F5);

  static Color get red => Color(0xffDC3545);
}

class CommonVariable {
  static RxBool isDark = RxBool(false);
  static RxInt themeMode = RxInt(Preferences.themeMode);
  static RxString userName = RxString("");
  static RxString userEmail = RxString("");
  static RxString userMobile = RxString("");
  static RxString userLocation = RxString("");
  static RxString userJobTile = RxString("");
  static RxString userImage = RxString("");
  static RxString personalMeetingId = RxString("");
  static RxString pushToken = RxString("");
}

class GoogleAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);

  Future<User?> signUp() async {
    try {
      final signInUser = await googleSignIn.signIn();
      if (signInUser == null) return null;
      final googleAuth = await signInUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
