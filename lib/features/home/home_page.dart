import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/constants/status_switcher.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';
import 'package:flutter_test_app/data/models/home/home_model.dart';
import 'package:flutter_test_app/features/home/home_state.dart';

import 'home_cubit.dart';

class HomePage extends StatefulWidget {
  final HomeCubit cubit;

  const HomePage({super.key, required this.cubit});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: cubit,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppConstants.screenHorizontalPadding,
                    20.h,
                    AppConstants.screenHorizontalPadding,
                    12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Home', style: context.textTheme.headlineSmall),
                      8.verticalSpace,
                      Text(
                        'Replace API URL + model, then build UI from parsed data.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      16.verticalSpace,
                      AppButton.getButton(
                        context: context,
                        text: 'Create Post (POST)',
                        onPressed: cubit.homePost,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StatusSwitcher<List<PostModel>>(
                    response: state.posts,
                    onRetry: cubit.homeGet,
                    onCompleted: (context, posts) {
                      if (posts.isEmpty) {
                        return const Center(child: Text('No posts found'));
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          AppConstants.screenHorizontalPadding,
                          8.h,
                          AppConstants.screenHorizontalPadding,
                          24.h,
                        ),
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => 12.verticalSpace,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return _PostCard(post: post);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          8.verticalSpace,
          Text(
            post.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
