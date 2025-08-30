
import 'package:video_conforance/utilitis/common_import.dart';
import 'localization/languages.dart';
import 'firebase_options.dart';
import 'notification/notification_helper.dart';

// call val add krv baki localization

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Preferences.init();
  await initDynamicLinks();
  // await CallService().initialize();
  await initializeNotifications();
  getPushToken();
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) {
        AppTheme.setSystemUIOverlayStyle(ThemeMode.values[CommonVariable.themeMode.value]);
        return ThemeNotifier(ThemeMode.values[CommonVariable.themeMode.value]);
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    AppTheme.setSystemUIOverlayStyle(ThemeMode.values[Preferences.themeMode]);
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppTheme.setSystemUIOverlayStyle(ThemeMode.values[Preferences.themeMode]);
    }

    // Handle different app lifecycle states
    switch (state) {
      case AppLifecycleState.resumed:
        if (Preferences.isLogin) AuthService().updateActiveStatus(true);
        debugPrint("App is in the foreground (resumed).");
        break;
      case AppLifecycleState.inactive:
        debugPrint("App is inactive.");
        break;
      case AppLifecycleState.paused:
        if (Preferences.isLogin) AuthService().updateActiveStatus(false);
        debugPrint("App is in the background (paused).");
        break;
      case AppLifecycleState.detached:
        if (Preferences.isLogin) AuthService().updateActiveStatus(false);
        debugPrint("App is detached (terminated).");
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GestureDetector(
          onTap: () {
            var controller = Get.put(ScheduleMeetingController());
            controller.isShowDatePiker.value = false;
            controller.isShowTimePiker.value = false;
            FocusManager.instance.primaryFocus?.unfocus(); // Dismiss the keyboard
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: LanguagesTranslations(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeNotifier.getThemeMode,
            locale: Locale(Preferences.languageCode),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
