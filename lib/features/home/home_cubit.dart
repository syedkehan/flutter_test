import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/config/response/api_response.dart';
import 'package:flutter_test_app/core/show/show/show.dart';
import 'package:flutter_test_app/core/utils/api_request_helper.dart';
import 'package:flutter_test_app/core/utils/api_response_parser.dart';
import 'package:flutter_test_app/core/utils/app_url.dart';
import 'package:flutter_test_app/data/models/home/home_model.dart';
import 'package:flutter_test_app/domain/repositories/network/network_base_api_service.dart';

import 'home_initial_params.dart';
import 'home_navigator.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeInitialParams initialParams;
  final HomeNavigator navigator;
  final NetworkBaseApiService networkRepository;
  final Show show;

  HomeCubit(
    this.initialParams,
    this.navigator,
    this.networkRepository,
    this.show,
  ) : super(HomeState.initial(initialParams: initialParams)) {
    homeGet();
  }

  /// GET — change [AppUrl.posts] + [PostModel.fromJson] only.
  Future<void> homeGet() async {
    emit(state.copyWith(posts: ApiResponse.loading()));

    final result = await ApiRequestHelper.get<List<PostModel>>(
      api: networkRepository,
      url: AppUrl.posts,
      parser: (json) => ApiResponseParser.parseList(
        json,
        fromJson: PostModel.fromJson,
        // dataKey: 'data',
        // listKey: 'items',
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(posts: ApiResponse.error(failure))),
      (posts) => emit(state.copyWith(posts: ApiResponse.completed(posts))),
    );
  }

  /// POST — change URL, body, and model only.
  Future<void> homePost() async {
    emit(state.copyWith(createdPost: ApiResponse.loading()));

    final result = await ApiRequestHelper.post<PostModel?>(
      api: networkRepository,
      url: AppUrl.posts,
      body: {
        'title': 'Flutter template',
        'body': 'Created from template',
        'userId': 1,
      },
      parser: (json) => ApiResponseParser.parseObject(
        json,
        fromJson: PostModel.fromJson,
        // dataKey: 'data',
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(createdPost: ApiResponse.error(failure))),
      (post) {
        emit(state.copyWith(createdPost: ApiResponse.completed(post)));
        if (post != null) {
          show.showSuccessSnackBar('Created: ${post.title}');
        }
        homeGet();
      },
    );
  }
}
