import 'package:video_conforance/utilitis/common_import.dart';

class SetStatusScreen extends StatelessWidget {
  SetStatusScreen({super.key});

  final ssc = Get.put(SetStatusController());

  @override
  Widget build(BuildContext context) {
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Set_Status'.tr,
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
          children: List.generate(ssc.statusList.length, (index) {
            return GestureDetector(
              onTap: () {
                ssc.selectedStatus.value = index;
                ssc.updateStatus();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 28.h,
                    child: Row(
                      children: [
                        index == 0
                            ? Icon(Icons.circle, size: 15.sp, color: Color(0xff68E070)).paddingOnly(left: 8.sp)
                            : index != 2
                            ? CommonSvgView(
                                iconPath: '${ssc.statusList[index].iconPath}',
                                height: 30.w,
                                width: 30.w,
                                fit: BoxFit.cover,
                                color: sHeaderColor,
                              )
                            : CommonSvgView(iconPath: '${ssc.statusList[index].iconPath}', height: 30.w, width: 30.w, fit: BoxFit.cover),
                        SizedBox(width: index == 0 ? 15.w : 10.w),
                        CommonTextWidget(title: ssc.statusList[index].title.toString(), fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor),
                        Spacer(),
                        index == ssc.selectedStatus.value
                            ? CommonSvgView(iconPath: 'assets/icons/done.svg', height: 28.w, width: 28.w, fit: BoxFit.cover)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Divider(color: sHeaderColor.withValues(alpha: 0.1), thickness: 1.5, height: 25.h),
                ],
              ),
            );
          }),
        );
      }).paddingSymmetric(vertical: 25.sp, horizontal: 20.sp),
    );
  }
}
