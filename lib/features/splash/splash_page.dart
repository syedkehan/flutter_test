import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';

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
    cubit.navigator.context = context;
    Future.delayed(const Duration(seconds: 2), () {
      cubit.checkUser();
    });
  }

  @override
  void dispose() {
    cubit.close();
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
