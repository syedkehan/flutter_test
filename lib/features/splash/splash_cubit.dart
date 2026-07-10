import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_initial_params.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_initial_params.dart';

import '/domain/usecases/local/check_for_existing_user_use_case.dart';
import '/domain/usecases/theme/get_theme_use_case.dart';
import '/features/splash/splash_navigator.dart';
import 'splash_initial_params.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashInitialParams initialParams;
  final SplashNavigator navigator;
  final CheckForExistingUserUseCase checkForExistingUserUseCase;
  final GetThemeUseCase getThemeUseCase;

  SplashCubit(
    this.initialParams,
    this.navigator,
    this.checkForExistingUserUseCase,
    this.getThemeUseCase,
  ) : super(SplashState.initial(initialParams: initialParams));

  void checkUser() {
    getThemeUseCase.execute();

    emit(state.copyWith(isloading: true));
    checkForExistingUserUseCase
        .execute()
        .then(
          (value) => value.fold(
            (l) {
              emit(state.copyWith(isloading: false));
              return navigator.openOnboarding(const OnboardingInitialParams());
            },
            (r) {
              emit(state.copyWith(isloading: false));
              return navigator.openBottomNav(const BottomNavInitialParams());
            },
          ),
        )
        .catchError((_) {
          if (!isClosed) {
            emit(state.copyWith(isloading: false));
          }
          navigator.openOnboarding(const OnboardingInitialParams());
        });
  }
}
