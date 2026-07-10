import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/features/auth/login/login_initial_params.dart';
import 'package:flutter_test_app/features/auth/signup/signup_initial_params.dart';

import 'onboarding_initial_params.dart';
import 'onboarding_navigator.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingNavigator navigator;
  final OnboardingInitialParams initialParams;
  OnboardingCubit(this.initialParams, this.navigator)
    : super(OnboardingState.initial(initialParams: initialParams));

  void onLoginPressed() => navigator.openLogin(const LoginInitialParams());

  void onSignUpPressed() => navigator.openSignUp(const SignUpInitialParams());
}
