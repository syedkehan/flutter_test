import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/data/datasources/auth/dummy_auth_data_source.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_initial_params.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_initial_params.dart';

import '/core/show/show/show.dart';
import '/data/models/auth/login_model.dart';
import '/domain/usecases/user/user_use_cases.dart';
import 'login_initial_params.dart';
import 'login_navigator.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginInitialParams initialParams;
  final DummyAuthDataSource authDataSource;
  final LoginNavigator navigator;
  final Show show;
  final UserUseCases userUseCases;

  LoginCubit(
    this.initialParams,
    this.authDataSource,
    this.show,
    this.navigator,
    this.userUseCases,
  ) : super(LoginState.initial(initialParams: initialParams));

  void goBack(BuildContext context) {
    if (navigator.navigator.canPop(context)) {
      navigator.navigator.pop(context);
      return;
    }

    navigator.openOnboarding(const OnboardingInitialParams());
  }

  Future<void> login({required LoginModel body}) async {
    emit(state.copyWith(isLoading: true));
    final response = await authDataSource.login(body);

    await response.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false));
        show.showErrorSnackBar(failure.error);
      },
      (userData) async {
        await _handleAuthSuccess(userData);
      },
    );
  }

  Future<void> _handleAuthSuccess(Map<String, dynamic> userData) async {
    final result = await userUseCases.execute(userData: userData);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
        show.showErrorSnackBar(failure.error);
      },
      (_) {
        emit(state.copyWith(isLoading: false));
        show.showSuccessSnackBar('Welcome back!');
        navigator.openBottomNav(const BottomNavInitialParams());
      },
    );
  }
}
