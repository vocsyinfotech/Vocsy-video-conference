import 'package:video_conforance/utilitis/common_import.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

final ssc = SetStatusController();

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  ThemeMode? selectedThemeMode;

  void changeTheme(ThemeMode mode, ThemeNotifier themeModeNotifier) async {
    themeModeNotifier.setThemeMode(mode);
    Preferences.themeMode = mode.index;
    CommonVariable.themeMode.value = mode.index;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ThemeNotifier>(context);
    CommonVariable.themeMode.value = Preferences.themeMode;
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Theme'.tr,
        titleColor: Theme.of(context).secondaryHeaderColor,
        bgColor: Theme.of(context).cardColor,
        isLeadingWidgetIcon: true,
        leadingWidget: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: sHeaderColor),
        ),
        action: [
          Container(
            alignment: Alignment.center,
            child: CommonTextWidget(
              title: 'Done'.tr,
              fontSize: 16.sp,
              fontFamily: "RSB",
              color: ConstColor.lightBlue,
              onTap: () {
                if (ssc.selectedTheme.value == 0) {
                  changeTheme(ThemeMode.light, notifier);
                } else if (ssc.selectedTheme.value == 1) {
                  changeTheme(ThemeMode.dark, notifier);
                } else {
                  changeTheme(ThemeMode.system, notifier);
                }
                Get.back();
              },
            ),
          ).paddingOnly(right: 15.sp),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(
              height: 20.h,
              child: GestureDetector(
                onTap: () {
                  // changeTheme(ThemeMode.light, notifier);
                  ssc.selectedTheme.value = 0;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(title: "Light".tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor),
                    ssc.selectedTheme.value == 0
                        ? CommonSvgView(iconPath: 'assets/icons/done.svg', height: 24.w, width: 24.w, fit: BoxFit.cover)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Divider(thickness: 1.5, height: 30.h, color: sHeaderColor.withValues(alpha: 0.1)),
            SizedBox(
              height: 20.h,
              child: GestureDetector(
                onTap: () {
                  // changeTheme(ThemeMode.dark, notifier);
                  ssc.selectedTheme.value = 1;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(title: "Dark".tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor),
                    ssc.selectedTheme.value == 1
                        ? CommonSvgView(iconPath: 'assets/icons/done.svg', height: 24.w, width: 24.w, fit: BoxFit.cover)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Divider(thickness: 1.5, height: 30.h, color: sHeaderColor.withValues(alpha: 0.1)),
            SizedBox(
              height: 20.h,
              child: GestureDetector(
                onTap: () {
                  // changeTheme(ThemeMode.system, notifier);
                  ssc.selectedTheme.value = 2;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(title: "System_Default".tr, fontSize: 16.sp, fontFamily: "RM", color: sHeaderColor),
                    ssc.selectedTheme.value == 2
                        ? CommonSvgView(iconPath: 'assets/icons/done.svg', height: 24.w, width: 24.w, fit: BoxFit.cover)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        );
      }).paddingSymmetric(horizontal: 20.sp, vertical: 20.sp),
    );
  }
}
