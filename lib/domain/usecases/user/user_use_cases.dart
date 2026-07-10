import 'package:fpdart/fpdart.dart';

import 'package:flutter_test_app/data/datasources/user/user_data_sources.dart';
import 'package:flutter_test_app/data/models/user/user_info_store_model.dart';
import 'package:flutter_test_app/domain/failures/network/network_failure.dart';
import 'package:flutter_test_app/domain/repositories/local/local_storage_base_api_service.dart';

class UserUseCases {
  final UserDataSources _userDataSources;
  final LocalStorageBaseApiService _localStorageRepository;
  UserUseCases(this._userDataSources, this._localStorageRepository);
  Future<Either<NetworkFailure, UserInfoStoreModel>> execute({
    required Map<String, dynamic> userData,
  }) async => await _localStorageRepository
      .setUserData(userInfoStoreModel: UserInfoStoreModel.fromJson(userData))
      .then(
        (value) => value.fold((l) => left(NetworkFailure(error: l.error)), (
          tokenRight,
        ) {
          _userDataSources.setUserDataSources(
            userInfoStoreModel: UserInfoStoreModel.fromJson(userData),
          );
          return right(UserInfoStoreModel.fromJson(userData));
        }),
      );
}
