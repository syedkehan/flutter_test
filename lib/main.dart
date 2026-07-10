import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_test_app/config/theme/theme_data.dart';
import 'package:flutter_test_app/core/constants/global.dart';
import 'package:flutter_test_app/core/constants/system_ui_overlay.dart';
import 'package:flutter_test_app/core/show/checker_navigator_observer.dart';
import 'package:flutter_test_app/data/datasources/theme/theme_data_source.dart';
import 'package:flutter_test_app/features/splash/splash_initial_params.dart';
import 'package:flutter_test_app/features/splash/splash_page.dart';
import 'package:flutter_test_app/injection_container.dart' as di;
import 'package:flutter_test_app/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSystemUI.lockPortrait();
  await dotenv.load(fileName: '.env', isOptional: true);
  await di.init();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => const _AppRoot(),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late final ThemeDataSources _theme = getIt<ThemeDataSources>();
  // Keep a single home instance so theme updates do not remount splash.
  late final Widget _home = SplashPage(
    cubit: getIt(param1: const SplashInitialParams()),
  );
  StreamSubscription<bool>? _themeSub;

  @override
  void initState() {
    super.initState();
    _themeSub = _theme.stream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _themeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      navigatorKey: GlobalConstants.navigatorKey,
      scaffoldMessengerKey: GlobalConstants.scaffoldMessengerKey,
      navigatorObservers: [CheckerNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _theme.state ? ThemeMode.dark : ThemeMode.light,
      home: _home,
    );
  }
}
