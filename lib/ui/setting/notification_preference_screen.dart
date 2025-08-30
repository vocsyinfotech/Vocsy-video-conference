import 'package:video_conforance/utilitis/common_import.dart';

class NotificationPreferenceScreen extends StatelessWidget {
  NotificationPreferenceScreen({super.key});

  final ssc = Get.put(SetStatusController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Notification_Preference'.tr,
        titleColor: sHeaderColor,
        bgColor: cardColor,
        isLeadingWidgetIcon: true,
        leadingWidget: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: sHeaderColor),
        ),
        action: [],
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 15.h),
            CommonSwitchRow(
              text: 'Notification'.tr,
              fontFamily: "RSB",
              fontSize: 18.sp,
              switchValue: ssc.notification.value,
              onChanged: (value) {
                ssc.notification.value = value;
                ssc.updateNotificationStatus();
              },
            ),
            Divider(color: sHeaderColor.withValues(alpha: 0.1), thickness: 1.5),
            CommonTextWidget(
              title: 'Notification_text'.tr,
              fontFamily: "RR",
              fontSize: 14.sp,
              textAlign: TextAlign.center,
              maxLines: 2,
              color: sHeaderColor.withValues(alpha: 0.4),
            ).paddingSymmetric(vertical: 10.sp, horizontal: 10.sp),
          ],
        );
      }).paddingSymmetric(horizontal: 20.sp, vertical: 15.sp),
    );
  }
}
