import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_test_app/data/models/user/user_info_store_model.dart';
import 'package:flutter_test_app/domain/failures/local/get_local_storage_failure.dart';
import 'package:flutter_test_app/domain/failures/local/remove_local_storage_failure.dart';
import 'package:flutter_test_app/domain/failures/local/set_local_storage_failure.dart';
import 'package:flutter_test_app/domain/repositories/local/local_storage_base_api_service.dart';

class LocalStorageRepository implements LocalStorageBaseApiService {
  LocalStorageRepository()
    : _storage = const FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      );

  final FlutterSecureStorage _storage;

  @override
  Future<Either<SetLocalStorageFailure, bool>> setUserData({
    required UserInfoStoreModel userInfoStoreModel,
  }) async {
    try {
      final userJson = jsonEncode(userInfoStoreModel.toJson());
      await _storage.write(key: 'user_info', value: userJson);
      return right(true);
    } catch (ex) {
      return left(SetLocalStorageFailure(error: ex.toString()));
    }
  }

  @override
  Future<Either<GetLocalStorageFailure, UserInfoStoreModel>>
  getUserData() async {
    try {
      final userJson = await _storage.read(key: 'user_info');
      if (userJson == null) {
        return right(UserInfoStoreModel.empty());
      }
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return right(UserInfoStoreModel.fromJson(userMap));
    } catch (ex) {
      debugPrint('getUserData failed: $ex');
      return left(GetLocalStorageFailure(error: ex.toString()));
    }
  }

  @override
  Future<Either<RemoveLocalStorageFailure, bool>> removeUserData() async {
    try {
      await _storage.delete(key: 'user_info');
      return right(true);
    } catch (ex) {
      return left(RemoveLocalStorageFailure(error: ex.toString()));
    }
  }

  @override
  Future<Either<GetLocalStorageFailure, bool>> getBool({
    required String key,
  }) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null) {
        return right(false);
      }
      return right(value.toLowerCase() == 'true');
    } catch (ex) {
      debugPrint('getBool($key) failed: $ex');
      return left(GetLocalStorageFailure(error: ex.toString()));
    }
  }

  @override
  Future<Either<SetLocalStorageFailure, bool>> setBool({
    required String key,
    required bool value,
  }) async {
    try {
      await _storage.write(key: key, value: value.toString());
      return right(true);
    } catch (ex) {
      return left(SetLocalStorageFailure(error: ex.toString()));
    }
  }
}
