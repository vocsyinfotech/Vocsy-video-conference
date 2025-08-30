import 'package:video_conforance/utilitis/common_import.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final ssc = SetStatusController();

  @override
  Widget build(BuildContext context) {
    print('DAT AGGGG WITH NNNNNNNNNNN GGGGGGGGGGGGG ${Preferences.languageCode}');
    final index = AppLanguage.list.indexWhere((element) => element.languageCode == Preferences.languageCode);
    if (!index.isNegative) {
      ssc.selectedLanguage.value = index;
    }
    var sHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: commonAppBar(
        title: 'Languages'.tr,
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
      body: SingleChildScrollView(
        child: Obx(() {
          ssc.selectedLanguage.value;
          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final AppLanguage language = AppLanguage.list[index];
                  final bool active = (ssc.selectedLanguage.value == index);
                  return GestureDetector(
                    onTap: () {
                      ssc.selectedLanguage.value = index;
                      Preferences.languageCode = language.languageCode;
                      print('UPDATE THE P ${Preferences.languageCode}');
                      Get.updateLocale(Locale(language.languageCode));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CommonSvgView(iconPath: language.flag, height: 35.w, width: 35.w, fit: BoxFit.cover),
                              SizedBox(width: 20.w),
                              CommonTextWidget(title: language.name, fontFamily: "RM", fontSize: 16.sp, color: sHeaderColor),
                            ],
                          ),
                        ),
                        active ? CommonSvgView(iconPath: 'assets/icons/done.svg', height: 24.h, width: 24.w, fit: BoxFit.cover) : SizedBox.shrink(),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: sHeaderColor.withValues(alpha: 0.1), height: 30.h);
                },
                itemCount: AppLanguage.list.length,
              ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
            ],
          );
        }),
      ),
    );
  }
}

class AppLanguage {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  AppLanguage(this.id, this.flag, this.name, this.languageCode);

  static List<AppLanguage> get list {
    return <AppLanguage>[
      AppLanguage(1, "assets/images/us.svg", "English", "en"),
      AppLanguage(2, "assets/images/sp.svg", "Spanish", "es"),
      AppLanguage(3, "assets/images/fr.svg", "French", "fr"),
      AppLanguage(4, "assets/images/kr.svg", "Korean", "ko"),
      AppLanguage(5, "assets/images/de.svg", "German", "de"),
      AppLanguage(6, "assets/images/it.svg", "Italian", "it"),
      AppLanguage(6, "assets/images/nr.svg", "Norwegian", "no"),
      AppLanguage(6, "assets/images/po.svg", "Polish", "pl"),
      AppLanguage(6, "assets/images/jp.svg", "Japanese", "ja"),
    ];
  }
}
