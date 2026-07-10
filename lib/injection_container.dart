import 'package:get_it/get_it.dart';

import 'package:flutter_test_app/config/navigation/app_navigator.dart';
import 'package:flutter_test_app/core/show/show/show.dart';
import 'package:flutter_test_app/data/datasources/auth/dummy_auth_data_source.dart';
import 'package:flutter_test_app/data/datasources/theme/theme_data_source.dart';
import 'package:flutter_test_app/data/datasources/user/user_data_sources.dart';
import 'package:flutter_test_app/data/repositories/local/local_storage_repository.dart';
import 'package:flutter_test_app/data/repositories/network/dio/dio_network_repository.dart';
import 'package:flutter_test_app/data/repositories/network/errors/api_error_handler.dart';
import 'package:flutter_test_app/domain/repositories/local/local_storage_base_api_service.dart';
import 'package:flutter_test_app/domain/repositories/network/network_base_api_service.dart';
import 'package:flutter_test_app/domain/usecases/local/check_for_existing_user_use_case.dart';
import 'package:flutter_test_app/domain/usecases/theme/get_theme_use_case.dart';
import 'package:flutter_test_app/domain/usecases/theme/update_theme_use_case.dart';
import 'package:flutter_test_app/domain/usecases/user/user_use_cases.dart';
import 'package:flutter_test_app/features/auth/login/login_cubit.dart';
import 'package:flutter_test_app/features/auth/login/login_initial_params.dart';
import 'package:flutter_test_app/features/auth/login/login_navigator.dart';
import 'package:flutter_test_app/features/auth/signup/signup_cubit.dart';
import 'package:flutter_test_app/features/auth/signup/signup_initial_params.dart';
import 'package:flutter_test_app/features/auth/signup/signup_navigator.dart';
import 'package:flutter_test_app/features/home/home_cubit.dart';
import 'package:flutter_test_app/features/home/home_initial_params.dart';
import 'package:flutter_test_app/features/home/home_navigator.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_cubit.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_initial_params.dart';
import 'package:flutter_test_app/features/bottom_nav/bottom_nav_navigator.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_cubit.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_initial_params.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_navigator.dart';
import 'package:flutter_test_app/features/splash/splash_cubit.dart';
import 'package:flutter_test_app/features/splash/splash_initial_params.dart';
import 'package:flutter_test_app/features/splash/splash_navigator.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerSingleton<AppNavigator>(AppNavigator());
  getIt.registerSingleton<UserDataSources>(UserDataSources());
  getIt.registerSingleton<LocalStorageBaseApiService>(LocalStorageRepository());
  getIt.registerSingleton<UserUseCases>(UserUseCases(getIt(), getIt()));
  getIt.registerSingleton<CheckForExistingUserUseCase>(
    CheckForExistingUserUseCase(getIt(), getIt()),
  );
  getIt.registerSingleton<ApiErrorHandler>(const ApiErrorHandler());
  getIt.registerSingleton<NetworkBaseApiService>(
    DioNetworkRepository(getIt(), getIt(), getIt()),
  );
  getIt.registerSingleton<ThemeDataSources>(ThemeDataSources());
  getIt.registerSingleton<GetThemeUseCase>(GetThemeUseCase(getIt(), getIt()));
  getIt.registerSingleton<UpdateThemeUseCase>(
    UpdateThemeUseCase(getIt(), getIt()),
  );
  getIt.registerSingleton<Show>(Show());
  getIt.registerSingleton<DummyAuthDataSource>(DummyAuthDataSource());

  getIt.registerSingleton<SplashNavigator>(SplashNavigator(getIt()));
  getIt.registerFactoryParam<SplashCubit, SplashInitialParams, dynamic>(
    (params, _) => SplashCubit(params, getIt(), getIt(), getIt()),
  );

  getIt.registerSingleton<LoginNavigator>(LoginNavigator(getIt()));
  getIt.registerFactoryParam<LoginCubit, LoginInitialParams, dynamic>(
    (params, _) => LoginCubit(params, getIt(), getIt(), getIt(), getIt()),
  );

  getIt.registerSingleton<SignUpNavigator>(SignUpNavigator(getIt()));
  getIt.registerFactoryParam<SignUpCubit, SignUpInitialParams, dynamic>(
    (params, _) => SignUpCubit(params, getIt(), getIt(), getIt(), getIt()),
  );

  getIt.registerSingleton<OnboardingNavigator>(OnboardingNavigator(getIt()));
  getIt.registerFactoryParam<OnboardingCubit, OnboardingInitialParams, dynamic>(
    (params, _) => OnboardingCubit(params, getIt()),
  );

  getIt.registerSingleton<HomeNavigator>(HomeNavigator(getIt()));
  getIt.registerFactoryParam<HomeCubit, HomeInitialParams, dynamic>(
    (params, _) => HomeCubit(params, getIt(), getIt(), getIt()),
  );

  getIt.registerSingleton<BottomNavNavigator>(BottomNavNavigator(getIt()));
  getIt.registerFactoryParam<BottomNavCubit, BottomNavInitialParams, dynamic>(
    (params, _) => BottomNavCubit(params, getIt()),
  );
}
