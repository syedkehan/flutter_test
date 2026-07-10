import 'bottom_nav_initial_params.dart';

class BottomNavState {
  final int selectedIndex;

  BottomNavState({required this.selectedIndex});

  factory BottomNavState.initial({
    required BottomNavInitialParams initialParams,
  }) => BottomNavState(selectedIndex: initialParams.selectedIndex);

  BottomNavState copyWith({int? selectedIndex}) => BottomNavState(
    selectedIndex: selectedIndex ?? this.selectedIndex,
  );
}
