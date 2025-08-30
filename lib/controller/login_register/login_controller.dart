import 'package:video_conforance/utilitis/common_import.dart';

class LoginController extends GetxController {
  final RxBool isHidePass = RxBool(false);
  final RxBool isValidPass = RxBool(false);
  final RxBool isFillData = RxBool(false);
  final RxString errorText = RxString("");
  final emailController = TextEditingController().obs;
  final passController = TextEditingController(text: 'Pass1234').obs;

  // FILL DATA
  void checkFillData() {
    if (emailController.value.text.isNotEmpty &&
        passController.value.text.isNotEmpty) {
      isFillData.value = true;
    } else {
      isFillData.value = false;
    }
    if (isValidPassword(passController.value.text)) {
      isValidPass.value = true;
    } else {
      isValidPass.value = false;
    }
  }

  // GOOGLE LOGIN
  Future<void> googleLogin() async {
    await AuthService().signInWithGoogle().then((user) {
      if (user != null) {
        Preferences.isLogin = true;
        customSnackBar('Success', 'Login Successfully');
        AuthService().setKeyValue(
          key: 'pushToken',
          value: CommonVariable.pushToken.value,
        );
        AuthService().setKeyValue(
          key: 'isShowNotification',
          value: Preferences.isShowNotification,
        );
        Get.offAll(() => BottomScreen());
      }
    });
  }

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  // CHECK LOGIN
  void login() {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailController.value.text.isEmpty) {
      customSnackBar('Alert', 'Email is required');
    } else if (!regex.hasMatch(emailController.value.text)) {
      customSnackBar('Alert', 'Enter a valid email address');
    } else if (passController.value.text.isEmpty) {
      customSnackBar('Alert', 'Password is required');
    } else {
      loginWithEmailPassword();
    }
  }

  // LOGIN WITH EMAIL & PASSWORD
  Future<void> loginWithEmailPassword() async {
    showLoadingDialog(Get.context!);
    if (emailController.value.text.isNotEmpty &&
        passController.value.text.isNotEmpty) {
      Preferences.userPassword = stringToHex(passController.value.text);
      try {
        await AuthService()
            .signInWithEmail(
              emailController.value.text,
              passController.value.text,
            )
            .then((user) {
              if (user != null) {
                Preferences.isLogin = true;
                customSnackBar('Success', 'Login Successfully');
                AuthService().setKeyValue(
                  key: 'pushToken',
                  value: CommonVariable.pushToken.value,
                );
                AuthService().setKeyValue(
                  key: 'isShowNotification',
                  value: Preferences.isShowNotification,
                );
                Get.offAll(() => BottomScreen());
              }
            });
      } catch (e) {
        print('ERROR IN TO THE LOGIN $e');
      }
    }
    Get.back();
  }
}
