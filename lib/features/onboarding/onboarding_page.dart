import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/config/theme/app_text_styles.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';

import 'onboarding_cubit.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingCubit cubit;

  const OnboardingPage({super.key, required this.cubit});

  @override
  State<OnboardingPage> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingPage> {
  OnboardingCubit get cubit => widget.cubit;

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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          92.verticalSpace,
                          AppConstants.logo(
                            width: 96.w,
                            height: 96.h,
                          ),
                          32.verticalSpace,
                          Text(
                            'Build your next\nFlutter app faster.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineLarge,
                          ),
                          Text(
                            'Start today!',
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineLarge?.copyWith(
                              color: context.colorScheme.primary,
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            'A clean starter with splash, onboarding,\n'
                            'auth flow, and bottom navigation.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff5A6274),
                              fontFamily: urbanist,
                            ),
                          ),
                          24.verticalSpace,
                          Center(
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _featurePoint(
                                    icon: Icons.architecture_outlined,
                                    label: 'Clean Architecture',
                                    context: context,
                                  ),
                                  12.verticalSpace,
                                  _featurePoint(
                                    icon: Icons.account_tree_outlined,
                                    label: 'BLoC State Management',
                                    context: context,
                                  ),
                                  12.verticalSpace,
                                  _featurePoint(
                                    icon: Icons.navigation_outlined,
                                    label: 'Navigation & DI Ready',
                                    context: context,
                                  ),
                                  12.verticalSpace,
                                  _featurePoint(
                                    icon: Icons.palette_outlined,
                                    label: 'Theme & API Layer',
                                    context: context,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 75.h, top: 24.h),
                        child: Column(
                          children: [
                            AppButton.getButton(
                              context: context,
                              onPressed: () => cubit.onSignUpPressed(),
                              text: 'Sign Up',
                            ),
                            12.verticalSpace,
                            AppButton.getButton(
                              context: context,
                              backgroundColor: Colors.white,
                              foregroundColor: context.colorScheme.primary,
                              onPressed: () => cubit.onLoginPressed(),
                              text: 'Sign In',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _featurePoint({
  required IconData icon,
  required String label,
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, size: 20.r, color: context.colorScheme.primary),
      14.horizontalSpace,
      Text(
        label,
        style: context.textTheme.titleMedium?.copyWith(
          fontFamily: urbanist,
          color: const Color(0xFF5A6274),
        ),
      ),
    ],
  );
}
