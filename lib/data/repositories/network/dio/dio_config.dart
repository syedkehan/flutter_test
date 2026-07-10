import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_test_app/config/navigation/app_navigator.dart';
import 'package:flutter_test_app/core/constants/global.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_initial_params.dart';
import 'package:flutter_test_app/features/onboarding/onboarding_navigator.dart';
import 'package:flutter_test_app/injection_container.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'package:flutter_test_app/core/utils/app_url.dart';
import 'package:flutter_test_app/data/datasources/user/user_data_sources.dart';
import 'package:flutter_test_app/data/models/user/user_info_store_model.dart';
import 'package:flutter_test_app/domain/repositories/local/local_storage_base_api_service.dart';

class DioConfig {
  static Dio createDio({
    required UserDataSources userDataSources,
    required LocalStorageBaseApiService localStorageRepository,
  }) {
    final dio = Dio();

    dio.options = BaseOptions(headers: {'Content-Type': 'application/json'});

    dio.interceptors.addAll([
      AuthInterceptor(
        dio: dio,
        userDataSources: userDataSources,
        localStorageRepository: localStorageRepository,
      ),
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printErrorHeaders: false,
          printErrorMessage: false,
        ),
      ),
    ]);

    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final UserDataSources _userDataSources;
  final LocalStorageBaseApiService _localStorageRepository;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  AuthInterceptor({
    required Dio dio,
    required UserDataSources userDataSources,
    required LocalStorageBaseApiService localStorageRepository,
  }) : _dio = dio,
       _userDataSources = userDataSources,
       _localStorageRepository = localStorageRepository;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _userDataSources.state.accessToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only handle 401s that are NOT from the refresh endpoint itself
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path == AppUrl.refreshToken) {
      return handler.next(err);
    }

    // If already refreshing, queue this request
    if (_isRefreshing) {
      _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
      return;
    }

    _isRefreshing = true;

    try {
      final newAccessToken = await _refreshToken();

      if (newAccessToken != null) {
        // Retry the original request — use its own catch so a non-auth failure
        // (e.g. 400 business error) doesn't trigger a spurious session expiry.
        try {
          final retried = await _retryRequest(
            err.requestOptions,
            newAccessToken,
          );
          handler.resolve(retried);
        } on DioException catch (retryErr) {
          handler.next(retryErr);
        }

        // Retry all queued requests
        for (final pending in _pendingRequests) {
          try {
            final retriedPending = await _retryRequest(
              pending.requestOptions,
              newAccessToken,
            );
            pending.handler.resolve(retriedPending);
          } on DioException catch (retryErr) {
            pending.handler.next(retryErr);
          } catch (e) {
            log('Failed to retry pending request: $e');
            pending.handler.next(err);
          }
        }
      } else {
        // Refresh failed — reject original + all queued requests
        handler.next(err);
        for (final pending in _pendingRequests) {
          pending.handler.next(err);
        }
        await _onSessionExpired();
      }
    } catch (e) {
      log('Token refresh failed: $e');
      handler.next(err);
      for (final pending in _pendingRequests) {
        pending.handler.next(err);
      }
      await _onSessionExpired();
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  Future<String?> _refreshToken() async {
    final refreshToken = _userDataSources.state.refreshToken;
    if (refreshToken.isEmpty) {
      log('No refresh token available');
      return null;
    }

    // Dedicated Dio for refresh — bypasses the auth interceptor to avoid loops
    final refreshDio = Dio(
      BaseOptions(
        headers: {'Content-Type': 'application/json'},
        // Allow 4xx responses to be handled gracefully instead of throwing
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      final response = await refreshDio.post(
        AppUrl.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      log('Refresh token response [${response.statusCode}]: ${response.data}');

      // Accept both 200 and 201 — server returns 201 on success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newUserData = UserInfoStoreModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        // Update in-memory state FIRST so any concurrent retry reads
        // the new tokens immediately, avoiding "refresh token mismatch"
        _userDataSources.setUserDataSources(userInfoStoreModel: newUserData);

        // Then persist to local storage
        final saveResult = await _localStorageRepository.setUserData(
          userInfoStoreModel: newUserData,
        );

        saveResult.fold(
          (l) => log('Failed to persist new tokens: $l'),
          (r) => log('New tokens persisted successfully'),
        );

        final newAccessToken = newUserData.accessToken;
        return newAccessToken.isNotEmpty ? newAccessToken : null;
      } else {
        log('Refresh token rejected with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Refresh token request error: $e');
      return null;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
    return _dio.fetch(requestOptions);
  }

  Future _onSessionExpired() async {
    log('Session expired — clearing user data');
    await _localStorageRepository.removeUserData();
    final context = GlobalConstants.navigatorKey.currentContext;
    if (context != null) {
      _OnboardingRouteImpl(
        navigator: getIt<AppNavigator>(),
        context: context,
      ).openOnboarding(const OnboardingInitialParams());
    }
  }
}

class _OnboardingRouteImpl with OnboardingRoute {
  @override
  final AppNavigator navigator;
  @override
  final context;

  _OnboardingRouteImpl({required this.navigator, required this.context});
}

class _PendingRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _PendingRequest(this.requestOptions, this.handler);
}
