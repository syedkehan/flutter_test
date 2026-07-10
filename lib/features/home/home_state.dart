import 'package:flutter_test_app/config/response/api_response.dart';
import 'package:flutter_test_app/data/models/home/home_model.dart';
import 'package:flutter_test_app/features/home/home_initial_params.dart';

class HomeState {
  final ApiResponse<List<PostModel>> posts;
  final ApiResponse<PostModel?> createdPost;

  HomeState({
    required this.posts,
    required this.createdPost,
  });

  factory HomeState.initial({required HomeInitialParams initialParams}) =>
      HomeState(
        posts: ApiResponse.initial(<PostModel>[]),
        createdPost: ApiResponse.initial(null),
      );

  HomeState copyWith({
    ApiResponse<List<PostModel>>? posts,
    ApiResponse<PostModel?>? createdPost,
  }) =>
      HomeState(
        posts: posts ?? this.posts,
        createdPost: createdPost ?? this.createdPost,
      );
}
