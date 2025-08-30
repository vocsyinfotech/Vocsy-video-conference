import 'package:flutter/cupertino.dart';
import 'package:video_conforance/utilitis/common_import.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final pc = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Location'.tr,
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
      body: Column(
        children: [
          CommonTextFiled(
            controller: pc.locationController.value,
            isHideBorder: true,
            filedColor: cardColor,
            isFiled: true,
            hintText: "Search_Location".tr,
            hintStyle: TextStyle(fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor.withValues(alpha: 0.5)),
            suffixIcon: Icon(CupertinoIcons.search, color: sHeaderColor.withValues(alpha: 0.3)),
          ).paddingSymmetric(vertical: 20.sp, horizontal: 15.sp),
          Divider(color: sHeaderColor.withValues(alpha: 0.1), thickness: 1),
          Column(children: []).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
        ],
      ),
    );
  }
}
