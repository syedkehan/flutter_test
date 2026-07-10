import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/constants/global.dart';
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

  Future<void> checkUser() async {
    if (isClosed) return;

    // Theme is best-effort and must never block leaving splash.
    try {
      await getThemeUseCase.execute().timeout(const Duration(seconds: 2));
    } catch (_) {}

    if (isClosed) return;
    emit(state.copyWith(isloading: true));

    try {
      final value = await checkForExistingUserUseCase
          .execute()
          .timeout(const Duration(seconds: 3));

      if (isClosed) return;

      value.fold(
        (_) => _goToOnboarding(),
        (_) => _goToBottomNav(),
      );
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isloading: false));
      }
      _goToOnboarding();
    }
  }

  void _ensureNavigatorContext() {
    final navContext = GlobalConstants.navigatorKey.currentContext;
    if (navContext != null) {
      navigator.context = navContext;
    }
  }

  void _goToOnboarding() {
    _ensureNavigatorContext();
    if (!isClosed) {
      emit(state.copyWith(isloading: false));
    }
    navigator.openOnboarding(const OnboardingInitialParams());
  }

  void _goToBottomNav() {
    _ensureNavigatorContext();
    if (!isClosed) {
      emit(state.copyWith(isloading: false));
    }
    // Replace splash so it cannot remain underneath a failed push.
    navigator.openBottomNavLeft(const BottomNavInitialParams());
  }
}
