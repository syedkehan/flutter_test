import 'package:flutter/material.dart';
import 'package:flutter_test_app/config/navigation/transition_type.dart';
import 'package:flutter_test_app/features/auth/signup/signup_navigator.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_navigator.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_navigator.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'login_initial_params.dart';
import 'login_page.dart';

class LoginNavigator with SignUpRoute, BottomNavRoute, OnboardingRoute {
  LoginNavigator(this.navigator);
  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin LoginRoute {
  void openLogin(LoginInitialParams initialParams) => navigator.push(
    context: context,
    routeName: LoginPage(cubit: getIt(param1: initialParams)),
  );

  void removeLogin(LoginInitialParams initialParams) =>
      navigator.pushAndRemoveUntil(
        context: context,
        routeName: LoginPage(cubit: getIt(param1: initialParams)),
        transitionType: TransitionType.slideFromLeft,
        predicate: (route) => false,
      );

  AppNavigator get navigator;

  BuildContext get context;
}
