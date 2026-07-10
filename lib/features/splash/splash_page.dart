import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/constants/global.dart';

import 'splash_cubit.dart';

class SplashPage extends StatefulWidget {
  final SplashCubit cubit;

  const SplashPage({super.key, required this.cubit});

  @override
  State<SplashPage> createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  SplashCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    // Wait until after the first frame so the navigator is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final navContext = GlobalConstants.navigatorKey.currentContext;
      if (navContext != null) {
        cubit.navigator.context = navContext;
      } else {
        cubit.navigator.context = context;
      }
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (!mounted || cubit.isClosed) return;
        cubit.checkUser();
      });
    });
  }

  @override
  void dispose() {
    // Cubit is closed by the page that replaces splash, or explicitly when
    // leaving. Avoid closing here if navigation already disposed this route
    // mid-flight — checkUser guards with isClosed.
    if (!cubit.isClosed) {
      cubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
        child: Center(child: AppConstants.logo(color: Colors.white)),
      ),
    );
  }
}
