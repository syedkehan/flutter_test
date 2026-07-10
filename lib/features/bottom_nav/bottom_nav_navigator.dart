import 'package:flutter/material.dart';
import 'package:flutter_test_app/config/navigation/transition_type.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'bottom_nav_initial_params.dart';
import 'bottom_nav_page.dart';

class BottomNavNavigator {
  BottomNavNavigator(this.navigator);

  late BuildContext context;
  AppNavigator navigator;
}

mixin BottomNavRoute {
  void openBottomNav(BottomNavInitialParams initialParams) => navigator.push(
    context: context,
    routeName: BottomNavPage(cubit: getIt(param1: initialParams)),
  );

  void openBottomNavLeft(BottomNavInitialParams initialParams) =>
      navigator.pushAndRemoveUntil(
        context: context,
        routeName: BottomNavPage(cubit: getIt(param1: initialParams)),
        transitionType: TransitionType.slideFromLeft,
        predicate: (route) => false,
      );

  AppNavigator get navigator;

  BuildContext get context;
}
