import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/auth/login/login_navigator.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_navigator.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'signup_initial_params.dart';
import 'signup_page.dart';

class SignUpNavigator with LoginRoute, BottomNavRoute {
  SignUpNavigator(this.navigator);
  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin SignUpRoute {
  void openSignUp(SignUpInitialParams initialParams) => navigator.push(
    context: context,
    routeName: SignUpPage(cubit: getIt(param1: initialParams)),
  );

  AppNavigator get navigator;

  BuildContext get context;
}
