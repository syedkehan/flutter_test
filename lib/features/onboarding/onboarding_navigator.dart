import 'package:flutter/material.dart';
import 'package:flutter_test_app/config/navigation/transition_type.dart';
import 'package:flutter_test_app/features/auth/login/login_navigator.dart';
import 'package:flutter_test_app/features/auth/signup/signup_navigator.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'onboarding_initial_params.dart';
import 'onboarding_page.dart';

class OnboardingNavigator with LoginRoute, SignUpRoute {
  OnboardingNavigator(this.navigator);
  @override
  late BuildContext context;
  @override
  AppNavigator navigator;
}

mixin OnboardingRoute {
  void openOnboarding(OnboardingInitialParams initialParams) =>
      navigator.pushAndRemoveUntil(
        context: context,
        routeName: OnboardingPage(cubit: getIt(param1: initialParams)),
        transitionType: TransitionType.slideFromLeft,
        predicate: (route) => false,
      );

  AppNavigator get navigator;

  BuildContext get context;
}
