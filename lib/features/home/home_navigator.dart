import 'package:flutter/material.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'home_initial_params.dart';
import 'home_page.dart';

class HomeNavigator {
  HomeNavigator(this.navigator);

  late BuildContext context;
  AppNavigator navigator;
}

mixin HomeRoute {
  void openHome(HomeInitialParams initialParams) => navigator.push(
    context: context,
    routeName: HomePage(cubit: getIt(param1: initialParams)),
  );

  AppNavigator get navigator;

  BuildContext get context;
}
