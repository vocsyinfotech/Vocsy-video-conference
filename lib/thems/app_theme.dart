import 'dart:ui';
import '../utilitis/common_import.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get getThemeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    if (mode == ThemeMode.system) {
      CommonVariable.isDark.value = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    } else {
      CommonVariable.isDark.value = mode == ThemeMode.dark;
    }
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ConstColor.lightGray,
    primaryColor: ConstColor.blue,
    cardColor: ConstColor.white,
    primaryColorDark: ConstColor.darkGray,
    secondaryHeaderColor: ConstColor.darkGray,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    useMaterial3: false,
    hintColor: const Color(0xffF2F2F7),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: ConstColor.lightBlue,
      actionsIconTheme: IconThemeData(color: ConstColor.white),
      titleTextStyle: TextStyle(fontSize: 25.sp, color: ConstColor.white, fontFamily: 'RB'),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    ),
    colorScheme: ColorScheme.light(primary: ConstColor.lightBlue, secondary: Color(0xfff0f1f6)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ConstColor.white,
      selectedIconTheme: IconThemeData(color: ConstColor.lightBlue),
      unselectedIconTheme: IconThemeData(color: ConstColor.darkGray.withValues(alpha: 0.2)),
      selectedItemColor: ConstColor.lightBlue,
      unselectedItemColor: ConstColor.darkGray.withValues(alpha: 0.2),
      selectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 12.sp, color: ConstColor.lightBlue),
      unselectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 12.sp, color: ConstColor.darkGray.withValues(alpha: 0.2)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ConstColor.darkGray,
    primaryColor: ConstColor.lightBlue,
    cardColor: ConstColor.neroGray,
    primaryColorDark: ConstColor.darkGray,
    secondaryHeaderColor: ConstColor.white,
    hintColor: const Color(0xff242427),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    useMaterial3: false,
    unselectedWidgetColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: ConstColor.lightBlue,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontSize: 25.sp, color: ConstColor.white, fontFamily: 'RB'),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    colorScheme: ColorScheme.dark(primary: ConstColor.lightBlue, secondary: Color(0xfff0f1f6)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff242427),
      selectedIconTheme: IconThemeData(color: ConstColor.lightBlue),
      unselectedIconTheme: IconThemeData(color: ConstColor.white.withValues(alpha: 0.2)),
      selectedItemColor: ConstColor.lightBlue,
      unselectedItemColor: ConstColor.white.withValues(alpha: 0.2),
      selectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 12.sp, color: ConstColor.lightBlue),
      unselectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 12.sp, color: ConstColor.white.withValues(alpha: 0.2)),
    ),
  );

  static setSystemUIOverlayStyle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        if (PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
          CommonVariable.isDark.value = true;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
            ),
          );
        } else {
          CommonVariable.isDark.value = false;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
            ),
          );
        }
        break;
      case ThemeMode.light:
        CommonVariable.isDark.value = false;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          ),
        );
        break;
      case ThemeMode.dark:
        CommonVariable.isDark.value = true;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
        );
        break;
    }
  }
}

/*
import 'dart:ui';
import '../utilitis/common_import.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get getThemeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    if (mode == ThemeMode.system) {
      CommonVariable.isDark.value = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    } else {
      CommonVariable.isDark.value = mode == ThemeMode.dark;
    }
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ConstColor.lightGray,
    primaryColor: ConstColor.blue,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    useMaterial3: false,
    hintColor: const Color(0xffF2F2F7),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actionsIconTheme: IconThemeData(color: ConstColor.white),
      titleTextStyle: TextStyle(fontSize: 18.sp, color: ConstColor.white, fontFamily: 'RB'),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    ),
    colorScheme: ColorScheme.light(primary: ConstColor.lightBlue, secondary: Color(0xfff0f1f6)),
    // dialogTheme: DialogTheme(titleTextStyle: TextStyle(color: lightBlack, fontSize: 18.sp, fontFamily: 'B'), backgroundColor: Colors.white),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ConstColor.white,
      selectedIconTheme: IconThemeData(color: ConstColor.lightBlue),
      unselectedIconTheme: IconThemeData(color: ConstColor.darkGray.withValues(alpha: 0.2)),
      selectedItemColor: ConstColor.lightBlue,
      unselectedItemColor: ConstColor.darkGray.withValues(alpha: 0.2),
      selectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 10.sp, color: ConstColor.lightBlue),
      unselectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 10.sp, color: ConstColor.darkGray.withValues(alpha: 0.2)),
    ),
    // timePickerTheme: TimePickerThemeData(
    //   backgroundColor: Colors.white,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
    //   dialBackgroundColor: lightPink,
    //   // color for AM/PM
    //   dayPeriodColor: pink,
    //   dialHandColor: pink,
    //   dayPeriodBorderSide: const BorderSide(color: pink),
    //   hourMinuteTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    //   hourMinuteColor: lightPink,
    //   dialTextColor: Colors.black,
    //   dialTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    //   dayPeriodTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    //   dayPeriodTextColor: Colors.black,
    //   helpTextStyle: TextStyle(fontFamily: 'M', fontSize: 18.sp),
    // ),
    // datePickerTheme: DatePickerThemeData(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(24.r),
    //     ),
    //     backgroundColor: Colors.white,
    //     todayBackgroundColor: WidgetStateProperty.all(pink),
    //     todayBorder: BorderSide.none,
    //     yearStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: darkBlue),
    //     weekdayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: grey),
    //     todayForegroundColor: WidgetStateProperty.all(darkBlue),
    //     dayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp)),
    // tabBarTheme: TabBarTheme(
    //   labelColor: pink,
    //   indicatorColor: lightPink,
    //   unselectedLabelColor: grey,
    //   labelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
    //   unselectedLabelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
    // )
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ConstColor.darkGray,
    primaryColor: ConstColor.blue,
    hintColor: const Color(0xff242427),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    useMaterial3: false,
    unselectedWidgetColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontSize: 18.sp, color: ConstColor.white, fontFamily: 'RR'),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    // bottomSheetTheme: BottomSheetThemeData(
    //   backgroundColor: lightBlue,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
    //   ),
    // ),
    colorScheme: ColorScheme.dark(primary: ConstColor.lightBlue, secondary: Color(0xfff0f1f6)),
    // dialogTheme: DialogTheme(titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: 'B'), backgroundColor: lightBlue),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff242427),
      selectedIconTheme: IconThemeData(color: ConstColor.lightBlue),
      unselectedIconTheme: IconThemeData(color: ConstColor.white.withValues(alpha: 0.2)),
      selectedItemColor: ConstColor.lightBlue,
      unselectedItemColor: ConstColor.white.withValues(alpha: 0.2),
      selectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 10.sp, color: ConstColor.lightBlue),
      unselectedLabelStyle: TextStyle(fontFamily: 'RR', fontSize: 10.sp, color: ConstColor.white.withValues(alpha: 0.2)),
    ),
    // timePickerTheme: TimePickerThemeData(
    //   backgroundColor: lightBlue,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(24.r),
    //   ),
    //   dialBackgroundColor: darkBlue,
    //   dayPeriodColor: clay,
    //   // color for AM/PM
    //   dialHandColor: clay,
    //   dayPeriodBorderSide: const BorderSide(color: clay),
    //   hourMinuteTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    //   hourMinuteColor: darkBlue,
    //   dialTextColor: Colors.white,
    //   dialTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    //   dayPeriodTextStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    //   dayPeriodTextColor: Colors.white,
    //   helpTextStyle: TextStyle(fontFamily: 'M', fontSize: 18.sp),
    // ),
    // datePickerTheme: DatePickerThemeData(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(24.r),
    //     ),
    //     backgroundColor: lightBlue,
    //     todayBackgroundColor: WidgetStateProperty.all(clay),
    //     todayBorder: BorderSide.none,
    //     yearStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: Colors.white),
    //     weekdayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: grey),
    //     todayForegroundColor: WidgetStateProperty.all(Colors.white),
    //     dayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp)),
    // tabBarTheme: TabBarTheme(
    //   labelColor: clay,
    //   indicatorColor: Colors.white,
    //   unselectedLabelColor: grey,
    //   labelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
    //   unselectedLabelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
    // ),
  );

  static setSystemUIOverlayStyle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        if (PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
          CommonVariable.isDark.value = true;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
            ),
          );
        } else {
          CommonVariable.isDark.value = false;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
            ),
          );
        }
        break;
      case ThemeMode.light:
        CommonVariable.isDark.value = false;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
          ),
        );
        break;
      case ThemeMode.dark:
        CommonVariable.isDark.value = true;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
        );
        break;
    }
  }
}
*/
