import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/features/home/home_cubit.dart';
import 'package:flutter_test_app/features/home/home_initial_params.dart';
import 'package:flutter_test_app/features/home/home_page.dart';
import 'package:flutter_test_app/injection_container.dart';

import 'bottom_nav_initial_params.dart';
import 'bottom_nav_navigator.dart';
import 'bottom_nav_state.dart';
import 'widget/placeholder_tab_page.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  final BottomNavNavigator navigator;
  final BottomNavInitialParams initialParams;

  BottomNavCubit(this.initialParams, this.navigator)
    : super(BottomNavState.initial(initialParams: initialParams)) {
    setSelectedIndex(initialParams.selectedIndex);
  }

  void setSelectedIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  late final HomeCubit homeCubit = getIt(param1: const HomeInitialParams());

  late final List<Widget> pages = [
    HomePage(cubit: homeCubit),
    const PlaceholderTabPage(title: 'Explore', icon: Icons.explore_outlined),
    const PlaceholderTabPage(title: 'Activity', icon: Icons.notifications_outlined),
    const PlaceholderTabPage(title: 'Messages', icon: Icons.chat_bubble_outline),
    const PlaceholderTabPage(title: 'Profile', icon: Icons.person_outline),
  ];

  void closeTabCubits() {
    homeCubit.close();
  }
}
