import 'package:video_conforance/utilitis/common_import.dart';

class ProfileController extends GetxController {
  var displayFirstNameController = TextEditingController().obs;
  var displayLastNameController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var locationController = TextEditingController().obs;
  var jobTitleController = TextEditingController().obs;
  var currentPasswordController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  RxString fullName = RxString("");
  RxString mobile = RxString("");
  RxString location = RxString("");
  RxString jobTitle = RxString("");
  RxString imageBase64 = RxString("");
  RxBool isFillPhone = RxBool(false);
  RxBool isFillLocation = RxBool(false);
  RxBool isFillJobTitle = RxBool(false);

  @override
  void onInit() {
    displayFirstNameController.value.text = CommonVariable.userName.value.split(' ').first.toString();
    displayLastNameController.value.text = CommonVariable.userName.value.split(' ')[1].toString();
    jobTitleController.value.text = CommonVariable.userJobTile.value;
    phoneController.value.text = CommonVariable.userMobile.value;
    fullName.value = CommonVariable.userName.value;
    mobile.value = CommonVariable.userMobile.value;
    location.value = CommonVariable.userLocation.value;
    jobTitle.value = CommonVariable.userJobTile.value;
    jobTitle.value = CommonVariable.userJobTile.value;
    imageBase64.value = CommonVariable.userImage.value;
    super.onInit();
  }

  /*Future<void> setOtherData() async {
    try {
      var name = '${displayFirstNameController.value.text} ${displayLastNameController.value.text}';
      var phone = phoneController.value.text;
      var userLocation = locationController.value.text;
      var userJobTitle = jobTitleController.value.text;

      if ((displayFirstNameController.value.text.isNotEmpty &&
              displayLastNameController.value.text.isNotEmpty &&
              name != CommonVariable.userName.value) ||
          (phoneController.value.text.isNotEmpty && phone != CommonVariable.userMobile.value) ||
          (locationController.value.text.isNotEmpty && userLocation != CommonVariable.userLocation.value) ||
          (jobTitleController.value.text.isNotEmpty && userJobTitle != CommonVariable.userJobTile.value)) {
        await AuthService().addOtherUserData(name: name, mobile: phone, location: userLocation, jobTitle: userJobTitle);

        var user = await AuthService().getCurrentUserData();

        if (user != null) {
          CommonVariable.userName.value = user['username'] ?? CommonVariable.userName.value;
          CommonVariable.userMobile.value = user['mobile'] ?? CommonVariable.userMobile.value;
          CommonVariable.userLocation.value = user['location'] ?? CommonVariable.userLocation.value;
          CommonVariable.userJobTile.value = user['jobTitle'] ?? CommonVariable.userJobTile.value;

          fullName.value = CommonVariable.userName.value;
          mobile.value = CommonVariable.userMobile.value;
          location.value = CommonVariable.userLocation.value;
          jobTitle.value = CommonVariable.userJobTile.value;

          customSnackBar('Success', 'Update profile successfully');
          Get.back();
        } else {
          customSnackBar('Error', 'User data not found');
        }
      } else {
        customSnackBar('Alert', 'No any change');
      }
    } catch (e) {
      print('Error: $e');
      customSnackBar('Error', 'Something went wrong');
    }
  }*/

  Future<int> setOtherData() async {
    try {
      final name = '${displayFirstNameController.value.text} ${displayLastNameController.value.text}';
      final phone = phoneController.value.text;
      final userLocation = locationController.value.text;
      final userJobTitle = jobTitleController.value.text;
      final image = imageBase64.value;

      // Check if any field has changed
      final hasNameChanged =
          displayFirstNameController.value.text.isNotEmpty &&
          displayLastNameController.value.text.isNotEmpty &&
          name != CommonVariable.userName.value;

      final hasPhoneChanged = phoneController.value.text.isNotEmpty && phone != CommonVariable.userMobile.value;

      final hasLocationChanged = locationController.value.text.isNotEmpty && userLocation != CommonVariable.userLocation.value;

      final hasJobTitleChanged = jobTitleController.value.text.isNotEmpty && userJobTitle != CommonVariable.userJobTile.value;

      final hasImageChanged = imageBase64.isNotEmpty && image != CommonVariable.userImage.value;

      if (hasNameChanged || hasPhoneChanged || hasLocationChanged || hasJobTitleChanged || hasImageChanged) {
        await AuthService().addOtherUserData(name: name, mobile: phone, location: userLocation, jobTitle: userJobTitle, image: image);

        // Update CommonVariable values directly instead of making another API call
        if (hasNameChanged) CommonVariable.userName.value = name;
        if (hasPhoneChanged) CommonVariable.userMobile.value = phone;
        if (hasLocationChanged) CommonVariable.userLocation.value = userLocation;
        if (hasJobTitleChanged) CommonVariable.userJobTile.value = userJobTitle;
        if (hasImageChanged) CommonVariable.userImage.value = image;

        // Update local values
        fullName.value = CommonVariable.userName.value;
        mobile.value = CommonVariable.userMobile.value;
        location.value = CommonVariable.userLocation.value;
        jobTitle.value = CommonVariable.userJobTile.value;
        imageBase64.value = CommonVariable.userImage.value;
        Get.back();
        return 1;
      } else {
        customSnackBar('Alert', 'No changes detected');
        return 0;
      }
    } catch (e) {
      print('Error updating profile: $e');
      customSnackBar('Error', 'Failed to update profile: ${e.toString()}');
      return 0;
    }
  }

  // BACK
  void back() {
    fullName.value = CommonVariable.userName.value;
    mobile.value = CommonVariable.userMobile.value;
    location.value = CommonVariable.userLocation.value;
    jobTitle.value = CommonVariable.userJobTile.value;
    imageBase64.value = CommonVariable.userImage.value;
    Get.back();
  }

  // ADD THE USER IMAGE
  Future<void> addImage({int i = 0}) async {
    var base64 = await pickImage(i: i);
    print('🏯 $base64');
    if (base64 != null) {
      imageBase64.value = base64;
    }
  }

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void changePassword() {
    var cPass = stringToHex(currentPasswordController.value.text);
    if (currentPasswordController.value.text.isEmpty) {
      customSnackBar('Alert', 'Please enter current password');
    } else if (cPass != Preferences.userPassword) {
      customSnackBar('Alert', 'Current password is wrong');
    } else if (newPasswordController.value.text.isEmpty) {
      customSnackBar('Alert', 'Please enter new password');
    } else if (!isValidPassword(newPasswordController.value.text)) {
      customSnackBar('Alert', 'New password must contain one at least number, one upper, one lower & 8 character');
    } else if (confirmPasswordController.value.text.isEmpty) {
      customSnackBar('Alert', 'Please enter confirm password');
    } else if (!isValidPassword(confirmPasswordController.value.text)) {
      customSnackBar('Alert', 'Confirm password must contain one at least number, one upper, one lower & 8 character');
    } else if (newPasswordController.value.text != confirmPasswordController.value.text) {
      customSnackBar('Alert', 'New password & confirm password must be same');
    } else {
      AuthService().changePasswordWithCurrentUser(
        oldPassword: currentPasswordController.value.text.trim(),
        newPassword: newPasswordController.value.text.trim(),
      );
      currentPasswordController.value.clear();
      newPasswordController.value.clear();
      confirmPasswordController.value.clear();
      Get.back();
    }
  }
}
