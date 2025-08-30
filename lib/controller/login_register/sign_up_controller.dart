import 'dart:io';

import 'package:video_conforance/utilitis/common_import.dart';

class SignUpController extends GetxController {
  var emailController = TextEditingController().obs;
  final RxBool isEmailIsNotEmpty = RxBool(false);
  final RxBool isFillAllData = RxBool(false);
  final RxString fillDataErrorText = RxString("");
  final RxBool isHidePass = RxBool(false);
  final RxBool isValidPass = RxBool(false);
  final RxString errorText = RxString("");
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final fillDataPasswordController = TextEditingController().obs;

  // TACK NOTIFICATION PERMISSION
  Future<void> requestNotificationPermission() async {
    if (Platform.isIOS) {
      debugPrint('Device is Ios');
      var permission = await Permission.notification.request();
      debugPrint('$permission Ios');
      if (permission.isGranted) {
        Preferences.isShowNotification = true;
        debugPrint('Permission is granted');
      }
    } else {
      PermissionStatus status = await Permission.notification.status;
      debugPrint('Statue---> $status');
      if (status.isDenied || status.isPermanentlyDenied) {
        PermissionStatus newStatus = await Permission.notification.request();
        if (newStatus.isGranted) {
          Preferences.isShowNotification = true;
          debugPrint('Notification permission granted.');
        } else {
          if (status.isGranted) {
            Preferences.isShowNotification = true;
            debugPrint('Notification permission granted.');
          } else {
            debugPrint('Notification permission denied.');
          }
        }
      } else {
        debugPrint('Notification permission already granted.');
      }
    }
  }

  // EMAIL CHECK VALIDATION
  void checkEmail() {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailController.value.text.isEmpty) {
      customSnackBar('Error', 'Please enter email address');
    } else if (!regex.hasMatch(emailController.value.text)) {
      customSnackBar('Error', 'Enter a valid email address');
    } else {
      Preferences.userEmail = emailController.value.text;
      Get.to(() => FillDataScreen());
    }
  }

  // PASSWORD REGEX
  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void checkPasswordIsValid() {
    if (isValidPassword(fillDataPasswordController.value.text)) {
      isValidPass.value = true;
    } else {
      isValidPass.value = false;
    }
    checkFillData();
  }

  void checkFillData() {
    if (firstNameController.value.text.isNotEmpty && lastNameController.value.text.isNotEmpty && fillDataPasswordController.value.text.isNotEmpty) {
      isFillAllData.value = true;
    } else {
      isFillAllData.value = false;
    }
  }

  void confirmValidation() {
    showLoadingDialog(Get.context!);
    if (firstNameController.value.text.isEmpty) {
      customSnackBar('Alert', 'First name is required');
    } else if (lastNameController.value.text.isEmpty) {
      customSnackBar('Alert', 'Last name is required');
    } else if (fillDataPasswordController.value.text.isEmpty) {
      customSnackBar('Alert', 'Password is required');
    } else if (!isValidPassword(fillDataPasswordController.value.text)) {
      customSnackBar('Alert', 'Enter the valid password');
    } else {
      try {
        Preferences.userPassword = stringToHex(fillDataPasswordController.value.text);
        AuthService()
            .signUpWithEmail(
              Preferences.userEmail,
              fillDataPasswordController.value.text,
              '${firstNameController.value.text} ${lastNameController.value.text}',
            )
            .then((user) {
              if (user != null) {
                Preferences.isSignUp = true;
                customSnackBar('Success', 'Register successfully');
                AuthService().setKeyValue(key: 'pushToken', value: CommonVariable.pushToken.value);
                AuthService().setKeyValue(key: 'isShowNotification', value: Preferences.isShowNotification);
                if (Preferences.isTackPermission) {
                  Preferences.isLogin = true;
                  Get.offAll(() => BottomScreen());
                } else {
                  Get.offAll(() => NotificationPermissionScreen());
                }
              }
            });
      } catch (e) {
        print('Error is :::$e');
        Get.back();
      }
    }
    Get.back();
  }
}
