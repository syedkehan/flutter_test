import 'package:fpdart/fpdart.dart';
import 'package:flutter_test_app/domain/failures/network/network_failure.dart';
import 'package:flutter_test_app/domain/repositories/network/network_base_api_service.dart';

/// Call API + parse response in one place.
/// Replace [url], [parser], and your model — then build UI from result.
class ApiRequestHelper {
  ApiRequestHelper._();

  static Future<Either<NetworkFailure, T>> get<T>({
    required NetworkBaseApiService api,
    required String url,
    required T Function(dynamic json) parser,
    Map<String, dynamic>? queryParams,
  }) async {
    final result = await api.get<dynamic>(
      url: url,
      queryParams: queryParams,
    );
    return result.map(parser);
  }

  static Future<Either<NetworkFailure, T>> post<T>({
    required NetworkBaseApiService api,
    required String url,
    required Map<String, dynamic> body,
    required T Function(dynamic json) parser,
    Map<String, dynamic>? queryParams,
  }) async {
    final result = await api.post<dynamic>(
      url: url,
      body: body,
      queryParams: queryParams,
    );
    return result.map(parser);
  }
}
