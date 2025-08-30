import 'package:video_conforance/utilitis/common_import.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({super.key});

  final pc = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Phone_Number'.tr,
        titleColor: sHeaderColor,
        bgColor: cardColor,
        isLeadingWidgetIcon: true,
        leadingWidget: GestureDetector(
          onTap: () {
            pc.phoneController.value.clear();
            pc.mobile = CommonVariable.userMobile;
            Get.back();
          },
          child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: sHeaderColor),
        ),
        action: [],
      ),
      body: Obx(() {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CommonTextWidget(title: 'Phone_Number'.tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor),
            ),
            SizedBox(height: 10.h),
            PhoneFormField(
              mobileController: pc.phoneController.value,
              initialCountryCode: "IN",
              onCountryChanged: (p0) {},
              onChanged: (p0) {
                if (pc.phoneController.value.text.isNotEmpty) {
                  pc.isFillPhone.value = true;
                } else {
                  pc.isFillPhone.value = false;
                }
              },
            ),
            SizedBox(height: 30.h),
            CommonContainer(
              onTap: () {
                pc.mobile.value = pc.phoneController.value.text;
                Get.back();
              },
              containerColor: pc.isFillPhone.value ? ConstColor.lightBlue : ConstColor.lightBlue.withValues(alpha: 0.3),
              height: 55.h,
              radius: 10.r,
              child: CommonTextWidget(title: 'Update'.tr, color: ConstColor.white, fontFamily: "RSB", fontSize: 18.sp),
            ),
          ],
        );
      }).paddingSymmetric(horizontal: 15.sp, vertical: 15.sp),
    );
  }
}
