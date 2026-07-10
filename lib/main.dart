import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  // Optional so a missing .env cannot block runApp / leave the native splash up.
  await dotenv.load(fileName: '.env', isOptional: true);
  await di.init();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) => BlocBuilder(
      bloc: getIt<ThemeDataSources>(),
      builder: (context, state) {
        state as bool;
        return MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          navigatorKey: GlobalConstants.navigatorKey,
          scaffoldMessengerKey: GlobalConstants.scaffoldMessengerKey,
          navigatorObservers: [CheckerNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          theme: state ? darkTheme : lightTheme,
          // Keep splash as a stable child so theme rebuilds do not recreate
          // SplashPage / reset navigation back to the logo.
          home: child,
        );
      },
    ),
    child: SplashPage(cubit: getIt(param1: const SplashInitialParams())),
  );
}
