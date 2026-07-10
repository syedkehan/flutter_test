import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test_app/data/models/auth/login_model.dart';
import 'package:flutter_test_app/data/models/auth/signup_model.dart';
import 'package:flutter_test_app/domain/failures/network/network_failure.dart';

class DummyAuthDataSource {
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = 'password123';

  Future<Either<NetworkFailure, Map<String, dynamic>>> login(
    LoginModel body,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!_isValidEmail(body.email)) {
      return left(NetworkFailure(error: 'Please enter a valid email address'));
    }

    if (body.password.length < 6) {
      return left(
        NetworkFailure(error: 'Password must be at least 6 characters'),
      );
    }

    return right(
      _authResponse(
        fullName: 'Demo User',
        email: body.email.trim(),
        phone: '+441111111111',
      ),
    );
  }

  Future<Either<NetworkFailure, Map<String, dynamic>>> signUp(
    SignUpModel body,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));

    if (body.fullName.trim().length < 2) {
      return left(NetworkFailure(error: 'Please enter your full name'));
    }

    if (!_isValidEmail(body.email)) {
      return left(NetworkFailure(error: 'Please enter a valid email address'));
    }

    if (body.phone.trim().length < 8) {
      return left(NetworkFailure(error: 'Please enter a valid phone number'));
    }

    if (body.password.length < 6) {
      return left(
        NetworkFailure(error: 'Password must be at least 6 characters'),
      );
    }

    return right(
      _authResponse(
        fullName: body.fullName.trim(),
        email: body.email.trim(),
        phone: body.phone.trim(),
        dateOfBirth: body.dateOfBirth,
      ),
    );
  }

  Map<String, dynamic> _authResponse({
    required String fullName,
    required String email,
    required String phone,
    String? dateOfBirth,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    final id = _randomId();

    return {
      'user': {
        'id': id,
        'phone': phone,
        'email': email,
        'fullName': fullName,
        'profileImage': null,
        'dob': dateOfBirth,
        'country': null,
        'role': 'user',
        'status': 'active',
        'pricingTierKey': 'starter',
        'lifetimePurchasedTokens': 0,
        'authProviders': ['email'],
        'notificationSettings': {
          'push': {
            'push': true,
            'messagesFromAdvisors': false,
            'specialOffers': false,
          },
          'email': {
            'email': email,
            'messagesFromAdvisors': true,
            'specialOffers': false,
          },
        },
        'createdAt': now,
        'updatedAt': now,
        'lastLoginAt': now,
        'deletedAt': null,
        'remainingTokens': 0,
      },
      'accessToken': 'dummy_access_token_$id',
      'refreshToken': 'dummy_refresh_token_$id',
      'tokenType': 'Bearer',
    };
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  String _randomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(24, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
