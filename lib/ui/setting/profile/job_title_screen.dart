import 'package:video_conforance/utilitis/common_import.dart';

class JobTitleScreen extends StatelessWidget {
  JobTitleScreen({super.key});

  final pc = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Job_Titles'.tr,
        titleColor: sHeaderColor,
        bgColor: cardColor,
        isLeadingWidgetIcon: true,
        leadingWidget: GestureDetector(
          onTap: () {
            pc.jobTitle.value = CommonVariable.userJobTile.value;
            Get.back();
          },
          child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: sHeaderColor),
        ),
        action: [],
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 10.sp),
            CommonTextFiled(
              controller: pc.jobTitleController.value,
              filedColor: cardColor,
              isFiled: true,
              isHideBorder: true,
              hintText: "Your_Designation".tr,
              onChanged: (p0) {
                if (pc.jobTitleController.value.text.isNotEmpty) {
                  pc.isFillJobTitle.value = true;
                } else {
                  pc.isFillJobTitle.value = false;
                }
              },
              hintStyle: TextStyle(fontFamily: "RM", fontSize: 14.sp, color: sHeaderColor.withValues(alpha: 0.3)),
            ),
            SizedBox(height: 40.h),
            CommonContainer(
              onTap: () {
                pc.jobTitle.value = pc.jobTitleController.value.text;
                Get.back();
              },
              height: 55.h,
              containerColor: pc.isFillJobTitle.value ? ConstColor.lightBlue : ConstColor.lightBlue.withValues(alpha: 0.3),
              child: CommonTextWidget(title: "Save".tr, fontFamily: "RSB", fontSize: 18.sp, color: ConstColor.white),
            ),
          ],
        );
      }).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
    );
  }
}
