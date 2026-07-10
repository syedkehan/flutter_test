import 'package:flutter/material.dart';

import 'package:flutter_test_app/config/navigation/transition_type.dart';
import 'package:flutter_test_app/config/navigation/transitions.dart';

mixin TransitionTypeChecker {
  PageRouteBuilder<T> transitionTypeChecker<T>(
    Widget routeName,
    TransitionType transitionType,
  ) => AppPageRoute<T>(child: routeName, type: transitionType);
}
