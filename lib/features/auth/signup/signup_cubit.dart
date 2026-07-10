import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/data/datasources/auth/dummy_auth_data_source.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_initial_params.dart';

import '/core/show/show/show.dart';
import '/data/models/auth/signup_model.dart';
import '/domain/usecases/user/user_use_cases.dart';
import 'signup_initial_params.dart';
import 'signup_navigator.dart';
import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpInitialParams initialParams;
  final DummyAuthDataSource authDataSource;
  final SignUpNavigator navigator;
  final Show show;
  final UserUseCases userUseCases;

  SignUpCubit(
    this.initialParams,
    this.authDataSource,
    this.show,
    this.navigator,
    this.userUseCases,
  ) : super(SignUpState.initial(initialParams: initialParams));

  Future<void> signUp({required SignUpModel body}) async {
    emit(state.copyWith(isLoading: true));
    final response = await authDataSource.signUp(body);

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
        show.showSuccessSnackBar('Account created successfully!');
        navigator.openBottomNav(const BottomNavInitialParams());
      },
    );
  }

  void updateDialCode({
    required String dialCode,
    required String countryName,
  }) => emit(
    state.copyWith(
      selectedDialCode: dialCode,
      selectedCountryName: countryName,
    ),
  );
}
