import 'dart:convert';
import '../../utilitis/common_import.dart';

class BottomScreen extends StatelessWidget {
  BottomScreen({super.key});

  final bc = Get.put(BottomController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Uint8List bytes = base64Decode(CommonVariable.userImage.value);
      bc.currentIndex.value;
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80.h,
          automaticallyImplyLeading: false,
          title: CommonTextWidget(title: bc.showAppBarTitleText(), style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: [
            if (bc.currentIndex.value == 0)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 15.sp),
                  child: bc.isLoading.value
                      ? ConstShimmer.profileImage(height: 40.w, width: 40.w, radius: 10.r)
                      : CommonVariable.userImage.isEmpty
                      ? Container(
                          height: 40.w,
                          width: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(13.r), color: ConstColor.white),
                          child: CommonTextWidget(
                            title: getUserInitials(CommonVariable.userName.value),
                            fontFamily: "RSB",
                            fontSize: 16.sp,
                            color: ConstColor.lightBlue,
                          ),
                        )
                      : Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.r),
                            image: DecorationImage(image: MemoryImage(bytes), fit: BoxFit.cover),
                          ),
                        ),
                ),
              ),
          ],
        ),
        body: IndexedStack(index: bc.currentIndex.value, children: bc.pageList),
        bottomNavigationBar: Theme(
          data: Theme.of(context),
          child: BottomNavigationBar(
            currentIndex: bc.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              bc.currentIndex.value = value;
            },
            items: [
              BottomNavigationBarItem(
                icon: CommonSvgView(
                  iconPath: 'assets/icons/home.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
                activeIcon: CommonSvgView(
                  iconPath: 'assets/icons/home.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                ),
                label: "Meeting".tr,
              ),
              BottomNavigationBarItem(
                icon: CommonSvgView(
                  iconPath: 'assets/icons/calender.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
                activeIcon: CommonSvgView(
                  iconPath: 'assets/icons/calender.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                ),
                label: "Schedule".tr,
              ),
              BottomNavigationBarItem(
                icon: CommonSvgView(
                  iconPath: 'assets/icons/message.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
                activeIcon: CommonSvgView(
                  iconPath: 'assets/icons/message.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                ),
                label: "Message".tr,
              ),
              BottomNavigationBarItem(
                icon: CommonSvgView(
                  iconPath: 'assets/icons/setting.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
                activeIcon: CommonSvgView(
                  iconPath: 'assets/icons/setting.svg',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                ),
                label: "Setting".tr,
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add_box_rounded),
        //   onPressed: () {
        //     // sendInviteEmail('vocsyredmi10s@gmail.com');
        //   },
        // ),
      );
    });
  }
}
